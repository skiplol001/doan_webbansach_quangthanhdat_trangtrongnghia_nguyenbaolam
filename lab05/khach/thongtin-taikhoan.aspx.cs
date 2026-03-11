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

            // Xử lý upload ảnh tức thì khi chọn file
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

                    // Hiển thị ảnh đại diện
                    string img = dr["AnhKH"].ToString();
                    imgKH.ImageUrl = "~/Images/" + (string.IsNullOrEmpty(img) ? "no-avatar.jpg" : img);
                }
            }
        }

        private void LoadPurchaseHistory()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Lấy thông tin sách thông qua JOIN 3 bảng: Sach, CTDatHang, DonDatHang [cite: 2026-03-11]
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
                    // Cập nhật lại Session HoTen để Header thay đổi ngay lập tức [cite: 2026-03-11]
                    Session["HoTen"] = txtHoTen.Text.Trim();
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Cập nhật thông tin thành công!');", true);
                }
            }
        }

        private void UploadAvatar()
        {
            string maKH = Session["MaKH"].ToString();
            string ext = Path.GetExtension(fuAvatar.FileName);
            // Đặt tên ảnh theo cấu trúc: avatars-MaKH.jpg [cite: 2026-03-11]
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
                LoadProfile(); // Nạp lại ảnh mới
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "err", $"alert('Lỗi tải ảnh: {ex.Message}');", true);
            }
        }
    }
}