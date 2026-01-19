using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

namespace lab05.Seller
{
    public partial class ThemSach : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
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

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            if (fuAnh.HasFile)
            {
                string fileName = Path.GetFileName(fuAnh.FileName);
                // Đảm bảo thư mục Images đã tồn tại
                fuAnh.SaveAs(Server.MapPath("~/Images/") + fileName);

                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    string sql = @"INSERT INTO Sach (TenSach, MaCD, MaNXB, Dongia, Mota, AnhBia, Ngaycapnhat, Soluongton, TrangThai, Soluotxem) 
                           VALUES (@ten, @macd, @manxb, @gia, @mota, @anh, GETDATE(), @soluong, 1, 0)";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ten", txtTenSach.Text.Trim());
                    cmd.Parameters.AddWithValue("@macd", ddlChuDe.SelectedValue);
                    cmd.Parameters.AddWithValue("@manxb", ddlNXB.SelectedValue);
                    cmd.Parameters.AddWithValue("@gia", decimal.Parse(txtGia.Text));
                    cmd.Parameters.AddWithValue("@mota", txtMoTa.Text.Trim());
                    cmd.Parameters.AddWithValue("@anh", fileName);
                    cmd.Parameters.AddWithValue("@soluong", 10); // Mặc định nhập kho 10 cuốn

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    Response.Redirect("QLSach.aspx");
                }
            }
        }
    }
}