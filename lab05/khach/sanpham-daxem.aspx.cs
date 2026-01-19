using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lab05.khach
{
    public partial class sanpham_daxem : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadViewedBooks();
            }
        }

        private void LoadViewedBooks()
        {
            // Lấy danh sách ID sách đã xem từ Session (được lưu ở trang chitiet.aspx)
            List<int> viewedList = Session["ViewedBooks"] as List<int>;

            if (viewedList == null || viewedList.Count == 0)
            {
                pnlNoData.Visible = true;
                return;
            }

            // Chuyển List ID thành chuỗi (ví dụ: "1, 5, 10")
            string ids = string.Join(",", viewedList);

            using (SqlConnection con = new SqlConnection(strCon))
            {
                // Sử dụng hàm IN để lấy đúng những sách trong danh sách đã xem
                string sql = $"SELECT * FROM Sach WHERE MaSach IN ({ids})";
                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptViewed.DataSource = dt;
                rptViewed.DataBind();
            }
        }

        public string RenderTags(object tagsObj)
        {
            if (tagsObj == null || tagsObj == DBNull.Value) return "";
            string html = "";
            foreach (var tag in tagsObj.ToString().Split(','))
            {
                if (!string.IsNullOrWhiteSpace(tag))
                    html += $"<span class='tag-badge'>{tag.Trim()}</span>";
            }
            return html;
        }
    }
}