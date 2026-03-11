using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Text;

namespace lab05
{
    public partial class trangchu : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;
        int pageSize = 8; // Số sách mỗi trang

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load Carousel cố định (đã có SqlDataSource ở ASPX)
                // Load danh sách sách mới kèm phân trang
                int currentPage = 1;
                if (Request.QueryString["page"] != null)
                {
                    int.TryParse(Request.QueryString["page"], out currentPage);
                }
                LoadPagedBooks(currentPage);
            }
        }

        private void LoadPagedBooks(int page)
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // SQL OFFSET/FETCH: Phân trang tốc độ cao
                string sql = @"SELECT * FROM Sach WHERE TrangThai=1 
                             ORDER BY Ngaycapnhat DESC 
                             OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Offset", (page - 1) * pageSize);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptSach.DataSource = dt;
                rptSach.DataBind();

                // Xử lý tạo 5 nút bấm phân trang
                BindPagingButtons(page);
            }
        }

        /// <summary>
        /// Thuật toán giới hạn hiển thị đúng 5 mục số trang
        /// </summary>
        private void BindPagingButtons(int currentPage)
        {
            int totalRecords = 0;
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Sach WHERE TrangThai=1", conn);
                conn.Open();
                totalRecords = (int)cmd.ExecuteScalar();
            }

            int totalPages = (int)Math.Ceiling((double)totalRecords / pageSize);
            if (totalPages <= 1)
            {
                lnkPrev.Visible = lnkNext.Visible = false;
                return;
            }

            // --- THUẬT TOÁN GIỚI HẠN 5 MỤC ---
            int startPage = currentPage - 2;
            int endPage = currentPage + 2;

            if (startPage < 1)
            {
                startPage = 1;
                endPage = Math.Min(totalPages, startPage + 4);
            }
            if (endPage > totalPages)
            {
                endPage = totalPages;
                startPage = Math.Max(1, endPage - 4);
            }

            DataTable dtPaging = new DataTable();
            dtPaging.Columns.Add("PageIndex");
            dtPaging.Columns.Add("PageText");
            dtPaging.Columns.Add("IsActive", typeof(bool));

            for (int i = startPage; i <= endPage; i++)
            {
                DataRow dr = dtPaging.NewRow();
                dr["PageIndex"] = i;
                dr["PageText"] = i.ToString();
                dr["IsActive"] = (i == currentPage);
                dtPaging.Rows.Add(dr);
            }

            rptPaging.DataSource = dtPaging;
            rptPaging.DataBind();

            // Cấu hình nút Trước/Sau
            lnkPrev.NavigateUrl = "trangchu.aspx?page=" + (currentPage > 1 ? (currentPage - 1) : 1);
            lnkNext.NavigateUrl = "trangchu.aspx?page=" + (currentPage < totalPages ? (currentPage + 1) : totalPages);
            lnkPrev.Enabled = (currentPage > 1);
            lnkNext.Enabled = (currentPage < totalPages);
        }

        // --- CÁC HÀM TIỆN ÍCH GIỮ NGUYÊN (KHÔNG TỐI GIẢN) ---
        public string RenderTags(object tagsObj)
        {
            if (tagsObj == null || tagsObj == DBNull.Value || string.IsNullOrEmpty(tagsObj.ToString())) return "";
            string[] tags = tagsObj.ToString().Split(',');
            StringBuilder sb = new StringBuilder();
            int c = 0;
            foreach (string t in tags)
            {
                if (c >= 3) break;
                if (!string.IsNullOrEmpty(t.Trim()))
                {
                    sb.AppendFormat("<span class='tag-badge'>{0}</span>", t.Trim());
                    c++;
                }
            }
            return sb.ToString();
        }

        protected void rptSach_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ThemGioHang")
            {
                int maSach = Convert.ToInt32(e.CommandArgument);
                ThemSachVaoSession(maSach);
                var myMaster = Master as lab05.Default;
                if (myMaster != null) myMaster.UpdateCartCountAjax();
                ScriptManager.RegisterStartupScript(this, GetType(), "Toast", "showToast();", true);
            }
        }

        private void ThemSachVaoSession(int maSach)
        {
            DataTable dt = (Session["Cart"] == null) ? CreateCartTable() : (DataTable)Session["Cart"];
            bool exists = false;
            foreach (DataRow r in dt.Rows)
            {
                if (Convert.ToInt32(r["MaSach"]) == maSach)
                {
                    r["Soluong"] = (int)r["Soluong"] + 1;
                    r["Thanhtien"] = (int)r["Soluong"] * (decimal)r["Dongia"];
                    exists = true; break;
                }
            }
            if (!exists)
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    SqlCommand cmd = new SqlCommand("SELECT MaSach, TenSach, AnhBia, Dongia FROM Sach WHERE MaSach=@ID", conn);
                    cmd.Parameters.AddWithValue("@ID", maSach); conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read()) dt.Rows.Add(dr["MaSach"], dr["TenSach"], dr["AnhBia"], dr["Dongia"], 1, dr["Dongia"]);
                }
            }
            Session["Cart"] = dt;
        }

        private DataTable CreateCartTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("MaSach", typeof(int)); dt.Columns.Add("TenSach", typeof(string));
            dt.Columns.Add("HinhAnh", typeof(string)); dt.Columns.Add("Dongia", typeof(decimal));
            dt.Columns.Add("Soluong", typeof(int)); dt.Columns.Add("Thanhtien", typeof(decimal));
            return dt;
        }
    }
}