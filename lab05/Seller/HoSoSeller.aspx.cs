using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace lab05.Admin
{
    public partial class HoSoSeller : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Bảo mật Role đã được Seller.Master xử lý, ở đây chỉ cần load data
            if (!IsPostBack)
            {
                LoadSellerProfile();
                LoadStoreStats();
            }
        }

        /// <summary>
        /// Tải thông tin người bán và thực hiện logic "Thiếu thì ẩn"
        /// </summary>
        private void LoadSellerProfile()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                // Sửa tên cột theo cấu trúc chuẩn: Diachi, Dienthoai
                string sql = "SELECT HoTenKH, TenDN, Email, Diachi, Dienthoai FROM KhachHang WHERE MaKH = @ID";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@ID", Session["MaKH"]);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    // Áp dụng hàm SetField để ẩn Panel nếu dữ liệu rỗng
                    SetField(pnlHoTen, litHoTen, dr["HoTenKH"]);
                    SetField(pnlTenDN, litTenDN, dr["TenDN"]);
                    SetField(pnlEmail, litEmail, dr["Email"]);
                    SetField(pnlPhone, litPhone, dr["Dienthoai"]);
                    SetField(pnlAddress, litAddress, dr["Diachi"]);
                }
                con.Close();
            }
        }

        /// <summary>
        /// Hàm bổ trợ: Kiểm tra dữ liệu, nếu trống thì ẩn toàn bộ hàng thông tin
        /// </summary>
        private void SetField(Panel pnl, Literal lit, object val)
        {
            if (val != null && val != DBNull.Value && !string.IsNullOrWhiteSpace(val.ToString()))
            {
                lit.Text = val.ToString();
                pnl.Visible = true;
            }
            else
            {
                pnl.Visible = false; // Ẩn hoàn toàn nếu không có dữ liệu
            }
        }

        /// <summary>
        /// Tải các chỉ số thống kê cơ bản của gian hàng
        /// </summary>
        private void LoadStoreStats()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                con.Open();

                // 1. Đếm tổng số sách
                SqlCommand cmdSach = new SqlCommand("SELECT COUNT(*) FROM Sach", con);
                litTotalBooks.Text = cmdSach.ExecuteScalar().ToString();

                // 2. Đếm tổng số đơn hàng
                SqlCommand cmdDon = new SqlCommand("SELECT COUNT(*) FROM DonDatHang", con);
                litTotalOrders.Text = cmdDon.ExecuteScalar().ToString();

                con.Close();
            }
        }
    }
}