<%@ Page Title="Danh mục sách" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="danhsach.aspx.cs" Inherits="lab05.danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary: #ff4081; --primary-light: #fff0f5; --text-main: #1e293b; }

        /* --- THIẾT KẾ COMPACT NHỎ LẠI 20% --- */
        .sach-container { max-width: 1250px; margin: 0 auto; padding-bottom: 60px; }
        .page-header { border-bottom: 2px solid #f1f5f9; padding-bottom: 15px; margin: 30px 0; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-size: 1.8rem; font-weight: 900; color: var(--text-main); text-transform: uppercase; letter-spacing: -0.5px; }
        .page-title span { color: var(--primary); }

        /* GRID HỆ THỐNG GỌN GÀNG */
        .books-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 25px; }
        
        .book-card { 
            background: #fff; border-radius: 20px; padding: 18px; border: 1px solid #f1f5f9;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); display: flex; flex-direction: column; height: 100%; position: relative;
        }
        .book-card:hover { transform: translateY(-10px); box-shadow: 0 15px 35px rgba(0,0,0,0.07); border-color: var(--primary-light); }

        .img-wrapper { height: 240px; border-radius: 16px; background: #f8fafc; display: flex; align-items: center; justify-content: center; overflow: hidden; margin-bottom: 15px; position: relative; }
        .img-wrapper img { max-width: 85%; max-height: 85%; object-fit: contain; transition: 0.5s ease; }
        .book-card:hover .img-wrapper img { transform: scale(1.1); }

        /* Tag Overlay */
        .tags-overlay { position: absolute; top: 12px; left: 12px; display: flex; flex-wrap: wrap; gap: 5px; z-index: 5; }
        .tag-badge { background: rgba(255,255,255,0.9); color: var(--primary); padding: 3px 8px; border-radius: 6px; font-size: 9px; font-weight: 800; text-transform: uppercase; border-left: 3px solid var(--primary); box-shadow: 0 2px 5px rgba(0,0,0,0.05); }

        .book-name { font-weight: 700; font-size: 14px; height: 3rem; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; margin-bottom: 10px; line-height: 1.5; color: var(--text-main); }
        .book-price { color: var(--primary); font-weight: 800; font-size: 1.3rem; margin-bottom: 15px; display: block; }

        .btn-buy { 
            background: var(--primary); color: #fff !important; height: 45px; border-radius: 12px; 
            font-weight: 700; font-size: 13px; border: none; cursor: pointer; margin-top: auto;
            display: flex; align-items: center; justify-content: center; gap: 8px; transition: 0.3s;
        }
        .btn-buy:hover { background: #1e293b; transform: scale(1.02); }

        /* --- PHÂN TRANG HIỆN ĐẠI (ĐÃ FIX ĐẸP HƠN) [cite: 2026-03-11] --- */
        .pagination-container { display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 50px; }
        .page-node { 
            text-decoration: none; min-width: 42px; height: 42px; display: flex; align-items: center; justify-content: center; 
            border-radius: 12px; background: #fff; color: #64748b; border: 1px solid #e2e8f0; 
            font-weight: 800; font-size: 14px; transition: all 0.3s ease;
        }
        .page-node:hover:not(.disabled) { 
            border-color: var(--primary); color: var(--primary); background: var(--primary-light); 
            transform: translateY(-4px); box-shadow: 0 5px 15px rgba(255, 64, 129, 0.1); 
        }
        .page-node.active { 
            background: var(--primary); color: #fff !important; border-color: var(--primary); 
            box-shadow: 0 8px 20px rgba(255, 64, 129, 0.3); 
        }
        .page-node.disabled { opacity: 0.3; pointer-events: none; background: #f8fafc; border-color: #f1f5f9; color: #cbd5e1; }
        .page-nav-icon { font-size: 12px; width: auto; padding: 0 15px; }

        /* Toast */
        #toastBox { position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%); background: #1e293b; color: #fff; padding: 15px 35px; border-radius: 50px; z-index: 10000; display: none; box-shadow: 0 15px 35px rgba(0,0,0,0.3); font-weight: 600; }
    </style>

    <script type="text/javascript">
        function showToast() {
            var t = document.getElementById("toastBox");
            t.style.display = "block";
            t.innerHTML = "<i class='fa-solid fa-circle-check' style='color:#4ade80; margin-right:10px;'></i> Đã thêm vào giỏ hàng!";
            setTimeout(function () { t.style.display = "none"; }, 3000);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <div class="sach-container">
        <div class="page-header">
            <h2 id="hTitle" runat="server" class="page-title">DANH MỤC <span>SÁCH</span></h2>
        </div>

        <asp:UpdatePanel ID="upList" runat="server">
            <ContentTemplate>
                <%-- Hiển thị khi trống --%>
                <asp:Panel ID="pnlEmpty" runat="server" Visible="false" Style="text-align: center; padding: 100px 0;">
                    <i class="fa-solid fa-box-open" style="font-size: 50px; color: #e2e8f0; margin-bottom: 20px; display:block;"></i>
                    <h4 style="color: #94a3b8;">Không tìm thấy sách phù hợp với bộ lọc.</h4>
                    <a href="danhsach.aspx" class="btn-buy" style="display:inline-flex; width:auto; padding: 0 30px; margin-top:15px; text-decoration:none;">XEM TẤT CẢ</a>
                </asp:Panel>

                <div class="books-grid">
                    <asp:Repeater ID="rptSach" runat="server" OnItemCommand="rptSach_ItemCommand">
                        <ItemTemplate>
                            <div class="book-card" onclick="window.location.href='chitiet.aspx?MaSach=<%# Eval("MaSach") %>'">
                                <div class="img-wrapper">
                                    <div class="tags-overlay">
                                        <%# RenderTags(Eval("Tags")) %>
                                    </div>
                                    <img src='<%# ResolveUrl("~/Images/") + (Eval("AnhBia") != DBNull.Value && !string.IsNullOrEmpty(Eval("AnhBia").ToString()) ? Eval("AnhBia") : "no-image.jpg") %>' alt='<%# Eval("TenSach") %>' />
                                </div>
                                <div class="book-name" title='<%# Eval("TenSach") %>'><%# Eval("TenSach") %></div>
                                <div class="book-price"><%# string.Format("{0:#,##0} đ", Eval("Dongia")) %></div>
                                
                                <asp:LinkButton ID="btnThem" runat="server" CommandName="ThemGioHang" 
                                    CommandArgument='<%# Eval("MaSach") %>' CssClass="btn-buy" 
                                    OnClientClick="event.stopPropagation();">
                                    <i class="fa-solid fa-cart-shopping"></i> MUA NGAY
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <%-- PHÂN TRANG SLIDING WINDOW CHUẨN (ĐÃ FIX ĐẸP) [cite: 2026-03-11] --%>
                <asp:Panel ID="pnlPagination" runat="server" CssClass="pagination-container">
                    <asp:HyperLink ID="lnkFirst" runat="server" CssClass="page-node page-nav-icon" ToolTip="Trang đầu">
                        <i class="fa-solid fa-angles-left"></i>
                    </asp:HyperLink>
                    
                    <asp:HyperLink ID="lnkPrev" runat="server" CssClass="page-node page-nav-icon" ToolTip="Trang trước">
                        <i class="fa-solid fa-angle-left"></i>
                    </asp:HyperLink>

                    <asp:Repeater ID="rptPagination" runat="server">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkPageNum" runat="server"
                                Text='<%# Eval("PageText") %>'
                                NavigateUrl='<%# GetPageUrl(Eval("PageIndex")) %>'
                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "page-node active" : "page-node" %>'>
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:HyperLink ID="lnkNext" runat="server" CssClass="page-node page-nav-icon" ToolTip="Trang sau">
                        <i class="fa-solid fa-angle-right"></i>
                    </asp:HyperLink>

                    <asp:HyperLink ID="lnkLast" runat="server" CssClass="page-node page-nav-icon" ToolTip="Trang cuối">
                        <i class="fa-solid fa-angles-right"></i>
                    </asp:HyperLink>
                </asp:Panel>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>