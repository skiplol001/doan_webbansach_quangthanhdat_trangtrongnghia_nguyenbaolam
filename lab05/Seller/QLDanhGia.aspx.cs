using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05.Admin
{
    public partial class QLDanhGia : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadComments();
            }
        }

        private void LoadComments()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = @"SELECT C.MaBL, C.MaSach, S.TenSach, K.HoTenKH, C.NoiDung, C.DanhGia, C.NgayBL 
                             FROM Comment C 
                             INNER JOIN Sach S ON C.MaSach = S.MaSach 
                             INNER JOIN KhachHang K ON C.MaKH = K.MaKH 
                             ORDER BY C.NgayBL DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvComments.DataSource = dt;
                gvComments.DataBind();
            }
        }

        // --- XỬ LÝ LỆNH XÓA TỪ MODAL XÁC NHẬN ---
        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            string idXoa = hfDeleteID.Value;
            if (!string.IsNullOrEmpty(idXoa))
            {
                XoaBinhLuan(int.Parse(idXoa));
                LoadComments();

                // Đóng Modal và hiện thông báo Toast thành công
                string script = "closeDeleteModal(); showToast('Đã gỡ bỏ đánh giá thành công!');";
                ScriptManager.RegisterStartupScript(this, GetType(), "DelDone", script, true);
            }
        }

        private void XoaBinhLuan(int id)
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Comment WHERE MaBL = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public string RenderStars(object rating)
        {
            int stars = rating != DBNull.Value ? Convert.ToInt32(rating) : 0;
            string res = "";
            for (int i = 1; i <= 5; i++) res += (i <= stars) ? "★" : "☆";
            return res;
        }
    }
}