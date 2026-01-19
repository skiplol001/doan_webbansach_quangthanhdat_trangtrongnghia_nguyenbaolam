using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace lab05.khach
{
    public partial class leaderboard : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadLeaderboardData();
            }
        }

        private void LoadLeaderboardData()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // Lấy Top 20 sách có lượt xem cao nhất
                string sql = "SELECT TOP 20 * FROM Sach ORDER BY ISNULL(Soluotxem, 0) DESC, TenSach ASC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dtFull = new DataTable();
                da.Fill(dtFull);

                // Tách 3 sản phẩm đầu tiên cho Top 3
                DataTable dtTop3 = dtFull.Clone();
                for (int i = 0; i < Math.Min(3, dtFull.Rows.Count); i++)
                {
                    dtTop3.ImportRow(dtFull.Rows[i]);
                }

                // Tách các sản phẩm còn lại (từ hạng 4 trở đi)
                DataTable dtOthers = dtFull.Clone();
                for (int i = 3; i < dtFull.Rows.Count; i++)
                {
                    dtOthers.ImportRow(dtFull.Rows[i]);
                }

                // Bind vào các Repeater
                rptTop3.DataSource = dtTop3;
                rptTop3.DataBind();

                rptOtherRanks.DataSource = dtOthers;
                rptOtherRanks.DataBind();
            }
        }

        // Tái sử dụng hàm RenderTags để đồng bộ giao diện
        public string RenderTags(object tagsObj)
        {
            if (tagsObj == null || tagsObj == DBNull.Value || string.IsNullOrEmpty(tagsObj.ToString()))
            {
                return "";
            }

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

        // Xử lý thêm vào giỏ hàng từ bảng xếp hạng
        protected void rptOtherRanks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ThemGioHang")
            {
                int maSach = Convert.ToInt32(e.CommandArgument);
                ThemVaoGio(maSach);

                // Cập nhật số lượng giỏ hàng trên Header (AJAX)
                var myMaster = Master as lab05.Default;
                if (myMaster != null)
                {
                    myMaster.UpdateCartCountAjax();
                }

                // Thông báo nhanh
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đã thêm vào giỏ hàng!');", true);
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
                    SqlCommand cmd = new SqlCommand("SELECT MaSach, TenSach, AnhBia, Dongia FROM Sach WHERE MaSach=@ID", con);
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