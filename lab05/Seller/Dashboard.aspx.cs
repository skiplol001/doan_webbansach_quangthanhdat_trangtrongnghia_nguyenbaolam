using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace lab05.Admin
{
    // FIX: Bắt buộc kế thừa từ Page vì đây là trang nội dung
    public partial class Dashboard : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Bảo mật: Chặn người dùng không phải Seller (Role 2)
            if (Session["MaRole"] == null || Session["MaRole"].ToString() != "2")
            {
                Response.Redirect("~/khach/trangchu.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStatistics();
                LoadRecentOrders();
            }
        }

        private void LoadStatistics()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                try
                {
                    conn.Open();

                    // 1. Tính tổng doanh thu (Xử lý Null khi chưa có đơn hàng)
                    SqlCommand cmdRev = new SqlCommand("SELECT SUM(Trigia) FROM DonDatHang", conn);
                    object rev = cmdRev.ExecuteScalar();
                    litRevenue.Text = (rev != null && rev != DBNull.Value) ? string.Format("{0:#,##0}", rev) : "0";

                    // 2. Tổng số đơn hàng
                    SqlCommand cmdOrd = new SqlCommand("SELECT COUNT(*) FROM DonDatHang", conn);
                    litOrders.Text = cmdOrd.ExecuteScalar().ToString();

                    // 3. Tổng số đầu sách hiện có
                    SqlCommand cmdBook = new SqlCommand("SELECT COUNT(*) FROM Sach", conn);
                    litBooks.Text = cmdBook.ExecuteScalar().ToString();
                }
                catch (Exception ex)
                {
                    // Log lỗi nếu cần thiết
                    litRevenue.Text = "Lỗi kết nối";
                }
            }
        }

        private void LoadRecentOrders()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Lấy 5 đơn hàng mới nhất, join với khách hàng để lấy tên
                string sql = @"SELECT TOP 5 d.SoDH, d.NgayDH, d.Trigia, d.Dagiao, k.HoTenKH 
                             FROM DonDatHang d JOIN KhachHang k ON d.MaKH = k.MaKH 
                             ORDER BY d.NgayDH DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();

                try
                {
                    da.Fill(dt);
                    gvRecentOrders.DataSource = dt;
                    gvRecentOrders.DataBind();
                }
                catch
                {
                    // Xử lý lỗi SQL nếu có
                }
            }
        }
    }
}