using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;

namespace lab05
{
    public partial class danhsach : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;
        int pageSize = 12;

        public int CurrentPage
        {
            get
            {
                int p;
                return (int.TryParse(Request.QueryString["page"], out p)) ? p : 1;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBooks();
            }
        }

        public string RenderTags(object tagsObj)
        {
            if (tagsObj == null || tagsObj == DBNull.Value || string.IsNullOrEmpty(tagsObj.ToString()))
                return "";

            string tags = tagsObj.ToString();
            string[] tagArray = tags.Split(',');
            string html = "";

            foreach (string tag in tagArray)
            {
                if (!string.IsNullOrWhiteSpace(tag))
                {
                    html += $"<span class='tag-badge'>{tag.Trim()}</span>";
                }
            }
            return html;
        }

        private void LoadBooks()
        {
            string maCD = Request.QueryString["MaCD"];
            string maLoai = Request.QueryString["MaLoai"];
            string search = Request.QueryString["search"];
            string price = Request.QueryString["price"];
            string sort = Request.QueryString["sort"];

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // 1. XÂY DỰNG ĐIỀU KIỆN LỌC (WHERE) [cite: 2026-03-11]
                string where = " WHERE TrangThai = 1";

                if (!string.IsNullOrEmpty(maCD)) where += " AND MaCD = @MaCD";
                if (!string.IsNullOrEmpty(maLoai)) where += " AND MaCD IN (SELECT MaCD FROM ChuDe WHERE MaLoai = @MaLoai)";
                if (!string.IsNullOrEmpty(search)) where += " AND TenSach LIKE @Search";

                // XỬ LÝ LỌC GIÁ
                if (!string.IsNullOrEmpty(price))
                {
                    if (price == "under100") where += " AND Dongia < 100000";
                    else if (price == "100to500") where += " AND Dongia BETWEEN 100000 AND 500000";
                    else if (price == "over500") where += " AND Dongia > 500000";
                    else if (price.Contains("-"))
                    {
                        string[] p = price.Split('-');
                        where += $" AND Dongia BETWEEN {p[0]} AND {p[1]}";
                    }
                }

                // 2. XỬ LÝ SẮP XẾP
                string orderBy = "Ngaycapnhat DESC";
                if (!string.IsNullOrEmpty(sort))
                {
                    switch (sort.ToLower())
                    {
                        case "name_asc": orderBy = "TenSach ASC"; break;
                        case "price_asc": orderBy = "Dongia ASC"; break;
                        case "date_desc": orderBy = "Ngaycapnhat DESC"; break;
                    }
                }

                // 3. LẤY DỮ LIỆU PHÂN TRANG OFFSET-FETCH [cite: 2026-03-11]
                string sqlData = $@"SELECT * FROM Sach {where} ORDER BY {orderBy} OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY";
                SqlCommand cmd = new SqlCommand(sqlData, conn);
                AddSqlParameters(cmd, maCD, maLoai, search);
                cmd.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * pageSize);
                cmd.Parameters.AddWithValue("@Limit", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptSach.DataSource = dt;
                rptSach.DataBind();

                if (pnlEmpty != null) pnlEmpty.Visible = (dt.Rows.Count == 0);

                // 4. ĐẾM TỔNG SỐ DÒNG ĐỂ CHIA TRANG
                SqlCommand cmdCount = new SqlCommand($"SELECT COUNT(*) FROM Sach {where}", conn);
                AddSqlParameters(cmdCount, maCD, maLoai, search);
                conn.Open();
                int totalRows = Convert.ToInt32(cmdCount.ExecuteScalar());
                conn.Close();

                int totalPages = (int)Math.Ceiling((double)totalRows / pageSize);
                BindPaginationUI(totalPages);
            }
        }

        private void AddSqlParameters(SqlCommand cmd, string maCD, string maLoai, string search)
        {
            if (!string.IsNullOrEmpty(maCD)) cmd.Parameters.AddWithValue("@MaCD", maCD);
            if (!string.IsNullOrEmpty(maLoai)) cmd.Parameters.AddWithValue("@MaLoai", maLoai);
            if (!string.IsNullOrEmpty(search)) cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
        }

        // --- 5. LOGIC PHÂN TRANG SLIDING WINDOW (ĐÃ FIX CỰC ĐẸP) [cite: 2026-03-11] ---
        private void BindPaginationUI(int totalPages)
        {
            // Kiểm tra các control để tránh lỗi NullReferenceException
            if (pnlPagination == null || rptPagination == null) return;
            if (totalPages <= 1) { pnlPagination.Visible = false; return; }
            pnlPagination.Visible = true;

            // Thiết lập URL cho các nút điều hướng cơ bản
            lnkFirst.NavigateUrl = GetPageUrl(1);
            lnkLast.NavigateUrl = GetPageUrl(totalPages);
            lnkPrev.NavigateUrl = GetPageUrl(CurrentPage > 1 ? CurrentPage - 1 : 1);
            lnkNext.NavigateUrl = GetPageUrl(CurrentPage < totalPages ? CurrentPage + 1 : totalPages);

            // Xử lý trạng thái Disabled cho các nút biên
            lnkFirst.CssClass = (CurrentPage == 1) ? "page-node page-nav-icon disabled" : "page-node page-nav-icon";
            lnkPrev.CssClass = (CurrentPage == 1) ? "page-node page-nav-icon disabled" : "page-node page-nav-icon";
            lnkNext.CssClass = (CurrentPage == totalPages) ? "page-node page-nav-icon disabled" : "page-node page-nav-icon";
            lnkLast.CssClass = (CurrentPage == totalPages) ? "page-node page-nav-icon disabled" : "page-node page-nav-icon";

            // Thuật toán dải số trượt (Hiển thị tối đa 5 nút) [cite: 2026-03-11]
            int startPage = Math.Max(1, CurrentPage - 2);
            int endPage = Math.Min(totalPages, startPage + 4);
            if (endPage - startPage < 4) startPage = Math.Max(1, endPage - 4);

            var pageNodes = new List<object>();
            for (int i = startPage; i <= endPage; i++)
            {
                pageNodes.Add(new { PageIndex = i, PageText = i.ToString(), IsActive = (i == CurrentPage) });
            }

            rptPagination.DataSource = pageNodes;
            rptPagination.DataBind();
        }

        protected string GetPageUrl(object pageNum)
        {
            var uri = new Uri(Request.Url.AbsoluteUri);
            var query = HttpUtility.ParseQueryString(uri.Query);
            query.Set("page", pageNum.ToString());
            return Request.Path + "?" + query.ToString();
        }

        protected void rptSach_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ThemGioHang")
            {
                int maSach = Convert.ToInt32(e.CommandArgument);
                ThemVaoGio(maSach);
                var myMaster = Master as lab05.Default;
                if (myMaster != null) myMaster.UpdateCartCountAjax();
                ScriptManager.RegisterStartupScript(this, GetType(), "Toast", "showToast();", true);
            }
        }

        private void ThemVaoGio(int maSach)
        {
            DataTable dt = (Session["Cart"] == null) ? CreateCartTable() : (DataTable)Session["Cart"];
            bool found = false;
            foreach (DataRow r in dt.Rows)
            {
                if (Convert.ToInt32(r["MaSach"]) == maSach)
                {
                    r["Soluong"] = Convert.ToInt32(r["Soluong"]) + 1;
                    r["Thanhtien"] = Convert.ToInt32(r["Soluong"]) * Convert.ToDecimal(r["Dongia"]);
                    found = true; break;
                }
            }
            if (!found)
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    string sql = "SELECT MaSach, TenSach, AnhBia, Dongia FROM Sach WHERE MaSach=@ID";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@ID", maSach);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        DataRow nr = dt.NewRow();
                        nr["MaSach"] = dr["MaSach"];
                        nr["TenSach"] = dr["TenSach"];
                        nr["HinhAnh"] = dr["AnhBia"];
                        nr["Dongia"] = dr["Dongia"];
                        nr["Soluong"] = 1;
                        nr["Thanhtien"] = dr["Dongia"];
                        dt.Rows.Add(nr);
                    }
                }
            }
            Session["Cart"] = dt;
        }

        private DataTable CreateCartTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("MaSach", typeof(int));
            dt.Columns.Add("TenSach", typeof(string));
            dt.Columns.Add("HinhAnh", typeof(string));
            dt.Columns.Add("Dongia", typeof(decimal));
            dt.Columns.Add("Soluong", typeof(int));
            dt.Columns.Add("Thanhtien", typeof(decimal));
            return dt;
        }
    }
}