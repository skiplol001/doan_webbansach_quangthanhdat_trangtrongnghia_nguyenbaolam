using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05.Admin
{
    public partial class QLDonHang : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        private void LoadOrders()
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = @"SELECT D.SoDH, K.HoTenKH, K.Dienthoai, D.NgayDH, D.Trigia, D.Dagiao, D.Ngaygiao 
                             FROM DonDatHang D 
                             INNER JOIN KhachHang K ON D.MaKH = K.MaKH 
                             ORDER BY D.Dagiao ASC, D.NgayDH DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    gvOrders.DataSource = dt;
                    gvOrders.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Lỗi Load SQL: " + ex.Message);
                }
            }
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "HoanDon")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                int soDH = Convert.ToInt32(gvOrders.DataKeys[rowIndex].Value);

                GridViewRow row = gvOrders.Rows[rowIndex];
                TextBox txtDate = (TextBox)row.FindControl("txtNewDate");

                if (txtDate != null && !string.IsNullOrEmpty(txtDate.Text))
                {
                    DateTime ngayMoi = DateTime.Parse(txtDate.Text);

                    if (ngayMoi < DateTime.Today)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "err", "showToast('Lỗi: Ngày hoãn không hợp lệ!');", true);
                        return;
                    }

                    UpdateOrder(soDH, ngayMoi, 0);
                    LoadOrders();
                    ScriptManager.RegisterStartupScript(this, GetType(), "ok", "showToast('Đã cập nhật lịch trình mới cho đơn #" + soDH + "');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "warn", "showToast('Vui lòng chọn ngày trước khi xác nhận!');", true);
                }
            }
        }

        // --- XỬ LÝ CHỐT ĐƠN TỪ MODAL XÁC NHẬN ---
        protected void btnFinalDone_Click(object sender, EventArgs e)
        {
            string idRaw = hfSelectedOrder.Value;
            if (!string.IsNullOrEmpty(idRaw))
            {
                int soDH = Convert.ToInt32(idRaw);
                UpdateOrder(soDH, DateTime.Now, 1);
                LoadOrders();

                // Đóng modal và hiện Toast thành công
                string script = "closeConfirmModal(); showToast('Đơn hàng #" + soDH + " đã được chốt thành công!');";
                ScriptManager.RegisterStartupScript(this, GetType(), "done", script, true);
            }
        }

        private void UpdateOrder(int id, DateTime date, int status)
        {
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = "UPDATE DonDatHang SET Ngaygiao = @Ngay, Dagiao = @Status WHERE SoDH = @ID";
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@Ngay", date);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }
    }
}