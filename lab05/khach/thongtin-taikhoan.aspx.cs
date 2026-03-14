using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;

namespace lab05
{
    public partial class thongtin_taikhoan : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra đăng nhập
            if (Session["MaKH"] == null)
            {
                Response.Redirect("~/khach/dangnhap.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
                LoadPurchaseHistory();
            }

            // Xử lý upload ảnh tức thì
            if (IsPostBack && fuAvatar.HasFile)
            {
                UploadAvatar();
            }
        }

        private void LoadProfile()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = "SELECT * FROM KhachHang WHERE MaKH = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", Session["MaKH"]);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtHoTen.Text = dr["HoTenKH"].ToString();
                    txtTenDN.Text = dr["TenDN"].ToString();
                    txtEmail.Text = dr["Email"].ToString();
                    txtDienThoai.Text = dr["Dienthoai"].ToString();
                    txtDiaChi.Text = dr["Diachi"].ToString();

                    string img = dr["AnhKH"].ToString();
                    imgKH.ImageUrl = "~/Images/" + (string.IsNullOrEmpty(img) ? "no-avatar.jpg" : img);
                }
            }
        }

        private void LoadPurchaseHistory()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = @"SELECT S.MaSach, S.TenSach, S.AnhBia, D.NgayDH, D.Dagiao, CT.Thanhtien 
                               FROM Sach S 
                               JOIN CTDatHang CT ON S.MaSach = CT.MaSach 
                               JOIN DonDatHang D ON CT.SoDH = D.SoDH 
                               WHERE D.MaKH = @id 
                               ORDER BY D.NgayDH DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                da.SelectCommand.Parameters.AddWithValue("@id", Session["MaKH"]);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvPurchasedBooks.DataSource = dt;
                gvPurchasedBooks.DataBind();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = @"UPDATE KhachHang SET HoTenKH=@ten, Email=@email, Dienthoai=@sdt, Diachi=@dc 
                               WHERE MaKH=@id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ten", txtHoTen.Text.Trim());
                cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@sdt", txtDienThoai.Text.Trim());
                cmd.Parameters.AddWithValue("@dc", txtDiaChi.Text.Trim());
                cmd.Parameters.AddWithValue("@id", Session["MaKH"]);

                conn.Open();
                if (cmd.ExecuteNonQuery() > 0)
                {
                    Session["HoTen"] = txtHoTen.Text.Trim();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Cập nhật thông tin thành công!');", true);
                }
            }
        }

        // --- MỚI: XỬ LÝ HIỆN/ẨN KHUNG ĐỔI MẬT KHẨU [cite: 2026-03-14] ---
        protected void btnTogglePass_Click(object sender, EventArgs e)
        {
            pnlChangePass.Visible = !pnlChangePass.Visible;
            btnTogglePass.Text = pnlChangePass.Visible ? "✖️ ĐÓNG KHUNG ĐỔI MẬT KHẨU" : "🛡️ THAY ĐỔI MẬT KHẨU";
        }

        // --- MỚI: XỬ LÝ LƯU MẬT KHẨU MỚI [cite: 2026-03-14] ---
        protected void btnConfirmChangePass_Click(object sender, EventArgs e)
        {
            string oldP = txtOldPass.Text.Trim();
            string newP = txtNewPass.Text.Trim();
            string confP = txtConfirmPass.Text.Trim();

            if (string.IsNullOrEmpty(oldP) || string.IsNullOrEmpty(newP))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Vui lòng nhập đầy đủ thông tin mật khẩu!');", true);
                return;
            }

            if (newP != confP)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Mật khẩu mới và xác nhận không khớp!');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // 1. Kiểm tra mật khẩu cũ [cite: 2026-03-14]
                string checkSql = "SELECT COUNT(*) FROM KhachHang WHERE MaKH = @id AND Matkhau = @old";
                SqlCommand cmdCheck = new SqlCommand(checkSql, conn);
                cmdCheck.Parameters.AddWithValue("@id", Session["MaKH"]);
                cmdCheck.Parameters.AddWithValue("@old", oldP);

                conn.Open();
                int isValid = (int)cmdCheck.ExecuteScalar();

                if (isValid > 0)
                {
                    // 2. Cập nhật mật khẩu mới
                    string updateSql = "UPDATE KhachHang SET Matkhau = @new WHERE MaKH = @id";
                    SqlCommand cmdUpdate = new SqlCommand(updateSql, conn);
                    cmdUpdate.Parameters.AddWithValue("@new", newP);
                    cmdUpdate.Parameters.AddWithValue("@id", Session["MaKH"]);

                    if (cmdUpdate.ExecuteNonQuery() > 0)
                    {
                        pnlChangePass.Visible = false;
                        btnTogglePass.Text = "🛡️ THAY ĐỔI MẬT KHẨU";
                        txtOldPass.Text = txtNewPass.Text = txtConfirmPass.Text = "";
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đổi mật khẩu thành công!');", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Mật khẩu hiện tại không chính xác!');", true);
                }
            }
        }

        private void UploadAvatar()
        {
            string maKH = Session["MaKH"].ToString();
            string ext = Path.GetExtension(fuAvatar.FileName);
            string fileName = "avatars-" + maKH + ext;
            string path = Server.MapPath("~/Images/") + fileName;

            try
            {
                fuAvatar.SaveAs(path);
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE KhachHang SET AnhKH=@anh WHERE MaKH=@id", conn);
                    cmd.Parameters.AddWithValue("@anh", fileName);
                    cmd.Parameters.AddWithValue("@id", maKH);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadProfile();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "err", $"alert('Lỗi tải ảnh: {ex.Message}');", true);
            }
        }
    }
}