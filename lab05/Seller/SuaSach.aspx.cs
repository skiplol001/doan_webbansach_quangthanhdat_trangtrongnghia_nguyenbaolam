using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;

namespace lab05.Seller
{
    public partial class SuaSach : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MaRole"] == null || Convert.ToInt32(Session["MaRole"]) != 2)
            {
                Response.Redirect("~/khach/dangnhap.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int maSach;
                if (int.TryParse(Request.QueryString["id"], out maSach))
                {
                    LoadDropdowns();
                    HienThiThongTinSach(maSach);
                }
                else
                {
                    Response.Redirect("QLSach.aspx");
                }
            }
        }

        private void LoadDropdowns()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                SqlDataAdapter daCD = new SqlDataAdapter("SELECT MaCD, Tenchude FROM ChuDe", conn);
                DataTable dtCD = new DataTable();
                daCD.Fill(dtCD);
                ddlChuDe.DataSource = dtCD;
                ddlChuDe.DataTextField = "Tenchude";
                ddlChuDe.DataValueField = "MaCD";
                ddlChuDe.DataBind();

                SqlDataAdapter daNXB = new SqlDataAdapter("SELECT MaNXB, TenNXB FROM NhaXuatBan", conn);
                DataTable dtNXB = new DataTable();
                daNXB.Fill(dtNXB);
                ddlNXB.DataSource = dtNXB;
                ddlNXB.DataTextField = "TenNXB";
                ddlNXB.DataValueField = "MaNXB";
                ddlNXB.DataBind();
            }
        }

        private void HienThiThongTinSach(int id)
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM Sach WHERE MaSach = @id", conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtTenSach.Text = dr["TenSach"].ToString();
                    txtGia.Text = string.Format("{0:0}", dr["Dongia"]);

                    // NẠP SỐ LƯỢNG TỒN KHO [cite: 2026-03-14]
                    txtSoLuong.Text = dr["Soluongton"].ToString();

                    txtMoTa.Text = dr["Mota"].ToString();
                    ddlChuDe.SelectedValue = dr["MaCD"].ToString();
                    ddlNXB.SelectedValue = dr["MaNXB"].ToString();

                    // Hiển thị ảnh hiện tại
                    string currentImg = dr["AnhBia"].ToString();
                    imgHienTai.ImageUrl = "~/Images/" + currentImg;
                    ViewState["OldImg"] = currentImg;
                }
            }
        }

        protected void btnCapNhat_Click(object sender, EventArgs e)
        {
            int maSach = Convert.ToInt32(Request.QueryString["id"]);
            string finalFileName = ViewState["OldImg"].ToString();

            if (fuAnh.HasFile)
            {
                string extension = Path.GetExtension(fuAnh.FileName);
                finalFileName = "images-" + maSach + extension;
                fuAnh.SaveAs(Server.MapPath("~/Images/") + finalFileName);
            }

            // 2. Thực hiện cập nhật Database (Bao gồm Soluongton) [cite: 2026-03-14]
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = @"UPDATE Sach SET 
                                TenSach = @ten, 
                                MaCD = @macd, 
                                MaNXB = @manxb, 
                                Dongia = @gia, 
                                Soluongton = @sl, 
                                Mota = @mota, 
                                AnhBia = @anh, 
                                Ngaycapnhat = GETDATE() 
                             WHERE MaSach = @id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ten", txtTenSach.Text.Trim());
                cmd.Parameters.AddWithValue("@macd", ddlChuDe.SelectedValue);
                cmd.Parameters.AddWithValue("@manxb", ddlNXB.SelectedValue);
                cmd.Parameters.AddWithValue("@gia", decimal.Parse(txtGia.Text));

                // GÁN GIÁ TRỊ SỐ LƯỢNG MỚI
                cmd.Parameters.AddWithValue("@sl", int.Parse(txtSoLuong.Text));

                cmd.Parameters.AddWithValue("@mota", txtMoTa.Text.Trim());
                cmd.Parameters.AddWithValue("@anh", finalFileName);
                cmd.Parameters.AddWithValue("@id", maSach);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    Response.Redirect("QLSach.aspx");
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "err", $"alert('Lỗi cập nhật: {ex.Message}');", true);
                }
            }
        }
    }
}