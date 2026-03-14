using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05.Seller
{
    public partial class QLDanhMuc : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadChuDe();
                LoadNXB();
                LoadPhanLoai();
            }
        }

        // --- LOAD DỮ LIỆU ---
        private void LoadChuDe()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = "SELECT C.*, P.TenLoai FROM ChuDe C JOIN PhanLoai P ON C.MaLoai = P.MaLoai ORDER BY C.MaCD DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvChuDe.DataSource = dt;
                gvChuDe.DataBind();
            }
        }

        private void LoadNXB()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM NhaXuatBan ORDER BY MaNXB DESC", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvNXB.DataSource = dt;
                gvNXB.DataBind();
            }
        }

        private void LoadPhanLoai()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM PhanLoai", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlPhanLoai.DataSource = dt;
                ddlPhanLoai.DataTextField = "TenLoai";
                ddlPhanLoai.DataValueField = "MaLoai";
                ddlPhanLoai.DataBind();
            }
        }

        // --- XỬ LÝ CHỦ ĐỀ (CD) ---
        protected void btnSaveCD_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = string.IsNullOrEmpty(hfMaCD.Value)
                    ? "INSERT INTO ChuDe(Tenchude, MaLoai) VALUES(@ten, @loai)"
                    : "UPDATE ChuDe SET Tenchude=@ten, MaLoai=@loai WHERE MaCD=@id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ten", txtTenCD.Text.Trim());
                cmd.Parameters.AddWithValue("@loai", ddlPhanLoai.SelectedValue);
                if (!string.IsNullOrEmpty(hfMaCD.Value)) cmd.Parameters.AddWithValue("@id", hfMaCD.Value);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            ResetFormCD();
            LoadChuDe();
            ScriptManager.RegisterStartupScript(this, GetType(), "c", "closeModal('modalCD');", true);
        }

        protected void gvChuDe_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "EditCD")
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM ChuDe WHERE MaCD=@id", conn);
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfMaCD.Value = id.ToString();
                        txtTenCD.Text = dr["Tenchude"].ToString();
                        ddlPhanLoai.SelectedValue = dr["MaLoai"].ToString();
                        ScriptManager.RegisterStartupScript(this, GetType(), "o", "openModal('modalCD');", true);
                    }
                }
            }
            else if (e.CommandName == "DeleteCD")
            {
                DeleteEntity("DELETE FROM ChuDe WHERE MaCD=@id", id, "Chủ đề");
                LoadChuDe();
            }
        }

        // --- XỬ LÝ NHÀ XUẤT BẢN (NXB) ---
        protected void btnSaveNXB_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = string.IsNullOrEmpty(hfMaNXB.Value)
                    ? "INSERT INTO NhaXuatBan(TenNXB, Diachi, Dienthoai) VALUES(@ten, @dc, @dt)"
                    : "UPDATE NhaXuatBan SET TenNXB=@ten, Diachi=@dc, Dienthoai=@dt WHERE MaNXB=@id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ten", txtTenNXB.Text.Trim());
                cmd.Parameters.AddWithValue("@dc", txtDiaChiNXB.Text.Trim());
                cmd.Parameters.AddWithValue("@dt", txtSDTNXB.Text.Trim());
                if (!string.IsNullOrEmpty(hfMaNXB.Value)) cmd.Parameters.AddWithValue("@id", hfMaNXB.Value);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            ResetFormNXB();
            LoadNXB();
            ScriptManager.RegisterStartupScript(this, GetType(), "c", "closeModal('modalNXB');", true);
        }

        protected void gvNXB_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            if (e.CommandName == "EditNXB")
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM NhaXuatBan WHERE MaNXB=@id", conn);
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfMaNXB.Value = id.ToString();
                        txtTenNXB.Text = dr["TenNXB"].ToString();
                        txtDiaChiNXB.Text = dr["Diachi"].ToString();
                        txtSDTNXB.Text = dr["Dienthoai"].ToString();
                        ScriptManager.RegisterStartupScript(this, GetType(), "o", "openModal('modalNXB');", true);
                    }
                }
            }
            else if (e.CommandName == "DeleteNXB")
            {
                DeleteEntity("DELETE FROM NhaXuatBan WHERE MaNXB=@id", id, "Nhà xuất bản");
                LoadNXB();
            }
        }

        // --- TIỆN ÍCH ---
        private void DeleteEntity(string sql, int id, string name)
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                try { cmd.ExecuteNonQuery(); }
                catch { ScriptManager.RegisterStartupScript(this, GetType(), "e", $"alert('Lỗi: {name} này đang được sử dụng trong danh sách sách!');", true); }
            }
        }

        private void ResetFormCD() { hfMaCD.Value = ""; txtTenCD.Text = ""; }
        private void ResetFormNXB() { hfMaNXB.Value = ""; txtTenNXB.Text = txtDiaChiNXB.Text = txtSDTNXB.Text = ""; }
    }
}