using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace lab05.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        // Dữ liệu truyền ra Chart.js
        public string ChartLabels = "";
        public string ChartData = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Kiểm tra quyền Seller
            if (Session["MaRole"] == null || Session["MaRole"].ToString() != "2")
            {
                Response.Redirect("~/khach/dangnhap.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadRecentOrders();
                LoadChartData();
            }
        }

        // --- 1. TẢI CÁC CHỈ SỐ THỐNG KÊ TỔNG QUAN ---
        private void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                conn.Open();

                // Doanh thu thực tế
                SqlCommand cmdRev = new SqlCommand("SELECT ISNULL(SUM(Trigia), 0) FROM DonDatHang WHERE Dagiao = 1", conn);
                litRevenue.Text = Convert.ToDecimal(cmdRev.ExecuteScalar()).ToString("#,##0");

                // Tổng đơn hàng
                SqlCommand cmdOrders = new SqlCommand("SELECT COUNT(*) FROM DonDatHang", conn);
                litOrders.Text = cmdOrders.ExecuteScalar().ToString();

                // Tổng đầu sách
                SqlCommand cmdBooks = new SqlCommand("SELECT COUNT(*) FROM Sach", conn);
                litBooks.Text = cmdBooks.ExecuteScalar().ToString();

                conn.Close();
            }
        }

        // --- 2. TẢI DANH SÁCH GIAO DỊCH (BỎ TÌM KIẾM) [cite: 2026-03-14] ---
        private void LoadRecentOrders()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Lấy 8 đơn hàng mới nhất không cần lọc từ khóa
                string sql = @"SELECT TOP 8 D.SoDH, K.HoTenKH, D.Trigia, D.Dagiao 
                               FROM DonDatHang D 
                               JOIN KhachHang K ON D.MaKH = K.MaKH 
                               ORDER BY D.NgayDH DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRecentOrders.DataSource = dt;
                gvRecentOrders.DataBind();
            }
        }

        // --- 3. DỮ LIỆU BIỂU ĐỒ 7 NGÀY QUA ---
        private void LoadChartData()
        {
            List<string> labels = new List<string>();
            List<string> values = new List<string>();

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                conn.Open();
                for (int i = 6; i >= 0; i--)
                {
                    DateTime date = DateTime.Now.AddDays(-i);
                    labels.Add("'" + date.ToString("dd/MM") + "'");

                    string sql = "SELECT ISNULL(SUM(Trigia), 0) FROM DonDatHang " +
                                 "WHERE CAST(NgayDH AS DATE) = @d AND Dagiao = 1";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@d", date.Date);

                    values.Add(cmd.ExecuteScalar().ToString());
                }
                conn.Close();
            }

            ChartLabels = string.Join(",", labels);
            ChartData = string.Join(",", values);
        }
    }
}