using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class chitiet : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["MaSach"] != null)
                {
                    string maSach = Request.QueryString["MaSach"];
                    CapNhatLuotXem(maSach);
                    LuuSanPhamDaXem(maSach);

                    bool loggedIn = Session["MaKH"] != null;
                    pnlCommentForm.Visible = loggedIn;
                    pnlLoginReq.Visible = !loggedIn;
                }
                else { Response.Redirect("trangchu.aspx"); }
            }
        }

        public bool IsMyComment(object maKHComment)
        {
            if (Session["MaKH"] == null || maKHComment == null) return false;
            return Session["MaKH"].ToString() == maKHComment.ToString();
        }

        protected void rptComments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Panel pnlView = (Panel)e.Item.FindControl("pnlView");
            Panel pnlEdit = (Panel)e.Item.FindControl("pnlEdit");
            HiddenField hfMaBL = (HiddenField)e.Item.FindControl("hfMaBL");

            if (e.CommandName == "EditMode")
            {
                pnlView.Visible = false;
                pnlEdit.Visible = true;
            }
            else if (e.CommandName == "CancelEdit")
            {
                pnlView.Visible = true;
                pnlEdit.Visible = false;
            }
            else if (e.CommandName == "UpdateComm")
            {
                string noiDungMoi = ((TextBox)e.Item.FindControl("txtEditContent")).Text.Trim();
                string saoMoi = ((DropDownList)e.Item.FindControl("ddlEditStars")).SelectedValue;

                UpdateComment(hfMaBL.Value, noiDungMoi, saoMoi);
                rptComments.DataBind();
                ScriptManager.RegisterStartupScript(this, GetType(), "ToastUpdate", "showToast('Đã cập nhật nhận xét thành công!');", true);
            }
            // Logic DeleteComm cũ đã được chuyển ra nút xác nhận của Modal
        }

        // --- XỬ LÝ XÓA TỪ MODAL (THÊM MỚI) ---
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            string idToDelete = hfDeleteID.Value;
            if (!string.IsNullOrEmpty(idToDelete))
            {
                DeleteComment(idToDelete);
                rptComments.DataBind();

                // Đóng Modal bằng JS và hiện thông báo Toast
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModal", "closeDeleteModal(); showToast('Đã xóa nhận xét của bạn!');", true);
            }
        }

        private void UpdateComment(string maBL, string noiDung, string sao)
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = "UPDATE Comment SET NoiDung=@ND, DanhGia=@Sao, NgayBL=GETDATE() WHERE MaBL=@ID AND MaKH=@User";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@ND", noiDung);
                cmd.Parameters.AddWithValue("@Sao", sao);
                cmd.Parameters.AddWithValue("@ID", maBL);
                cmd.Parameters.AddWithValue("@User", Session["MaKH"]);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void DeleteComment(string maBL)
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = "DELETE FROM Comment WHERE MaBL=@ID AND MaKH=@User";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@ID", maBL);
                cmd.Parameters.AddWithValue("@User", Session["MaKH"]);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnThemGioHang_Click(object sender, EventArgs e)
        {
            if (Session["MaKH"] == null) { Response.Redirect("~/khach/dangnhap.aspx"); return; }
            int maSach = Convert.ToInt32(((LinkButton)sender).CommandArgument);
            ThemVaoGio(maSach);

            var myMaster = Master as lab05.Default;
            if (myMaster != null) myMaster.UpdateCartCountAjax();
            ScriptManager.RegisterStartupScript(this, GetType(), "ToastAdd", "showToast('Sách đã được thêm vào giỏ hàng!');", true);
        }

        protected void btnGuiBL_Click(object sender, EventArgs e)
        {
            if (Session["MaKH"] == null) return;
            if (string.IsNullOrWhiteSpace(txtNoiDungBL.Text)) return;

            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = "INSERT INTO Comment (MaSach, MaKH, NoiDung, DanhGia, NgayBL) VALUES (@MS, @MKH, @ND, @Sao, GETDATE())";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@MS", Request.QueryString["MaSach"]);
                cmd.Parameters.AddWithValue("@MKH", Session["MaKH"]);
                cmd.Parameters.AddWithValue("@ND", txtNoiDungBL.Text.Trim());
                cmd.Parameters.AddWithValue("@Sao", ddlStars.SelectedValue);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            txtNoiDungBL.Text = "";
            rptComments.DataBind();
            ScriptManager.RegisterStartupScript(this, GetType(), "ToastPost", "showToast('Cảm ơn bạn đã để lại nhận xét!');", true);
        }

        public string RenderStars(object rating)
        {
            int stars = (rating != DBNull.Value) ? Convert.ToInt32(rating) : 0;
            string res = "";
            for (int i = 1; i <= 5; i++) res += (i <= stars) ? "★" : "☆";
            return res;
        }

        public string RenderTags(object tagsObj)
        {
            if (tagsObj == null || string.IsNullOrEmpty(tagsObj.ToString())) return "";
            string html = "";
            foreach (string tag in tagsObj.ToString().Split(','))
                if (!string.IsNullOrWhiteSpace(tag)) html += $"<span class='tag-badge'>{tag.Trim()}</span>";
            return html;
        }

        private void CapNhatLuotXem(string maSach)
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Sach SET SoLuotXem = ISNULL(SoLuotXem, 0) + 1 WHERE MaSach = @MS", con);
                cmd.Parameters.AddWithValue("@MS", maSach);
                con.Open(); cmd.ExecuteNonQuery();
            }
        }

        private void LuuSanPhamDaXem(string maSach)
        {
            if (Session["ViewedBooks"] == null) Session["ViewedBooks"] = new List<int>();
            List<int> list = (List<int>)Session["ViewedBooks"];
            int id = int.Parse(maSach);
            if (list.Contains(id)) list.Remove(id);
            list.Insert(0, id);
            if (list.Count > 12) list.RemoveAt(12);
        }

        private void ThemVaoGio(int id)
        {
            DataTable dt = (Session["Cart"] == null) ? CreateCartTable() : (DataTable)Session["Cart"];
            bool found = false;
            foreach (DataRow r in dt.Rows) if (Convert.ToInt32(r["MaSach"]) == id)
                {
                    r["Soluong"] = (int)r["Soluong"] + 1; found = true; break;
                }
            if (!found)
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    SqlCommand cmd = new SqlCommand("SELECT MaSach, TenSach, AnhBia, Dongia FROM Sach WHERE MaSach=@ID", con);
                    cmd.Parameters.AddWithValue("@ID", id); con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read()) dt.Rows.Add(dr["MaSach"], dr["TenSach"], dr["AnhBia"], dr["Dongia"], 1, dr["Dongia"]);
                }
            }
            Session["Cart"] = dt;
        }

        private DataTable CreateCartTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("MaSach", typeof(int)); dt.Columns.Add("TenSach", typeof(string));
            dt.Columns.Add("HinhAnh", typeof(string)); dt.Columns.Add("Dongia", typeof(decimal));
            dt.Columns.Add("Soluong", typeof(int)); dt.Columns.Add("Thanhtien", typeof(decimal));
            return dt;
        }
    }
}