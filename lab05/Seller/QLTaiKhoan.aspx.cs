using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;

namespace lab05.Admin
{
    public partial class QLTaiKhoan : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;
        int pageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Bảo mật: Role Seller (2)
            if (Session["MaRole"] == null || Session["MaRole"].ToString() != "2")
                Response.Redirect("~/khach/dangnhap.aspx");

            if (!IsPostBack) LoadData();
        }

        // --- HÀM QUAN TRỌNG: ĐỊNH NGHĨA IsUserOnline ĐỂ TRÁNH LỖI CS0103 VÀ DBNULL [cite: 2026-03-11] ---
        // Phải là 'protected' hoặc 'public' để file .aspx nhìn thấy
        protected bool IsUserOnline(object value)
        {
            // Nếu Database trả về NULL thì coi như Offline (false)
            if (value == null || value == DBNull.Value) return false;

            // Nếu có giá trị thì ép kiểu Boolean
            return Convert.ToBoolean(value);
        }

        private void LoadData()
        {
            int currentPage = 1;
            if (Request.QueryString["page"] != null) int.TryParse(Request.QueryString["page"], out currentPage);

            string keyword = txtSearch.Text.Trim();
            if (string.IsNullOrEmpty(keyword) && Request.QueryString["search"] != null)
            {
                keyword = Server.UrlDecode(Request.QueryString["search"]);
                txtSearch.Text = keyword;
            }

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Tính tổng số trang
                string countSql = "SELECT COUNT(*) FROM KhachHang WHERE HoTenKH LIKE @key OR Email LIKE @key";
                SqlCommand cmdCount = new SqlCommand(countSql, conn);
                cmdCount.Parameters.AddWithValue("@key", "%" + keyword + "%");
                conn.Open();
                int totalRecords = (int)cmdCount.ExecuteScalar();
                int totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
                conn.Close();

                // Phân trang SQL chuẩn OFFSET FETCH [cite: 2026-03-11]
                string dataSql = @"SELECT * FROM KhachHang 
                                   WHERE HoTenKH LIKE @key OR Email LIKE @key 
                                   ORDER BY IsOnline DESC, LastSeen DESC 
                                   OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY";

                SqlDataAdapter da = new SqlDataAdapter(dataSql, conn);
                da.SelectCommand.Parameters.AddWithValue("@key", "%" + keyword + "%");
                da.SelectCommand.Parameters.AddWithValue("@offset", (currentPage - 1) * pageSize);
                da.SelectCommand.Parameters.AddWithValue("@limit", pageSize);

                DataTable dt = new DataTable();
                da.Fill(dt);
                gvAccounts.DataSource = dt;
                gvAccounts.DataBind();

                CreateSlidingPaging(currentPage, totalPages);
            }
        }

        // --- SỬA LỖI TÌM KIẾM ---
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            Response.Redirect(GetPageUrl(1));
        }

        protected void tmrRefresh_Tick(object sender, EventArgs e)
        {
            LoadData(); // Cập nhật danh sách qua AJAX Timer [cite: 2026-03-11]
        }

        private void CreateSlidingPaging(int current, int total)
        {
            if (total <= 1) { rptPaging.Visible = lnkFirst.Visible = lnkLast.Visible = lnkPrev.Visible = lnkNext.Visible = false; return; }
            rptPaging.Visible = true;

            lnkFirst.NavigateUrl = GetPageUrl(1);
            lnkLast.NavigateUrl = GetPageUrl(total);
            lnkPrev.NavigateUrl = GetPageUrl(current > 1 ? current - 1 : 1);
            lnkNext.NavigateUrl = GetPageUrl(current < total ? current + 1 : total);

            // Xử lý nút Disabled
            lnkFirst.CssClass = (current == 1) ? "page-nav disabled" : "page-nav";
            lnkPrev.CssClass = (current == 1) ? "page-nav disabled" : "page-nav";
            lnkNext.CssClass = (current == total) ? "page-nav disabled" : "page-nav";
            lnkLast.CssClass = (current == total) ? "page-nav disabled" : "page-nav";

            // Tính dải số trượt trung tâm (5 nút)
            int start = Math.Max(1, current - 2);
            int end = Math.Min(total, start + 4);
            if (end - start < 4) start = Math.Max(1, end - 4);

            var pages = new List<object>();
            for (int i = start; i <= end; i++)
                pages.Add(new { PageIndex = i, PageText = i, IsActive = (i == current) });

            rptPaging.DataSource = pages;
            rptPaging.DataBind();
        }

        public string GetPageUrl(object pageNum)
        {
            string s = !string.IsNullOrEmpty(txtSearch.Text) ? "&search=" + Server.UrlEncode(txtSearch.Text) : "";
            return "QLTaiKhoan.aspx?page=" + pageNum + s;
        }
    }
}