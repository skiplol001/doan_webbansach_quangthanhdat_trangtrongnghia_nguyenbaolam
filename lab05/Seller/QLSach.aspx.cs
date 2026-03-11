using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace lab05.Seller
{
    public partial class QLSach : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;
        int pageSize = 5; // Số mục trên mỗi trang

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MaRole"] == null || Convert.ToInt32(Session["MaRole"]) != 2)
                Response.Redirect("~/khach/dangnhap.aspx");

            if (!IsPostBack)
            {
                LoadSachData();
            }
        }

        private void LoadSachData()
        {
            // 1. Lấy trang hiện tại và từ khóa tìm kiếm [cite: 2026-03-11]
            int currentPage = 1;
            if (Request.QueryString["page"] != null) int.TryParse(Request.QueryString["page"], out currentPage);
            string keyword = txtSearch.Text.Trim();

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // 2. Đếm tổng số bản ghi để tính số trang
                string countSql = "SELECT COUNT(*) FROM Sach WHERE TenSach LIKE @key";
                SqlCommand cmdCount = new SqlCommand(countSql, conn);
                cmdCount.Parameters.AddWithValue("@key", "%" + keyword + "%");
                conn.Open();
                int totalRecords = (int)cmdCount.ExecuteScalar();
                int totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
                conn.Close();

                // 3. Lấy dữ liệu phân trang (Sử dụng OFFSET FETCH) [cite: 2026-03-11]
                string sql = @"SELECT * FROM Sach WHERE TenSach LIKE @key 
                               ORDER BY Ngaycapnhat DESC 
                               OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                da.SelectCommand.Parameters.AddWithValue("@key", "%" + keyword + "%");
                da.SelectCommand.Parameters.AddWithValue("@offset", (currentPage - 1) * pageSize);
                da.SelectCommand.Parameters.AddWithValue("@limit", pageSize);

                DataTable dt = new DataTable();
                da.Fill(dt);
                gvSach.DataSource = dt;
                gvSach.DataBind();

                // 4. Tạo dải số phân trang Sliding Window (5 nút)
                CreatePagingUI(currentPage, totalPages);
            }
        }

        private void CreatePagingUI(int current, int total)
        {
            if (total <= 1) { lnkFirst.Visible = lnkLast.Visible = lnkPrev.Visible = lnkNext.Visible = rptPaging.Visible = false; return; }
            rptPaging.Visible = true;

            // Thiết lập URL cho các nút điều hướng đầu cuối
            lnkFirst.NavigateUrl = GetPageUrl(1);
            lnkLast.NavigateUrl = GetPageUrl(total);
            lnkPrev.NavigateUrl = GetPageUrl(current > 1 ? current - 1 : 1);
            lnkNext.NavigateUrl = GetPageUrl(current < total ? current + 1 : total);

            // Thuật toán Sliding: Nút hiện tại luôn cố gắng ở giữa dải 5 nút [cite: 2026-03-11]
            int startPage = Math.Max(1, current - 2);
            int endPage = Math.Min(total, startPage + 4);
            if (endPage - startPage < 4) startPage = Math.Max(1, endPage - 4);

            var pages = new List<object>();
            for (int i = startPage; i <= endPage; i++)
            {
                pages.Add(new { PageIndex = i, PageText = i, IsActive = (i == current) });
            }

            rptPaging.DataSource = pages;
            rptPaging.DataBind();
        }

        // Hàm tạo URL để giữ lại từ khóa tìm kiếm khi chuyển trang [cite: 2026-03-11]
        public string GetPageUrl(object pageIndex)
        {
            return $"QLSach.aspx?page={pageIndex}&search={Server.UrlEncode(txtSearch.Text)}";
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Tìm kiếm mới thì quay về trang 1
            Response.Redirect(GetPageUrl(1));
        }

        protected void gvSach_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvSach.DataKeys[e.RowIndex].Value);
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Sach WHERE MaSach=@id", conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
                LoadSachData();
            }
        }
    }
}