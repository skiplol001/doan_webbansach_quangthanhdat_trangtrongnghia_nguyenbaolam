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
            // Kiểm tra quyền Seller
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
                    LoadDropdowns(); // Đã sửa tên thống nhất
                    HienThiThongTinSach(maSach); // Đã sửa tên thống nhất
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
                // Load Chủ đề
                SqlDataAdapter daCD = new SqlDataAdapter("SELECT MaCD, Tenchude FROM ChuDe", conn);
                DataTable dtCD = new DataTable();
                daCD.Fill(dtCD);
                ddlChuDe.DataSource = dtCD;
                ddlChuDe.DataTextField = "Tenchude";
                ddlChuDe.DataValueField = "MaCD";
                ddlChuDe.DataBind();

                // Load Nhà Xuất Bản
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
                string sql = "SELECT * FROM Sach WHERE MaSach = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtTenSach.Text = dr["TenSach"].ToString();
                    // Định dạng số để hiển thị trong TextBox
                    txtGia.Text = string.Format("{0:0}", dr["Dongia"]);
                    txtMoTa.Text = dr["Mota"].ToString();

                    // Chọn giá trị đúng trong DropDownList
                    ddlChuDe.SelectedValue = dr["MaCD"].ToString();
                    ddlNXB.SelectedValue = dr["MaNXB"].ToString();

                    // Hiển thị ảnh hiện tại
                    imgHienTai.ImageUrl = "~/Images/" + dr["AnhBia"].ToString();
                    // Lưu lại tên ảnh cũ vào ViewState để dùng nếu không upload ảnh mới
                    ViewState["OldImg"] = dr["AnhBia"].ToString();
                }
                else
                {
                    Response.Redirect("QLSach.aspx");
                }
            }
        }

        protected void btnCapNhat_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(Request.QueryString["id"]);

            // Mặc định lấy tên ảnh cũ từ ViewState
            string fileName = ViewState["OldImg"] != null ? ViewState["OldImg"].ToString() : "no-image.jpg";

            // Nếu người dùng có chọn file ảnh mới
            if (fuAnh.HasFile)
            {
                fileName = Path.GetFileName(fuAnh.FileName);
                string path = Server.MapPath("~/Images/") + fileName;
                fuAnh.SaveAs(path);
            }

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Cập nhật đầy đủ các trường dữ liệu theo cấu trúc DB mới
                string sql = @"UPDATE Sach SET 
                                TenSach = @ten, 
                                MaCD = @macd, 
                                MaNXB = @manxb, 
                                Dongia = @gia, 
                                Mota = @mota, 
                                AnhBia = @anh, 
                                Ngaycapnhat = GETDATE() 
                             WHERE MaSach = @id";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ten", txtTenSach.Text.Trim());
                cmd.Parameters.AddWithValue("@macd", ddlChuDe.SelectedValue);
                cmd.Parameters.AddWithValue("@manxb", ddlNXB.SelectedValue);
                cmd.Parameters.AddWithValue("@gia", decimal.Parse(txtGia.Text));
                cmd.Parameters.AddWithValue("@mota", txtMoTa.Text.Trim());
                cmd.Parameters.AddWithValue("@anh", fileName);
                cmd.Parameters.AddWithValue("@id", id);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    // Chuyển hướng về trang danh sách sau khi sửa thành công
                    Response.Redirect("QLSach.aspx");
                }
                catch (Exception ex)
                {
                    // Hiển thị lỗi nếu có (ví dụ: sai kiểu dữ liệu giá tiền)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('Lỗi cập nhật: {ex.Message}');", true);
                }
            }
        }
    }
}