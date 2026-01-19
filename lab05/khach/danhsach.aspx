<%@ Page Title="Danh mục sách" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="danhsach.aspx.cs" Inherits="lab05.danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- TỔNG THỂ --- */
        .sach-container { padding-bottom: 80px; max-width: 1400px; margin: 0 auto; }
        
        .page-header {
            display: flex; justify-content: space-between; align-items: center;
            margin: 40px 0 30px; border-bottom: 2px solid #f1f5f9; padding-bottom: 20px;
        }

        .page-title { color: var(--text); font-size: 2.2rem; font-weight: 800; margin: 0; text-transform: uppercase; }
        .page-title span { color: var(--primary); }

        /* --- GRID HỆ THỐNG --- */
        .books-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); 
            gap: 30px; 
            margin-bottom: 50px; 
        }

        /* --- CARD SÁCH PREMIUM --- */
        .book-card { 
            background: #fff; border-radius: 24px; padding: 20px; 
            border: 1px solid rgba(0,0,0,0.04); transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
            display: flex; flex-direction: column; cursor: pointer; position: relative;
            height: 100%;
        }
        .book-card:hover { 
            transform: translateY(-12px); 
            box-shadow: 0 20px 40px rgba(0,0,0,0.08); 
            border-color: var(--primary-light); 
        }

        /* --- IMAGE & TAGS OVERLAY --- */
        .img-wrapper { 
            height: 280px; display: flex; align-items: center; justify-content: center; 
            background: #f8fafc; border-radius: 20px; margin-bottom: 20px; 
            overflow: hidden; position: relative;
        }
        .img-wrapper img { 
            max-width: 85%; max-height: 85%; object-fit: contain; 
            transition: 0.5s ease;
        }
        .book-card:hover .img-wrapper img { transform: scale(1.1); }

        .tags-overlay {
            position: absolute; top: 15px; left: 15px;
            display: flex; flex-wrap: wrap; gap: 6px; z-index: 10;
            max-width: 85%;
        }
        .tag-badge {
            background: rgba(255, 255, 255, 0.95); color: var(--primary);
            padding: 4px 10px; border-radius: 8px; font-size: 10px; font-weight: 800;
            text-transform: uppercase; border-left: 3px solid var(--primary);
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            pointer-events: none;
        }

        /* --- INFO --- */
        .book-name { 
            font-weight: 700; color: var(--text); font-size: 1.1rem;
            height: 3rem; overflow: hidden; display: -webkit-box; 
            -webkit-line-clamp: 2; -webkit-box-orient: vertical; 
            margin-bottom: 12px; line-height: 1.5; 
        }
        .book-price { color: var(--primary); font-weight: 800; font-size: 1.4rem; margin-bottom: 15px; }

        /* --- ACTIONS --- */
        .btn-buy { 
            background: var(--primary); color: #fff !important; height: 50px; border-radius: 15px; 
            display: flex; align-items: center; justify-content: center; text-decoration: none; 
            font-weight: 700; border: none; cursor: pointer; width: 100%; transition: 0.3s;
            margin-top: auto;
        }
        .btn-buy:hover { background: #333; transform: scale(1.02); }

        /* --- PHÂN TRANG --- */
        .pagination { display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 60px; }
        .page-node { 
            text-decoration: none; min-width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; 
            border-radius: 12px; background: #fff; color: #64748b; border: 1px solid #e2e8f0; font-weight: 700; transition: 0.3s; 
        }
        .page-node:hover:not(.disabled) { border-color: var(--primary); color: var(--primary); background: var(--primary-light); }
        .page-node.active { background: var(--primary); color: #fff !important; border-color: var(--primary); box-shadow: 0 8px 15px rgba(255, 64, 129, 0.2); }
        .page-node.disabled { opacity: 0.5; cursor: not-allowed; background: #f8fafc; }
        .page-nav { padding: 0 20px; font-size: 0.8rem; text-transform: uppercase; }

        /* Toast Message */
        #toastBox {
            position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%);
            background: #1e293b; color: #fff; padding: 15px 35px; border-radius: 50px;
            z-index: 9999; display: none; box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
    </style>

    <script>
        function showToast() {
            var toast = document.getElementById("toastBox");
            toast.style.display = "block";
            toast.innerHTML = "<i class='fa-solid fa-cart-plus' style='color:#4ade80;'></i> Đã thêm vào giỏ hàng thành công!";
            setTimeout(function () { toast.style.display = "none"; }, 3000);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <div class="sach-container">
        <div class="page-header">
            <h2 id="hTitle" runat="server" class="page-title">DANH MỤC <span>SÁCH</span></h2>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" Style="text-align: center; padding: 120px 0;">
            <i class="fa-solid fa-box-open" style="font-size: 60px; color: #dee2e6; margin-bottom: 20px;"></i>
            <h4 style="color: #adb5bd;">Rất tiếc, chúng tôi không tìm thấy sách bạn cần.</h4>
            <a href="danhsach.aspx" class="btn btn-outline-primary mt-3">Xem tất cả sách</a>
        </asp:Panel>

        <asp:UpdatePanel ID="upList" runat="server">
            <ContentTemplate>
                <div class="books-grid">
                    <asp:Repeater ID="rptSach" runat="server" OnItemCommand="rptSach_ItemCommand">
                        <ItemTemplate>
                            <div class="book-card" onclick="window.location.href='chitiet.aspx?MaSach=<%# Eval("MaSach") %>'">
                                <div class="img-wrapper">
                                    <div class="tags-overlay">
                                        <%# RenderTags(Eval("Tags")) %>
                                    </div>
                                    <img src='<%# ResolveUrl("~/Images/") + (Eval("AnhBia") != DBNull.Value ? Eval("AnhBia") : "no-image.jpg") %>' alt='<%# Eval("TenSach") %>' />
                                </div>
                                
                                <div class="book-info">
                                    <div class="book-name" title='<%# Eval("TenSach") %>'><%# Eval("TenSach") %></div>
                                    <div class="book-price"><%# string.Format("{0:#,##0} đ", Eval("Dongia")) %></div>
                                </div>
                                
                                <asp:LinkButton ID="btnThem" runat="server" CommandName="ThemGioHang" 
                                    CommandArgument='<%# Eval("MaSach") %>' CssClass="btn-buy" 
                                    OnClientClick="event.stopPropagation();">
                                    <i class="fa-solid fa-bag-shopping" style="margin-right:10px;"></i> MUA NGAY
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class="pagination">
            <asp:HyperLink ID="lnkFirst" runat="server" CssClass="page-node page-nav">Đầu</asp:HyperLink>
            
            <asp:Repeater ID="rptPagination" runat="server">
                <ItemTemplate>
                    <asp:HyperLink ID="lnkPageNum" runat="server"
                        Text='<%# Container.DataItem %>'
                        NavigateUrl='<%# GetPageUrl(Container.DataItem) %>'
                        CssClass='<%# Convert.ToInt32(Container.DataItem) == CurrentPage ? "page-node active" : "page-node" %>'>
                    </asp:HyperLink>
                </ItemTemplate>
            </asp:Repeater>
            
            <asp:HyperLink ID="lnkLast" runat="server" CssClass="page-node page-nav">Cuối</asp:HyperLink>
        </div>
    </div>
</asp:Content>