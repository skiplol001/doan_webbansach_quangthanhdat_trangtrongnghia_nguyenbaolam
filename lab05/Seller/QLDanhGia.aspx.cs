using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;

namespace lab05.Admin
{
    public partial class QLDanhGia : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;
        int pageSize = 10;

        public int CurrentPage => (int.TryParse(Request.QueryString["page"], out int p)) ? p : 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) LoadComments();
        }

        private void LoadComments()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // FIX: Sử dụng LEFT JOIN để không bị mất dữ liệu nếu Khách hàng hoặc Sách bị lỗi [cite: 2026-03-13]
                string sql = $@"SELECT C.*, S.TenSach, K.HoTenKH, K.AnhKH 
                               FROM Comment C 
                               LEFT JOIN Sach S ON C.MaSach = S.MaSach 
                               LEFT JOIN KhachHang K ON C.MaKH = K.MaKH 
                               ORDER BY C.NgayBL DESC 
                               OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * pageSize);
                cmd.Parameters.AddWithValue("@Limit", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvComments.DataSource = dt;
                gvComments.DataBind();

                // Đếm tổng số để chia trang
                SqlCommand cmdCount = new SqlCommand("SELECT COUNT(*) FROM Comment", conn);
                conn.Open();
                int totalRows = Convert.ToInt32(cmdCount.ExecuteScalar());
                conn.Close();

                BindPaginationUI((int)Math.Ceiling((double)totalRows / pageSize));
            }
        }

        public string RenderStars(object starCount)
        {
            if (starCount == null || starCount == DBNull.Value) return "";
            int stars = Convert.ToInt32(starCount);
            string html = "";
            for (int i = 1; i <= 5; i++)
                html += (i <= stars) ? "<i class='fa-solid fa-star'></i>" : "<i class='fa-regular fa-star'></i>";
            return html;
        }

        private void BindPaginationUI(int totalPages)
        {
            if (totalPages <= 1) { lnkFirst.Visible = lnkLast.Visible = lnkPrev.Visible = lnkNext.Visible = rptPaging.Visible = false; return; }

            lnkFirst.Visible = lnkLast.Visible = lnkPrev.Visible = lnkNext.Visible = rptPaging.Visible = true;

            lnkFirst.NavigateUrl = GetPageUrl(1);
            lnkLast.NavigateUrl = GetPageUrl(totalPages);
            lnkPrev.NavigateUrl = GetPageUrl(CurrentPage > 1 ? CurrentPage - 1 : 1);
            lnkNext.NavigateUrl = GetPageUrl(CurrentPage < totalPages ? CurrentPage + 1 : totalPages);

            lnkFirst.CssClass = (CurrentPage == 1) ? "page-nav disabled" : "page-nav";
            lnkPrev.CssClass = (CurrentPage == 1) ? "page-nav disabled" : "page-nav";
            lnkNext.CssClass = (CurrentPage == totalPages) ? "page-nav disabled" : "page-nav";
            lnkLast.CssClass = (CurrentPage == totalPages) ? "page-nav disabled" : "page-nav";

            // Thuật toán trượt 5 nút [cite: 2026-03-11]
            int start = Math.Max(1, CurrentPage - 2);
            int end = Math.Min(totalPages, start + 4);
            if (end - start < 4) start = Math.Max(1, end - 4);

            var nodes = new List<object>();
            for (int i = start; i <= end; i++)
                nodes.Add(new { PageIndex = i, PageText = i.ToString(), IsActive = (i == CurrentPage) });

            rptPaging.DataSource = nodes;
            rptPaging.DataBind();
        }

        protected string GetPageUrl(object pageNum)
        {
            var query = HttpUtility.ParseQueryString(Request.Url.Query);
            query.Set("page", pageNum.ToString());
            return Request.Path + "?" + query.ToString();
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfDeleteID.Value)) return;

            int maBL = Convert.ToInt32(hfDeleteID.Value);
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Comment WHERE MaBL = @id", conn);
                cmd.Parameters.AddWithValue("@id", maBL);
                conn.Open();
                if (cmd.ExecuteNonQuery() > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "T", "closeDeleteModal(); showToast('Đã xóa đánh giá thành công!');", true);
                    LoadComments();
                }
            }
        }
    }
}