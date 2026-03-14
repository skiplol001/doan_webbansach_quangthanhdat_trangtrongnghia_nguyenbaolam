using System;
using System.Web;
using System.Web.UI;

namespace lab05.Admin
{
    public partial class Seller : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kiểm tra tên người dùng từ Session
                if (Session["HoTen"] != null)
                {
                    litSellerName.Text = Session["HoTen"].ToString();
                }
                else if (Session["TenDN"] != null)
                {
                    litSellerName.Text = Session["TenDN"].ToString();
                }
            }
        }

        // --- XỬ LÝ ĐĂNG XUẤT [cite: 2026-03-14] ---
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Xóa sạch Session
            Session.Clear();
            Session.Abandon();

            // Xóa Cookie nếu có
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            // Chuyển hướng về trang chủ khách
            Response.Redirect("~/khach/trangchu.aspx");
        }
    }
}