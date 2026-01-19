using System;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class Default : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UpdateCartCount();

            if (!IsPostBack)
            {
                KiemTraDangNhap();
            }
        }

        public void UpdateCartCountAjax()
        {
            UpdateCartCount();
            upCart.Update();
        }

        private void UpdateCartCount()
        {
            if (Session["Cart"] != null)
            {
                DataTable dt = (DataTable)Session["Cart"];
                int count = 0;
                foreach (DataRow row in dt.Rows) { count += Convert.ToInt32(row["Soluong"]); }
                litCartCount.Text = count.ToString();
            }
            else { litCartCount.Text = "0"; }
        }

        private void KiemTraDangNhap()
        {
            if (Session["HoTen"] != null)
            {
                phAnonymous.Visible = false;
                phUser.Visible = true;
                litUserName.Text = Session["HoTen"].ToString();

                if (Session["MaRole"] != null && Session["MaRole"].ToString() == "2")
                    phSellerRole.Visible = true;
            }
            else
            {
                phAnonymous.Visible = true;
                phUser.Visible = false;
                phSellerRole.Visible = false;
            }
        }

        protected void BtnLoginRedirect_Click(object sender, EventArgs e)
        {
            if (Session["MaKH"] == null)
                Response.Redirect("~/khach/dangnhap.aspx");
            else
                Response.Redirect("~/khach/trangchu.aspx");
        }

        // HÀM QUAN TRỌNG: Giữ lại MaLoai khi chọn MaCD
        public string GetTopicUrl(object maCD)
        {
            string maLoai = Request.QueryString["MaLoai"];
            // Nếu không có MaLoai trên URL, mặc định là 1 hoặc bạn có thể xử lý logic khác
            if (string.IsNullOrEmpty(maLoai)) maLoai = "1";

            return string.Format("~/khach/danhsach.aspx?MaLoai={0}&MaCD={1}", maLoai, maCD);
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                Response.Redirect("~/khach/danhsach.aspx?search=" + Server.UrlEncode(txtSearch.Text.Trim()));
        }

        protected void BtnApplyPrice_Click(object sender, EventArgs e)
        {
            string min = txtMinPrice.Text.Trim();
            string max = txtMaxPrice.Text.Trim();
            // Nối chuỗi để hàm GetMasterFilterUrl xử lý
            Response.Redirect(GetMasterFilterUrl("price", min + "-" + max));
        }

        // HÀM XỬ LÝ URL THÔNG MINH: Giữ nguyên các tham số cũ, chỉ cập nhật tham số mới
        public string GetMasterFilterUrl(string paramName, string value)
        {
            var uri = new Uri(Request.Url.AbsoluteUri);
            var query = HttpUtility.ParseQueryString(uri.Query);

            // Cập nhật tham số (Ví dụ: thay đổi sort nhưng vẫn giữ MaLoai, MaCD)
            query.Set(paramName, value);

            // Luôn reset về trang 1 khi thực hiện lọc/sắp xếp mới
            query.Remove("page");

            string path = Request.Url.AbsolutePath.ToLower().Contains("danhsach")
                          ? Request.Url.AbsolutePath
                          : ResolveUrl("~/khach/danhsach.aspx");

            return path + "?" + query.ToString();
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/khach/trangchu.aspx");
        }
    }
}