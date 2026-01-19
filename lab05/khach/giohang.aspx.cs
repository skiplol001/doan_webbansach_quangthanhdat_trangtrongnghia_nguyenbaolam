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

                decimal total = 0;
                foreach (DataRow r in dt.Rows)
                {
                    // Kiểm tra DBNull trước khi cộng dồn để tránh lỗi crash
                    if (r["Thanhtien"] != DBNull.Value)
                        total += Convert.ToDecimal(r["Thanhtien"]);
                }

                // FIX TRIỆT ĐỂ: Chỉ gán nếu Control tồn tại (tránh lỗi Object reference)
                if (litTongTien != null)
                {
                    litTongTien.Text = string.Format("{0:#,##0}", total);
                }
            }
            else
            {
                pnlCartContent.Visible = false;
                pnlEmptyCart.Visible = true;
            }
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DataTable dt = (DataTable)Session["Cart"];
            if (dt == null) return;

            string maSach = e.CommandArgument.ToString();

            if (e.CommandName == "Update")
            {
                TextBox txt = (TextBox)e.Item.FindControl("txtQuantity");
                if (txt != null)
                {
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
                    }
                }
            }
            else if (e.CommandName == "Delete")
            {
                for (int i = dt.Rows.Count - 1; i >= 0; i--)
                {
                    if (dt.Rows[i]["MaSach"].ToString() == maSach)
                    {
                        dt.Rows.RemoveAt(i);
                        break;
                    }
                }
            }

            Session["Cart"] = dt;

            // Reload lại trang để cập nhật Badge Giỏ hàng ở Header của Master Page
            Response.Redirect(Request.RawUrl);
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
                // Sau khi nhấn đặt hàng, bạn có thể chuyển sang trang thanhtoan.aspx
                Response.Redirect("thanhtoan.aspx");
            }
        }
    }
}