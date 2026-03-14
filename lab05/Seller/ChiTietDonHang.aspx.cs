using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05.Seller
{
    public partial class ChiTietDonHang : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        public bool IsDelivered
        {
            get { return ViewState["IsDelivered"] != null ? (bool)ViewState["IsDelivered"] : false; }
            set { ViewState["IsDelivered"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MaRole"] == null || Convert.ToInt32(Session["MaRole"]) != 2)
                Response.Redirect("~/khach/dangnhap.aspx");

            if (Request.QueryString["id"] == null) Response.Redirect("QLDonHang.aspx");

            if (!IsPostBack)
            {
                int id = Convert.ToInt32(Request.QueryString["id"]);
                LoadFullOrderData(id);
            }
        }

        private void LoadFullOrderData(int id)
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // 1. Lấy thông tin Master
                string sqlH = "SELECT K.HoTenKH, D.Trigia, D.Dagiao, D.Ngaygiao FROM DonDatHang D JOIN KhachHang K ON D.MaKH = K.MaKH WHERE D.SoDH = @id";
                SqlCommand cmd = new SqlCommand(sqlH, conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    litOrderID.Text = id.ToString();
                    litCustomerName.Text = dr["HoTenKH"].ToString();
                    litTotal.Text = string.Format("{0:#,##0}", dr["Trigia"]);
                    IsDelivered = Convert.ToBoolean(dr["Dagiao"]);

                    if (dr["Ngaygiao"] != DBNull.Value)
                        txtDeliveryDate.Text = Convert.ToDateTime(dr["Ngaygiao"]).ToString("yyyy-MM-dd");

                    // NẾU ĐÃ GIAO: KHÓA FORM VÀ ẨN NÚT LƯU [cite: 2026-03-14]
                    if (IsDelivered)
                    {
                        divMainInfo.Attributes.Add("class", "order-locked-ui");
                        btnSave.Visible = false;
                        txtDeliveryDate.ReadOnly = true;
                    }
                }
                conn.Close();

                // 2. Lấy chi tiết sách
                string sqlD = "SELECT S.MaSach, S.TenSach, S.AnhBia, C.Soluong, C.Dongia, C.Thanhtien FROM CTDatHang C JOIN Sach S ON C.MaSach = S.MaSach WHERE C.SoDH = @id";
                SqlDataAdapter da = new SqlDataAdapter(sqlD, conn);
                da.SelectCommand.Parameters.AddWithValue("@id", id);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvDetails.DataSource = dt;
                gvDetails.DataBind();
            }
        }

        protected void gvDetails_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (IsDelivered)
                {
                    TextBox txt = (TextBox)e.Row.FindControl("txtQty");
                    if (txt != null) txt.Enabled = false;
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (IsDelivered) return;
            int soDH = Convert.ToInt32(Request.QueryString["id"]);

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // Cập nhật ngày giao
                    string sqlOrder = "UPDATE DonDatHang SET Ngaygiao = @ngay WHERE SoDH = @id";
                    SqlCommand cmd1 = new SqlCommand(sqlOrder, conn, trans);
                    cmd1.Parameters.AddWithValue("@ngay", string.IsNullOrEmpty(txtDeliveryDate.Text) ? (object)DBNull.Value : txtDeliveryDate.Text);
                    cmd1.Parameters.AddWithValue("@id", soDH);
                    cmd1.ExecuteNonQuery();

                    // Cập nhật từng dòng chi tiết [cite: 2026-03-11]
                    foreach (GridViewRow row in gvDetails.Rows)
                    {
                        int maSach = Convert.ToInt32(gvDetails.DataKeys[row.RowIndex].Value);
                        TextBox txt = (TextBox)row.FindControl("txtQty");
                        int qty = int.Parse(txt.Text);

                        string sqlDetail = "UPDATE CTDatHang SET Soluong = @q, Thanhtien = @q * Dongia WHERE SoDH = @dh AND MaSach = @s";
                        SqlCommand cmd2 = new SqlCommand(sqlDetail, conn, trans);
                        cmd2.Parameters.AddWithValue("@q", qty);
                        cmd2.Parameters.AddWithValue("@dh", soDH);
                        cmd2.Parameters.AddWithValue("@s", maSach);
                        cmd2.ExecuteNonQuery();
                    }

                    // Đồng bộ tổng tiền
                    string sqlSync = "UPDATE DonDatHang SET Trigia = ISNULL((SELECT SUM(Thanhtien) FROM CTDatHang WHERE SoDH = @id), 0) WHERE SoDH = @id";
                    SqlCommand cmd3 = new SqlCommand(sqlSync, conn, trans);
                    cmd3.Parameters.AddWithValue("@id", soDH);
                    cmd3.ExecuteNonQuery();

                    trans.Commit();
                    LoadFullOrderData(soDH);
                    ScriptManager.RegisterStartupScript(this, GetType(), "success", "showNotify('Hóa đơn đã được cập nhật thành công!');", true);
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    ScriptManager.RegisterStartupScript(this, GetType(), "fail", $"alert('Lỗi: {ex.Message}');", true);
                }
            }
        }
    }
}