using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lab05.Admin
{
    public partial class QLTaiKhoan : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra bảo mật đã có trong Seller.Master (Role=2)
            if (!IsPostBack)
            {
                LoadAllAccounts();
            }
        }

        /// <summary>
        /// Tải toàn bộ danh sách khách hàng và seller
        /// </summary>
        private void LoadAllAccounts()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                // Sắp xếp người đang Online lên đầu, sau đó đến ngày đăng ký mới nhất
                // Lưu ý: Nếu DB chưa có cột IsOnline, hãy xóa nó khỏi câu lệnh SQL bên dưới
                string sql = @"SELECT MaKH, HoTenKH, TenDN, Email, MaRole, 
                             ISNULL(IsOnline, 0) as IsOnline, LastSeen 
                             FROM KhachHang 
                             ORDER BY IsOnline DESC, MaKH DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    gvAccounts.DataSource = dt;
                    gvAccounts.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Lỗi Load Tài Khoản: " + ex.Message);
                }
            }
        }
    }
}