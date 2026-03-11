using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;

namespace lab05.Seller
{
    public partial class QLDonHang : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;
        int pageSize = 10; // Giới hạn 10 đơn hàng mỗi trang

        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra bảo mật
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

        private void LoadOrderData()
        {
            // 1. Xác định trang hiện tại [cite: 2026-03-11]
            int currentPage = 1;
            if (Request.QueryString["page"] != null) int.TryParse(Request.QueryString["page"], out currentPage);

            // Lấy từ khóa tìm kiếm (nếu có)
            string keyword = txtSearch.Text.Trim();
            if (string.IsNullOrEmpty(keyword) && Request.QueryString["search"] != null)
            {
                keyword = Server.UrlDecode(Request.QueryString["search"]);
                txtSearch.Text = keyword;
            }

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // 2. Tính tổng số đơn hàng để phân trang
                string countSql = @"SELECT COUNT(*) FROM DonDatHang D 
                                    JOIN KhachHang K ON D.MaKH = K.MaKH 
                                    WHERE D.SoDH LIKE @key OR K.HoTenKH LIKE @key";

                SqlCommand cmdCount = new SqlCommand(countSql, conn);
                cmdCount.Parameters.AddWithValue("@key", "%" + keyword + "%");

                conn.Open();
                int totalRecords = (int)cmdCount.ExecuteScalar();
                int totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
                conn.Close();

                // 3. Truy vấn dữ liệu theo cơ chế OFFSET FETCH (Phân trang SQL chuẩn) [cite: 2026-03-11]
                string dataSql = @"SELECT D.SoDH, K.HoTenKH, D.NgayDH, ISNULL(D.Trigia, 0) as Trigia, D.Dagiao 
                                   FROM DonDatHang D JOIN KhachHang K ON D.MaKH = K.MaKH 
                                   WHERE D.SoDH LIKE @key OR K.HoTenKH LIKE @key 
                                   ORDER BY D.NgayDH DESC 
                                   OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY";

                SqlDataAdapter da = new SqlDataAdapter(dataSql, conn);
                da.SelectCommand.Parameters.AddWithValue("@key", "%" + keyword + "%");
                da.SelectCommand.Parameters.AddWithValue("@offset", (currentPage - 1) * pageSize);
                da.SelectCommand.Parameters.AddWithValue("@limit", pageSize);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvOrders.DataSource = dt;
                gvOrders.DataBind();

                // 4. Cấu hình bộ phân trang trượt 5 nút
                CreateSlidingPaging(currentPage, totalPages);
            }
        }

        // --- HÀM FIX LỖI CS1061: ĐỊNH NGHĨA SỰ KIỆN TÌM KIẾM [cite: 2026-03-11] ---
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Reset về trang 1 và nạp lại dữ liệu dựa trên từ khóa mới
            Response.Redirect(GetPageUrl(1));
        }

        // --- LOGIC PHÂN TRANG SLIDING WINDOW CHUẨN ---
        private void CreateSlidingPaging(int current, int total)
        {
            if (total <= 1) { lnkFirst.Visible = lnkLast.Visible = lnkPrev.Visible = lnkNext.Visible = rptPaging.Visible = false; return; }
            rptPaging.Visible = true;

            lnkFirst.NavigateUrl = GetPageUrl(1);
            lnkLast.NavigateUrl = GetPageUrl(total);
            lnkPrev.NavigateUrl = GetPageUrl(current > 1 ? current - 1 : 1);
            lnkNext.NavigateUrl = GetPageUrl(current < total ? current + 1 : total);

            // Thuật toán: startPage và endPage để nút đang chọn luôn ở giữa dải 5 nút [cite: 2026-03-11]
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

        // Tạo URL thông minh giữ lại tham số tìm kiếm khi chuyển trang [cite: 2026-03-11]
        public string GetPageUrl(object pageNum)
        {
            string searchParam = !string.IsNullOrEmpty(txtSearch.Text) ? "&search=" + Server.UrlEncode(txtSearch.Text) : "";
            return "QLDonHang.aspx?page=" + pageNum + searchParam;
        }
    }
}