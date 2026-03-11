using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace lab05
{
    public partial class dangky : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblThongBao.Visible = false;
            }
        }

        protected void btnthem_Click(object sender, EventArgs e)
        {
            string hoTen = txtHoTen.Text.Trim();
            string tenDN = txtTendangnhap.Text.Trim();
            string matKhau = txtMatkhau.Text.Trim();
            string email = txtEmail.Text.Trim();
            string sdt = txtSDT.Text.Trim();
            string diaChi = txtDiachi.Text.Trim();
            string ngaySinh = txtNgay.Text;

            // Xác định vai trò: 2 là Người bán, 1 là Người mua [cite: 2026-03-11]
            int maRole = chkBanHang.Checked ? 2 : 1;

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                conn.Open();

                // 1. KIỂM TRA TÊN ĐĂNG NHẬP ĐÃ TỒN TẠI CHƯA
                string checkSql = "SELECT COUNT(*) FROM KhachHang WHERE TenDN = @u";
                SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                checkCmd.Parameters.AddWithValue("@u", tenDN);
                int exists = (int)checkCmd.ExecuteScalar();

                if (exists > 0)
                {
                    lblThongBao.Text = "<i class='fa-solid fa-circle-xmark'></i> Tên đăng nhập này đã được sử dụng!";
                    lblThongBao.CssClass = "status-msg msg-error";
                    lblThongBao.Visible = true;
                    return;
                }

                // 2. THỰC HIỆN ĐĂNG KÝ (GÁN ẢNH MẶC ĐỊNH ĐỂ TRÁNH LỖI LOAD ẢNH) [cite: 2026-03-11]
                string sql = @"INSERT INTO KhachHang (HoTenKH, Diachi, Dienthoai, TenDN, Matkhau, Ngaysinh, Email, MaRole, AnhKH, IsOnline) 
                               VALUES (@ten, @dc, @dt, @dn, @mk, @ns, @em, @role, @anh, 0)";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ten", hoTen);
                cmd.Parameters.AddWithValue("@dc", diaChi);
                cmd.Parameters.AddWithValue("@dt", sdt);
                cmd.Parameters.AddWithValue("@dn", tenDN);
                cmd.Parameters.AddWithValue("@mk", matKhau);

                // Xử lý ngày sinh nếu người dùng không chọn
                if (string.IsNullOrEmpty(ngaySinh)) cmd.Parameters.AddWithValue("@ns", DBNull.Value);
                else cmd.Parameters.AddWithValue("@ns", ngaySinh);

                cmd.Parameters.AddWithValue("@em", email);
                cmd.Parameters.AddWithValue("@role", maRole);

                // FIX: Gán ảnh mặc định ngay từ khi đăng ký [cite: 2026-03-11]
                cmd.Parameters.AddWithValue("@anh", "no-avatar.jpg");

                try
                {
                    int result = cmd.ExecuteNonQuery();
                    if (result > 0)
                    {
                        // Đăng ký thành công -> Chuyển sang trang đăng nhập sau 2 giây
                        lblThongBao.Text = "<i class='fa-solid fa-circle-check'></i> Đăng ký thành công! Đang chuyển hướng...";
                        lblThongBao.CssClass = "status-msg msg-success";
                        lblThongBao.Visible = true;

                        // Vô hiệu hóa nút để tránh bấm nhiều lần
                        btndangky.Enabled = false;

                        // Script chuyển hướng tự động
                        Response.AddHeader("REFRESH", "2;URL=dangnhap.aspx");
                    }
                }
                catch (Exception ex)
                {
                    lblThongBao.Text = "Lỗi hệ thống: " + ex.Message;
                    lblThongBao.CssClass = "status-msg msg-error";
                    lblThongBao.Visible = true;
                }
            }
        }
    }
}