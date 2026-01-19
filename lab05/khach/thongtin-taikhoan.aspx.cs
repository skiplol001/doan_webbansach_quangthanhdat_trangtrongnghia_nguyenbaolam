using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class thongtin_taikhoan : System.Web.UI.Page
    {
        // Chuỗi kết nối từ Web.config
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra bảo mật Session
            if (Session["MaKH"] == null)
            {
                Response.Redirect("~/khach/dangnhap.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserBasicInfo();
                LoadPurchasedBooks();
            }
        }

        private void LoadUserBasicInfo()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                // Sửa tên cột SQL: Diachi, Dienthoai
                string sql = "SELECT HoTenKH, TenDN, Email, Diachi, Dienthoai FROM KhachHang WHERE MaKH = @MaKH";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@MaKH", Session["MaKH"]);

                try
                {
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        // Gọi hàm SetInfoField để tự động ẩn Panel nếu dữ liệu rỗng
                        SetInfoField(pnlHoTen, litHoTen, dr["HoTenKH"]);
                        SetInfoField(pnlTenDN, litTenDN, dr["TenDN"]);
                        SetInfoField(pnlEmail, litEmail, dr["Email"]);
                        SetInfoField(pnlDienThoai, litDienThoai, dr["Dienthoai"]);
                        SetInfoField(pnlDiaChi, litDiaChi, dr["Diachi"]);
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Lỗi SQL Info: " + ex.Message);
                }
            }
        }

        /// <summary>
        /// Hàm logic chính: Có dữ liệu mới hiện Panel, thiếu thì ẩn hẳn.
        /// </summary>
        private void SetInfoField(Panel pnl, Literal lit, object value)
        {
            // Kiểm tra: Khác Null, Khác DBNull và không phải chuỗi trắng
            if (value != null && value != DBNull.Value && !string.IsNullOrWhiteSpace(value.ToString()))
            {
                lit.Text = value.ToString();
                pnl.Visible = true; // Hiện Panel
            }
            else
            {
                pnl.Visible = false; // ẨN HẲN THÔNG TIN NẾU THIẾU
            }
        }

        private void LoadPurchasedBooks()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                // FIX QUAN TRỌNG: Đổi ChiTietDonHang thành CTDatHang để hiển thị được đơn hàng đã mua
                string sql = @"SELECT S.TenSach, S.AnhBia, S.Dongia, D.NgayDH, D.Dagiao 
                             FROM DonDatHang D 
                             INNER JOIN CTDatHang CT ON D.SoDH = CT.SoDH 
                             INNER JOIN Sach S ON CT.MaSach = S.MaSach 
                             WHERE D.MaKH = @MaKH 
                             ORDER BY D.NgayDH DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.SelectCommand.Parameters.AddWithValue("@MaKH", Session["MaKH"]);

                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    // Bind dữ liệu vào GridView để hiển thị danh sách sách khách đã mua
                    gvPurchasedBooks.DataSource = dt;
                    gvPurchasedBooks.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Lỗi Load Purchased Books: " + ex.Message);
                }
            }
        }
    }
}