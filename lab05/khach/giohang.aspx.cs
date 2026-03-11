using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class giohang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCart();
            }
        }

        private void LoadCart()
        {
            DataTable dt = (DataTable)Session["Cart"];

            if (dt != null && dt.Rows.Count > 0)
            {
                pnlCartContent.Visible = true;
                pnlEmptyCart.Visible = false;

                rptCartItems.DataSource = dt;
                rptCartItems.DataBind();

                // Tính tổng tiền
                decimal total = 0;
                foreach (DataRow r in dt.Rows)
                {
                    if (r["Thanhtien"] != DBNull.Value)
                        total += Convert.ToDecimal(r["Thanhtien"]);
                }
                litTongTien.Text = string.Format("{0:#,##0}", total);
            }
            else
            {
                pnlCartContent.Visible = false;
                pnlEmptyCart.Visible = true;
            }
        }

        // --- HÀM TÍNH TOÁN TỨC THỜI KHI THAY ĐỔI SỐ LƯỢNG [cite: 2026-03-11] ---
        protected void txtQuantity_TextChanged(object sender, EventArgs e)
        {
            TextBox txt = (TextBox)sender;
            RepeaterItem item = (RepeaterItem)txt.NamingContainer;
            HiddenField hfMaSach = (HiddenField)item.FindControl("hfMaSach");

            if (hfMaSach != null && Session["Cart"] != null)
            {
                DataTable dt = (DataTable)Session["Cart"];
                string maSach = hfMaSach.Value;
                int slMoi;

                if (int.TryParse(txt.Text, out slMoi) && slMoi > 0)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        if (r["MaSach"].ToString() == maSach)
                        {
                            r["Soluong"] = slMoi;
                            r["Thanhtien"] = slMoi * Convert.ToDecimal(r["Dongia"]);
                            break;
                        }
                    }
                    Session["Cart"] = dt;
                    LoadCart(); // Nạp lại để cập nhật số tiền hiển thị [cite: 2026-03-11]
                }
                else
                {
                    // Nếu nhập sai (nhỏ hơn 1 hoặc chữ), reset về 1
                    txt.Text = "1";
                    txtQuantity_TextChanged(sender, e);
                }
            }
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DataTable dt = (DataTable)Session["Cart"];
            if (dt == null) return;

            if (e.CommandName == "Delete")
            {
                string maSach = e.CommandArgument.ToString();
                for (int i = dt.Rows.Count - 1; i >= 0; i--)
                {
                    if (dt.Rows[i]["MaSach"].ToString() == maSach)
                    {
                        dt.Rows.RemoveAt(i);
                        break;
                    }
                }
                Session["Cart"] = dt;
                LoadCart();

                // Cập nhật số lượng trên Master Page nếu cần
                Response.Redirect(Request.RawUrl);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            Session["Cart"] = null;
            Response.Redirect(Request.RawUrl);
        }

        protected void btnOrder_Click(object sender, EventArgs e)
        {
            if (Session["Cart"] != null && ((DataTable)Session["Cart"]).Rows.Count > 0)
            {
                if (Session["MaKH"] == null)
                    Response.Redirect("~/khach/dangnhap.aspx?ReturnUrl=giohang.aspx");
                else
                    Response.Redirect("thanhtoan.aspx");
            }
        }
    }
}