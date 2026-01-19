using System;
using System.Web;
using System.Web.UI;

namespace lab05.Admin
{
    public partial class Seller : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Kiểm tra đăng nhập
            if (Session["MaKH"] == null)
            {
                Response.Redirect("~/khach/dangnhap.aspx");
                return;
            }

            // 2. Bảo mật: Chỉ cho phép tài khoản có MaRole = 2 (Seller) truy cập
            if (Session["MaRole"] == null || Session["MaRole"].ToString() != "2")
            {
                // Nếu là khách thường, đuổi về trang chủ khách
                Response.Redirect("~/khach/trangchu.aspx");
                return;
            }

            // 3. Hiển thị tên người bán lên Topbar
            if (!IsPostBack)
            {
                if (Session["HoTen"] != null)
                {
                    litSellerName.Text = Session["HoTen"].ToString();
                }
            }
        }

        /// <summary>
        /// Xử lý đăng xuất cho người bán
        /// </summary>
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Xóa sạch Session
            Session.RemoveAll();
            Session.Abandon();

            // Xóa Cookie nếu có
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            // Điều hướng về trang đăng nhập
            Response.Redirect("~/khach/dangnhap.aspx");
        }
    }
}