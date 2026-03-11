using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lab05
{
    public partial class dangnhap : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Nếu đã đăng nhập rồi thì về trang chủ luôn
            if (Session["MaKH"] != null) Response.Redirect("trangchu.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = txtUsername.Text.Trim();
            string pass = txtPassword.Text.Trim();

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Truy vấn lấy cả ảnh đại diện AnhKH [cite: 2026-03-11]
                string sql = "SELECT MaKH, HoTenKH, MaRole, AnhKH FROM KhachHang WHERE TenDN=@u AND Matkhau=@p";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@u", user);
                cmd.Parameters.AddWithValue("@p", pass);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // 1. LƯU THÔNG TIN CƠ BẢN VÀO SESSION
                    Session["MaKH"] = dr["MaKH"].ToString();
                    Session["HoTen"] = dr["HoTenKH"].ToString();
                    Session["MaRole"] = dr["MaRole"].ToString();

                    // 2. LOGIC DỰ PHÒNG ẢNH ĐẠI DIỆN [cite: 2026-03-11]
                    // Nếu cột AnhKH trống, gán ngay 'no-avatar.jpg' để tránh lỗi load ảnh liên tục
                    string avatar = dr["AnhKH"].ToString();
                    if (string.IsNullOrEmpty(avatar))
                    {
                        Session["AnhKH"] = "no-avatar.jpg";
                    }
                    else
                    {
                        Session["AnhKH"] = avatar;
                    }

                    dr.Close();

                    // 3. CẬP NHẬT TRẠNG THÁI ONLINE
                    UpdateStatus(Session["MaKH"].ToString(), 1);

                    // 4. CHUYỂN HƯỚNG THEO VAI TRÒ
                    if (Session["MaRole"].ToString() == "2") // Seller/Admin
                        Response.Redirect("~/Seller/Dashboard.aspx");
                    else
                        Response.Redirect("trangchu.aspx");
                }
                else
                {
                    lblMessage.Text = "<i class='fa-solid fa-triangle-exclamation'></i> Sai tài khoản hoặc mật khẩu!";
                    lblMessage.Visible = true;
                }
            }
        }

        private void UpdateStatus(string maKH, int status)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    string sql = "UPDATE KhachHang SET IsOnline = @s, LastSeen = GETDATE() WHERE MaKH = @id";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@s", status);
                    cmd.Parameters.AddWithValue("@id", maKH);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch { /* Bỏ qua lỗi cập nhật trạng thái để không làm gián đoạn đăng nhập */ }
        }
    }
}