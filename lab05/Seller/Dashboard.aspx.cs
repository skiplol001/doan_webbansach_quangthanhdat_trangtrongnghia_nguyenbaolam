using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.UI;
using System.Linq;

namespace lab05.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        // Biến để truyền dữ liệu vào Chart.js
        public string ChartLabels = "";
        public string ChartData = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MaRole"] == null || Session["MaRole"].ToString() != "2")
            {
                Response.Redirect("~/khach/trangchu.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStatistics();
                LoadRecentOrders();
                LoadChartData();
            }
        }

        private void LoadStatistics()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                try
                {
                    conn.Open();

                    // FIX: Chỉ tính doanh thu đơn hàng đã giao (Dagiao = 1) [cite: 2026-03-11]
                    SqlCommand cmdRev = new SqlCommand("SELECT SUM(Trigia) FROM DonDatHang WHERE Dagiao = 1", conn);
                    object rev = cmdRev.ExecuteScalar();
                    litRevenue.Text = (rev != null && rev != DBNull.Value) ? string.Format("{0:#,##0}", rev) : "0";

                    // Đếm tổng số đơn hàng (Tất cả trạng thái)
                    SqlCommand cmdOrd = new SqlCommand("SELECT COUNT(*) FROM DonDatHang", conn);
                    litOrders.Text = cmdOrd.ExecuteScalar().ToString();

                    // Đếm tổng số sách đang kinh doanh
                    SqlCommand cmdBook = new SqlCommand("SELECT COUNT(*) FROM Sach", conn);
                    litBooks.Text = cmdBook.ExecuteScalar().ToString();
                }
                catch { litRevenue.Text = "0"; }
            }
        }

        private void LoadChartData()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Lấy doanh thu đã giao của 7 ngày gần nhất [cite: 2026-03-11]
                string sql = @"SELECT TOP 7 CONVERT(VARCHAR(10), NgayDH, 103) as Ngay, SUM(Trigia) as DoanhThu
                               FROM DonDatHang 
                               WHERE Dagiao = 1 AND NgayDH >= DATEADD(day, -7, GETDATE())
                               GROUP BY CONVERT(VARCHAR(10), NgayDH, 103), CAST(NgayDH as Date)
                               ORDER BY CAST(NgayDH as Date) ASC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                List<string> labels = new List<string>();
                List<string> values = new List<string>();

                while (dr.Read())
                {
                    labels.Add("'" + dr["Ngay"].ToString() + "'");
                    values.Add(dr["DoanhThu"].ToString());
                }

                // Nếu chưa có dữ liệu, tạo dữ liệu giả để biểu đồ không trống
                if (labels.Count == 0) { labels.Add("'Chưa có dữ liệu'"); values.Add("0"); }

                ChartLabels = string.Join(",", labels);
                ChartData = string.Join(",", values);
            }
        }

        private void LoadRecentOrders()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = @"SELECT TOP 8 d.SoDH, d.Trigia, d.Dagiao, k.HoTenKH 
                               FROM DonDatHang d JOIN KhachHang k ON d.MaKH = k.MaKH 
                               ORDER BY d.NgayDH DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvRecentOrders.DataSource = dt;
                gvRecentOrders.DataBind();
            }
        }
    }
}