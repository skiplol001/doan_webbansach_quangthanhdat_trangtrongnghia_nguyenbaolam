using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05.Seller
{
    public partial class QLDonHang : System.Web.UI.Page
    {
        // Chuỗi kết nối lấy từ Web.config
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;
        int pageSize = 10; // Số lượng đơn hàng hiển thị trên một trang

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Kiểm tra quyền truy cập (Chỉ cho phép Seller - MaRole = 2)
            if (Session["MaRole"] == null || Convert.ToInt32(Session["MaRole"]) != 2)
            {
                Response.Redirect("~/khach/dangnhap.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrderData();
            }
        }

        // --- HÀM TẢI DỮ LIỆU ĐƠN HÀNG KÈM PHÂN TRANG ---
        private void LoadOrderData()
        {
            int currentPage = 1;
            if (Request.QueryString["page"] != null) int.TryParse(Request.QueryString["page"], out currentPage);

            // Xử lý từ khóa tìm kiếm
            string keyword = txtSearch.Text.Trim();
            if (string.IsNullOrEmpty(keyword) && Request.QueryString["search"] != null)
            {
                keyword = Server.UrlDecode(Request.QueryString["search"]);
                txtSearch.Text = keyword;
            }

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Đếm tổng số đơn hàng để tính toán bộ phân trang
                string countSql = @"SELECT COUNT(*) FROM DonDatHang D 
                                    JOIN KhachHang K ON D.MaKH = K.MaKH 
                                    WHERE D.SoDH LIKE @key OR K.HoTenKH LIKE @key";

                SqlCommand cmdCount = new SqlCommand(countSql, conn);
                cmdCount.Parameters.AddWithValue("@key", "%" + keyword + "%");

                conn.Open();
                int totalRecords = (int)cmdCount.ExecuteScalar();
                int totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
                conn.Close();

                // Truy vấn dữ liệu phân trang bằng OFFSET FETCH (SQL Server 2012+)
                string dataSql = @"SELECT D.SoDH, K.HoTenKH, D.NgayDH, ISNULL(D.Trigia, 0) as Trigia, D.Dagiao 
                                   FROM DonDatHang D JOIN KhachHang K ON D.MaKH = K.MaKH 
                                   WHERE D.SoDH LIKE @key OR K.HoTenKH LIKE @key 
                                   ORDER BY D.Dagiao ASC, D.NgayDH DESC 
                                   OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY";

                SqlDataAdapter da = new SqlDataAdapter(dataSql, conn);
                da.SelectCommand.Parameters.AddWithValue("@key", "%" + keyword + "%");
                da.SelectCommand.Parameters.AddWithValue("@offset", (currentPage - 1) * pageSize);
                da.SelectCommand.Parameters.AddWithValue("@limit", pageSize);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvOrders.DataSource = dt;
                gvOrders.DataBind();

                // Cập nhật giao diện phân trang trượt
                CreateSlidingPaging(currentPage, totalPages);
            }
        }

        // --- HÀM QUAN TRỌNG: GIẢI QUYẾT LỖI CS1061 & XỬ LÝ TRỪ KHO ---
        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Kiểm tra xem lệnh có phải là ConfirmDelivery (đã định nghĩa trong .aspx) không
            if (e.CommandName == "ConfirmDelivery")
            {
                int soDH = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    conn.Open();
                    // Bắt đầu một Transaction để đảm bảo: Nếu trừ kho lỗi thì đơn hàng không được đổi trạng thái
                    SqlTransaction trans = conn.BeginTransaction();

                    try
                    {
                        // Bước 1: Cập nhật trạng thái đơn hàng thành Đã giao
                        string sqlUpdateOrder = "UPDATE DonDatHang SET Dagiao = 1, Ngaygiao = GETDATE() WHERE SoDH = @soDH";
                        SqlCommand cmdUpdateOrder = new SqlCommand(sqlUpdateOrder, conn, trans);
                        cmdUpdateOrder.Parameters.AddWithValue("@soDH", soDH);
                        cmdUpdateOrder.ExecuteNonQuery();

                        // Bước 2: Lấy danh sách sản phẩm và số lượng trong đơn hàng này để trừ kho
                        string sqlGetItems = "SELECT MaSach, Soluong FROM CTDatHang WHERE SoDH = @soDH";
                        SqlCommand cmdGetItems = new SqlCommand(sqlGetItems, conn, trans);
                        cmdGetItems.Parameters.AddWithValue("@soDH", soDH);

                        SqlDataAdapter da = new SqlDataAdapter(cmdGetItems);
                        DataTable dtItems = new DataTable();
                        da.Fill(dtItems);

                        // Bước 3: Duyệt qua từng sản phẩm để thực hiện trừ số lượng tồn kho
                        foreach (DataRow row in dtItems.Rows)
                        {
                            int maSach = Convert.ToInt32(row["MaSach"]);
                            int slMua = Convert.ToInt32(row["Soluong"]);

                            string sqlUpdateStock = "UPDATE Sach SET Soluongton = Soluongton - @sl WHERE MaSach = @ms";
                            SqlCommand cmdUpdateStock = new SqlCommand(sqlUpdateStock, conn, trans);
                            cmdUpdateStock.Parameters.AddWithValue("@sl", slMua);
                            cmdUpdateStock.Parameters.AddWithValue("@ms", maSach);
                            cmdUpdateStock.ExecuteNonQuery();
                        }

                        // Nếu mọi thứ thành công, xác nhận các thay đổi vào Database
                        trans.Commit();
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Giao hàng thành công! Số lượng sách trong kho đã tự động cập nhật.');", true);
                    }
                    catch (Exception ex)
                    {
                        // Nếu có bất kỳ lỗi nào xảy ra, hoàn tác (Rollback) toàn bộ quá trình
                        trans.Rollback();
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Lỗi khi xử lý đơn hàng: {ex.Message}');", true);
                    }
                    finally { conn.Close(); }
                }
                // Nạp lại danh sách đơn hàng để cập nhật giao diện
                LoadOrderData();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Khi tìm kiếm, quay lại trang 1
            Response.Redirect(GetPageUrl(1));
        }

        private void CreateSlidingPaging(int current, int total)
        {
            if (total <= 1) { rptPaging.Visible = lnkFirst.Visible = lnkLast.Visible = lnkPrev.Visible = lnkNext.Visible = false; return; }
            rptPaging.Visible = true;

            lnkFirst.NavigateUrl = GetPageUrl(1);
            lnkLast.NavigateUrl = GetPageUrl(total);
            lnkPrev.NavigateUrl = GetPageUrl(current > 1 ? current - 1 : 1);
            lnkNext.NavigateUrl = GetPageUrl(current < total ? current + 1 : total);

            int startPage = Math.Max(1, current - 2);
            int endPage = Math.Min(total, startPage + 4);
            if (endPage - startPage < 4) startPage = Math.Max(1, endPage - 4);

            var pageNodes = new List<object>();
            for (int i = startPage; i <= endPage; i++)
            {
                pageNodes.Add(new { PageIndex = i, PageText = i, IsActive = (i == current) });
            }

            rptPaging.DataSource = pageNodes;
            rptPaging.DataBind();
        }

        public string GetPageUrl(object pageNum)
        {
            string searchParam = !string.IsNullOrEmpty(txtSearch.Text) ? "&search=" + Server.UrlEncode(txtSearch.Text) : "";
            return "QLDonHang.aspx?page=" + pageNum + searchParam;
        }
    }
}