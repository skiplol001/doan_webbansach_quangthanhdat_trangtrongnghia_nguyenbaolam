using System;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class Default : System.Web.UI.MasterPage
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            UpdateCartCount();

            if (!IsPostBack)
            {
                KiemTraDangNhap();

                string price = Request.QueryString["price"];
                if (!string.IsNullOrEmpty(price) && price.Contains("-"))
                {
                    string[] parts = price.Split('-');
                    if (parts.Length == 2)
                    {
                        txtMinPrice.Text = parts[0];
                        txtMaxPrice.Text = parts[1];
                    }
                }
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

        public string GetTopicUrl(object maCD)
        {
            string maLoai = Request.QueryString["MaLoai"];
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
            Response.Redirect(GetMasterFilterUrl("price", min + "-" + max));
        }

        public string GetMasterFilterUrl(string paramName, string value)
        {
            var uri = new Uri(Request.Url.AbsoluteUri);
            var query = HttpUtility.ParseQueryString(uri.Query);

            if (paramName.ToLower() == "page") { query.Set(paramName, value); }
            else
            {
                query.Set(paramName, value);
                query.Remove("page");
            }

            string path = ResolveUrl("~/khach/danhsach.aspx");
            return path + "?" + query.ToString();
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            if (Session["MaKH"] != null)
            {
                UpdateUserStatus(Session["MaKH"].ToString(), 0);
            }

            Session.Clear();
            Session.Abandon();

            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }

            Response.Redirect("~/khach/trangchu.aspx");
        }

        private void UpdateUserStatus(string maKH, int status)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    string sql = "UPDATE KhachHang SET IsOnline = @Status, LastSeen = GETDATE() WHERE MaKH = @ID";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@ID", maKH);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Loi Logout Status: " + ex.Message);
            }
        }
    }
}