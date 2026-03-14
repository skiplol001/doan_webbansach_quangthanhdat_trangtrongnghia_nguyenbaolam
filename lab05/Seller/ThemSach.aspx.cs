using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                // 1. Load danh mục Chủ đề
                SqlDataAdapter daCD = new SqlDataAdapter("SELECT MaCD, Tenchude FROM ChuDe", conn);
                DataTable dtCD = new DataTable();
                daCD.Fill(dtCD);
                ddlChuDe.DataSource = dtCD;
                ddlChuDe.DataTextField = "Tenchude";
                ddlChuDe.DataValueField = "MaCD";
                ddlChuDe.DataBind();

                // 2. Load danh mục NXB
                SqlDataAdapter daNXB = new SqlDataAdapter("SELECT MaNXB, TenNXB FROM NhaXuatBan", conn);
                DataTable dtNXB = new DataTable();
                daNXB.Fill(dtNXB);
                ddlNXB.DataSource = dtNXB;
                ddlNXB.DataTextField = "TenNXB";
                ddlNXB.DataValueField = "MaNXB";
                ddlNXB.DataBind();

                // 3. FIX: Load thêm danh mục PHÂN LOẠI cho Modal Thêm Chủ Đề [cite: 2026-03-14]
                SqlDataAdapter daPL = new SqlDataAdapter("SELECT MaLoai, TenLoai FROM PhanLoai", conn);
                DataTable dtPL = new DataTable();
                daPL.Fill(dtPL);
                ddlModalPhanLoai.DataSource = dtPL;
                ddlModalPhanLoai.DataTextField = "TenLoai";
                ddlModalPhanLoai.DataValueField = "MaLoai";
                ddlModalPhanLoai.DataBind();
            }
        }

        // --- FIX: HÀM XỬ LÝ LƯU NHANH TỪ MODAL (MỚI BỔ SUNG) [cite: 2026-03-14] ---
        protected void btnSaveQuick_Click(object sender, EventArgs e)
        {
            string type = hfAddType.Value;
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                conn.Open();
                if (type == "CD")
                {
                    string sql = "INSERT INTO ChuDe (Tenchude, MaLoai) VALUES (@ten, @loai)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ten", txtNewTenCD.Text.Trim());
                    cmd.Parameters.AddWithValue("@loai", ddlModalPhanLoai.SelectedValue);
                    cmd.ExecuteNonQuery();
                    txtNewTenCD.Text = "";
                }
                else if (type == "NXB")
                {
                    string sql = "INSERT INTO NhaXuatBan (TenNXB, Diachi, Dienthoai) VALUES (@ten, @dc, @dt)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ten", txtNewTenNXB.Text.Trim());
                    cmd.Parameters.AddWithValue("@dc", txtNewDiaChiNXB.Text.Trim());
                    cmd.Parameters.AddWithValue("@dt", txtNewSDTNXB.Text.Trim());
                    cmd.ExecuteNonQuery();
                    txtNewTenNXB.Text = txtNewDiaChiNXB.Text = txtNewSDTNXB.Text = "";
                }
            }
            // Nạp lại dữ liệu cho các DropDownList mà không mất các giá trị khác đang nhập
            LoadData();
            // Tắt Modal sau khi lưu thành công
            ScriptManager.RegisterStartupScript(this, GetType(), "close", "closeModal();", true);
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            if (fuAnh.HasFile)
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    conn.Open();
                    SqlTransaction trans = conn.BeginTransaction(); // Sử dụng Transaction an toàn [cite: 2026-03-11]

                    try
                    {
                        // 1. Thêm dữ liệu sách (Sử dụng SCOPE_IDENTITY của bạn)
                        string sqlInsert = @"INSERT INTO Sach (TenSach, MaCD, MaNXB, Dongia, Mota, Ngaycapnhat, Soluongton, TrangThai, Soluotxem) 
                                            VALUES (@ten, @macd, @manxb, @gia, @mota, GETDATE(), 10, 1, 0);
                                            SELECT SCOPE_IDENTITY();";

                        SqlCommand cmdInsert = new SqlCommand(sqlInsert, conn, trans);
                        cmdInsert.Parameters.AddWithValue("@ten", txtTenSach.Text.Trim());
                        cmdInsert.Parameters.AddWithValue("@macd", ddlChuDe.SelectedValue);
                        cmdInsert.Parameters.AddWithValue("@manxb", ddlNXB.SelectedValue);
                        cmdInsert.Parameters.AddWithValue("@gia", decimal.Parse(txtGia.Text));
                        cmdInsert.Parameters.AddWithValue("@mota", txtMoTa.Text.Trim());

                        // Lấy ID tự tăng để phục vụ đổi tên ảnh
                        int maSachMoi = Convert.ToInt32(cmdInsert.ExecuteScalar());

                        // 2. Xử lý đổi tên ảnh theo chuẩn images-[MaSach] [cite: 2026-03-11]
                        string extension = Path.GetExtension(fuAnh.FileName);
                        string newFileName = "images-" + maSachMoi + extension;
                        string physicalPath = Server.MapPath("~/Images/") + newFileName;

                        // Lưu file vào ổ đĩa
                        fuAnh.SaveAs(physicalPath);

                        // 3. Cập nhật lại tên file ảnh vào dòng dữ liệu vừa tạo
                        string sqlUpdate = "UPDATE Sach SET AnhBia = @anh WHERE MaSach = @id";
                        SqlCommand cmdUpdate = new SqlCommand(sqlUpdate, conn, trans);
                        cmdUpdate.Parameters.AddWithValue("@anh", newFileName);
                        cmdUpdate.Parameters.AddWithValue("@id", maSachMoi);
                        cmdUpdate.ExecuteNonQuery();

                        trans.Commit(); // Hoàn tất giao dịch
                        Response.Redirect("QLSach.aspx");
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback(); // Hoàn tác nếu có lỗi bất kỳ
                        ScriptManager.RegisterStartupScript(this, GetType(), "err", "alert('Lỗi hệ thống: " + ex.Message + "');", true);
                    }
                }
            }
        }
    }
}