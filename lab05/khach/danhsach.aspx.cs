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
                string where = " WHERE TrangThai = 1";
                if (!string.IsNullOrEmpty(maCD)) where += " AND MaCD = @MaCD";
                if (!string.IsNullOrEmpty(maLoai)) where += " AND MaCD IN (SELECT MaCD FROM ChuDe WHERE MaLoai = @MaLoai)";
                if (!string.IsNullOrEmpty(search)) where += " AND TenSach LIKE @Search";

                // Xử lý logic lọc giá
                if (price == "under100" || price == "0-100") where += " AND Dongia < 100000";
                else if (price == "100to500" || price == "100-500") where += " AND Dongia BETWEEN 100000 AND 500000";
                else if (price == "over500") where += " AND Dongia > 500000";

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

                string sqlData = $@"SELECT * FROM Sach {where} ORDER BY {orderBy} OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY";
                SqlCommand cmd = new SqlCommand(sqlData, conn);

                if (!string.IsNullOrEmpty(maCD)) cmd.Parameters.AddWithValue("@MaCD", maCD);
                if (!string.IsNullOrEmpty(maLoai)) cmd.Parameters.AddWithValue("@MaLoai", maLoai);
                if (!string.IsNullOrEmpty(search)) cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                cmd.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * pageSize);
                cmd.Parameters.AddWithValue("@Limit", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptSach.DataSource = dt;
                rptSach.DataBind();
                pnlEmpty.Visible = (dt.Rows.Count == 0);

                SqlCommand cmdCount = new SqlCommand($"SELECT COUNT(*) FROM Sach {where}", conn);
                if (!string.IsNullOrEmpty(maCD)) cmdCount.Parameters.AddWithValue("@MaCD", maCD);
                if (!string.IsNullOrEmpty(maLoai)) cmdCount.Parameters.AddWithValue("@MaLoai", maLoai);
                if (!string.IsNullOrEmpty(search)) cmdCount.Parameters.AddWithValue("@Search", "%" + search + "%");

                conn.Open();
                int totalRows = Convert.ToInt32(cmdCount.ExecuteScalar());
                conn.Close();

                int totalPages = (int)Math.Ceiling((double)totalRows / pageSize);
                BindPagination(totalPages);
            }
        }

        private void BindPagination(int totalPages)
        {
            if (totalPages <= 1) { lnkFirst.Visible = lnkLast.Visible = rptPagination.Visible = false; return; }
            lnkFirst.Visible = lnkLast.Visible = rptPagination.Visible = true;
            lnkFirst.NavigateUrl = GetPageUrl(1);
            lnkLast.NavigateUrl = GetPageUrl(totalPages);
            List<int> pages = new List<int>();
            for (int i = 1; i <= totalPages; i++) pages.Add(i);
            rptPagination.DataSource = pages;
            rptPagination.DataBind();
        }

        protected string GetPageUrl(object pageNum)
        {
            var myMaster = Master as lab05.Default;
            if (myMaster != null) return myMaster.GetMasterFilterUrl("page", pageNum.ToString());
            return "danhsach.aspx?page=" + pageNum;
        }

        protected void rptSach_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ThemGioHang")
            {
                // ==========================================
                // KIỂM TRA ĐĂNG NHẬP TRƯỚC KHI THÊM HÀNG
                // ==========================================
                if (Session["MaKH"] == null && Session["HoTen"] == null)
                {
                    // Chuyển hướng sang trang đăng nhập trong folder khach
                    Response.Redirect("~/khach/dangnhap.aspx");
                    return; // Dừng mọi xử lý thêm vào giỏ hàng
                }

                // Nếu đã đăng nhập thì tiếp tục logic
                int maSach = Convert.ToInt32(e.CommandArgument);
                ThemVaoGio(maSach);

                var myMaster = Master as lab05.Default;
                if (myMaster != null)
                {
                    myMaster.UpdateCartCountAjax();
                }

                // Hiển thị thông báo Toast phía Client
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