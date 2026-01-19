using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class thanhtoan : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Cart"] == null || ((DataTable)Session["Cart"]).Rows.Count == 0)
            {
                Response.Redirect("danhsach.aspx");
                return;
            }

            if (Session["MaKH"] == null)
            {
                Response.Redirect("~/khach/dangnhap.aspx");
                return;
            }

            if (!IsPostBack)
            {
                DateTime ngayGiaoDuKien = DateTime.Now.AddDays(14);
                litNgayGiaoShow.Text = ngayGiaoDuKien.ToString("dd/MM/yyyy");
                LoadOrderSummary();
            }
        }

        private void LoadOrderSummary()
        {
            DataTable dt = (DataTable)Session["Cart"];
            rptSummary.DataSource = dt;
            rptSummary.DataBind();

            decimal total = 0;
            foreach (DataRow r in dt.Rows)
                total += Convert.ToDecimal(r["Thanhtien"]);

            lblTongTien.Text = string.Format("{0:#,##0} VNĐ", total);
        }

        protected void btnDatHang_Click(object sender, EventArgs e)
        {
            DataTable dtCart = (DataTable)Session["Cart"];
            decimal tongTien = 0;
            foreach (DataRow r in dtCart.Rows)
                tongTien += Convert.ToDecimal(r["Thanhtien"]);

            DateTime ngayGiaoThucTe = DateTime.Now.AddDays(14);

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();

                try
                {
                    // 1. Lưu DonDatHang
                    string sqlDonHang = @"INSERT INTO DonDatHang (MaKH, NgayDH, Trigia, Dagiao, Ngaygiao) 
                                         VALUES (@MaKH, GETDATE(), @Trigia, 0, @NgayGiao);
                                         SELECT SCOPE_IDENTITY();";

                    SqlCommand cmdDH = new SqlCommand(sqlDonHang, conn, trans);
                    cmdDH.Parameters.AddWithValue("@MaKH", Session["MaKH"]);
                    cmdDH.Parameters.AddWithValue("@Trigia", tongTien);
                    cmdDH.Parameters.AddWithValue("@NgayGiao", ngayGiaoThucTe);

                    int soDH = Convert.ToInt32(cmdDH.ExecuteScalar());

                    // 2. Lưu CTDatHang
                    foreach (DataRow row in dtCart.Rows)
                    {
                        string sqlCT = @"INSERT INTO CTDatHang (SoDH, MaSach, Soluong, Dongia, Thanhtien) 
                                        VALUES (@SoDH, @MaSach, @Soluong, @Dongia, @Thanhtien)";

                        SqlCommand cmdCT = new SqlCommand(sqlCT, conn, trans);
                        cmdCT.Parameters.AddWithValue("@SoDH", soDH);
                        cmdCT.Parameters.AddWithValue("@MaSach", row["MaSach"]);
                        cmdCT.Parameters.AddWithValue("@Soluong", row["Soluong"]);
                        cmdCT.Parameters.AddWithValue("@Dongia", row["Dongia"]);
                        cmdCT.Parameters.AddWithValue("@Thanhtien", row["Thanhtien"]);
                        cmdCT.ExecuteNonQuery();
                    }

                    trans.Commit();
                    Session["Cart"] = null;

                    // --- CẬP NHẬT: ĐÓNG MODAL VÀ HIỆN TOAST TRƯỚC KHI CHUYỂN TRANG ---
                    string successMsg = "Đặt hàng thành công! Mã đơn của bạn là #" + soDH;
                    string script = "closeConfirmModal(); showToast('" + successMsg + "'); setTimeout(function(){ window.location='/khach/trangchu.aspx'; }, 2500);";
                    ScriptManager.RegisterStartupScript(this, GetType(), "OrderSuccess", script, true);
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    ScriptManager.RegisterStartupScript(this, GetType(), "OrderErr", "closeConfirmModal(); alert('Lỗi hệ thống: " + ex.Message + "');", true);
                }
            }
        }
    }
}