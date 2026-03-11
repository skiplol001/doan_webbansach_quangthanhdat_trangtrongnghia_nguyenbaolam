using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;

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
                // Load danh mục Chủ đề
                SqlDataAdapter daCD = new SqlDataAdapter("SELECT MaCD, Tenchude FROM ChuDe", conn);
                DataTable dtCD = new DataTable();
                daCD.Fill(dtCD);
                ddlChuDe.DataSource = dtCD;
                ddlChuDe.DataTextField = "Tenchude";
                ddlChuDe.DataValueField = "MaCD";
                ddlChuDe.DataBind();

                // Load danh mục NXB
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
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    conn.Open();
                    SqlTransaction trans = conn.BeginTransaction(); // Sử dụng Transaction để an toàn dữ liệu [cite: 2026-03-11]

                    try
                    {
                        // 1. Thêm dữ liệu sách (Tạm thời để trống cột AnhBia)
                        string sqlInsert = @"INSERT INTO Sach (TenSach, MaCD, MaNXB, Dongia, Mota, Ngaycapnhat, Soluongton, TrangThai, Soluotxem) 
                                            VALUES (@ten, @macd, @manxb, @gia, @mota, GETDATE(), 10, 1, 0);
                                            SELECT SCOPE_IDENTITY();"; // Lấy ID vừa tạo

                        SqlCommand cmdInsert = new SqlCommand(sqlInsert, conn, trans);
                        cmdInsert.Parameters.AddWithValue("@ten", txtTenSach.Text.Trim());
                        cmdInsert.Parameters.AddWithValue("@macd", ddlChuDe.SelectedValue);
                        cmdInsert.Parameters.AddWithValue("@manxb", ddlNXB.SelectedValue);
                        cmdInsert.Parameters.AddWithValue("@gia", decimal.Parse(txtGia.Text));
                        cmdInsert.Parameters.AddWithValue("@mota", txtMoTa.Text.Trim());

                        // Lấy MaSach mới sinh ra
                        int maSachMoi = Convert.ToInt32(cmdInsert.ExecuteScalar());

                        // 2. Xử lý đổi tên ảnh: images-[MaSach].[extension] [cite: 2026-03-11]
                        string extension = Path.GetExtension(fuAnh.FileName);
                        string newFileName = "images-" + maSachMoi + extension;
                        string physicalPath = Server.MapPath("~/Images/") + newFileName;

                        // Lưu file vào thư mục vật lý
                        fuAnh.SaveAs(physicalPath);

                        // 3. Cập nhật lại cột AnhBia với tên file mới
                        string sqlUpdate = "UPDATE Sach SET AnhBia = @anh WHERE MaSach = @id";
                        SqlCommand cmdUpdate = new SqlCommand(sqlUpdate, conn, trans);
                        cmdUpdate.Parameters.AddWithValue("@anh", newFileName);
                        cmdUpdate.Parameters.AddWithValue("@id", maSachMoi);
                        cmdUpdate.ExecuteNonQuery();

                        trans.Commit(); // Xác nhận hoàn tất [cite: 2026-03-11]
                        Response.Redirect("QLSach.aspx");
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback(); // Nếu lỗi thì hủy bỏ toàn bộ
                        ScriptManager.RegisterStartupScript(this, GetType(), "err", "alert('Lỗi hệ thống: " + ex.Message + "');", true);
                    }
                }
            }
        }
    }
}