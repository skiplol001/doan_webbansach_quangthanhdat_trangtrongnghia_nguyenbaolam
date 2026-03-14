<%@ Page Title="Quản lý đánh giá" Language="C#" MasterPageFile="~/Seller/Seller.Master" AutoEventWireup="true" CodeBehind="QLDanhGia.aspx.cs" Inherits="lab05.Admin.QLDanhGia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --seller-primary: #ff4081; --star-gold: #f59e0b; --bg-main: #f8fafc; --indigo: #6366f1; }

        /* PHÓNG TO GIAO DIỆN 120% [cite: 2026-03-11] */
        body { font-size: 14.5px; background-color: var(--bg-main); } 
        .table-card { background: white; padding: 25px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.06); border: 1px solid #f1f5f9; }
        
        .comment-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .comment-header h2 { font-weight: 900; color: #1e293b; margin: 0; text-transform: uppercase; font-size: 1.45rem !important; display: flex; align-items: center; gap: 15px; }
        .comment-header h2 i { color: var(--seller-primary); }

        /* GridView Đánh giá */
        .gv-comments { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .gv-comments th { background: #fdf2f8; color: #64748b; font-size: 11px; font-weight: 800; text-transform: uppercase; padding: 18px 15px; border-bottom: 2px solid #ffeff7; text-align: left; }
        .gv-comments td { padding: 18px 15px; border-bottom: 1px solid #f1f5f9; font-size: 15.5px; vertical-align: middle; color: #334155; }
        .gv-comments tr:hover { background-color: #fcfdff; }

        /* STYLE AVATAR NGƯỜI DÙNG [cite: 2026-03-11] */
        .admin-user-info { display: flex; align-items: center; gap: 12px; }
        .admin-comment-avatar { width: 42px; height: 42px; border-radius: 50%; object-fit: cover; border: 2px solid #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }

        .star-rating { color: var(--star-gold); font-size: 14px; letter-spacing: 2px; }
        .book-link-title { color: #1e293b; font-weight: 800; text-decoration: none; }
        .comment-text { color: #64748b; font-style: italic; line-height: 1.6; max-width: 400px; }

        /* MỚI: STYLE NÚT CHI TIẾT TRANG KHÁCH [cite: 2026-03-14] */
        .btn-view-detail { background: #eef2ff; color: var(--indigo); padding: 8px 15px; border-radius: 8px; font-size: 11px; font-weight: 800; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: 0.3s; border: 1px solid #e0e7ff; }
        .btn-view-detail:hover { background: var(--indigo); color: white; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2); }

        .btn-delete-action { background: #fff1f2; color: #e11d48; padding: 10px 15px; border-radius: 10px; font-size: 11px; font-weight: 800; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; transition: 0.3s; cursor: pointer; border:none; }
        .btn-delete-action:hover { background: #e11d48; color: white; transform: translateY(-3px); }

        /* PHÂN TRANG SLIDING WINDOW */
        .pagination-wrapper { display: flex; justify-content: center; gap: 8px; margin-top: 40px; align-items: center; }
        .page-node { text-decoration: none; padding: 10px 20px; border-radius: 12px; background: white; color: #64748b; font-weight: 800; border: 2px solid #e2e8f0; font-size: 14px; min-width: 50px; text-align: center; transition: 0.3s; }
        .page-node:hover { border-color: var(--seller-primary); color: var(--seller-primary); background: #fff9fc; }
        .page-node.active { background: var(--seller-primary); color: white; border-color: var(--seller-primary); box-shadow: 0 8px 20px rgba(255, 64, 129, 0.3); }
        .page-nav { color: #cbd5e1; font-size: 1.5rem; padding: 0 12px; transition: 0.3s; text-decoration: none; }
        
        #toastBox { position: fixed; bottom: -100px; left: 50%; transform: translateX(-50%); background: rgba(15, 23, 42, 0.95); backdrop-filter: blur(10px); color: #fff; padding: 20px 45px; border-radius: 50px; z-index: 10000; display: flex; align-items: center; gap: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); transition: 0.5s; font-weight: 600; }
        #toastBox.active { bottom: 40px; }
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.5); backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; z-index: 11000; opacity: 0; transition: 0.3s; }
        .modal-overlay.active { display: flex; opacity: 1; }
        .modal-content { background: white; padding: 45px; border-radius: 28px; max-width: 450px; width: 90%; text-align: center; transform: scale(0.9); transition: 0.3s; }
        body { cursor: url('https://cur.cursors-4u.net/games/gam-4/gam372.cur'), auto !important; }
    </style>

    <script>
        function showToast(msg) {
            var t = document.getElementById("toastBox");
            t.innerHTML = "<i class='fa-solid fa-circle-check' style='color:#10b981; font-size:20px;'></i> " + msg;
            t.classList.add("active");
            setTimeout(() => t.classList.remove("active"), 3500);
        }
        function openDeleteModal(id) {
            document.getElementById('<%= hfDeleteID.ClientID %>').value = id;
            document.getElementById('deleteModal').classList.add('active');
        }
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <%-- MODAL XÁC NHẬN XÓA --%>
    <div id="deleteModal" class="modal-overlay">
        <div class="modal-content">
            <div style="font-size:50px; color:#e11d48; margin-bottom:20px;"><i class="fa-solid fa-triangle-exclamation"></i></div>
            <h3 style="font-weight:900; margin-bottom:10px;">Xác nhận xóa?</h3>
            <p style="color:#64748b; font-size:16px; margin-bottom:35px; line-height:1.6;">Đánh giá này sẽ bị gỡ bỏ vĩnh viễn khỏi cửa hàng và không thể khôi phục.</p>
            <div style="display:flex; gap:15px;">
                <button type="button" style="flex:1; padding:15px; border-radius:12px; border:none; background:#f1f5f9; color:#475569; font-weight:700;" onclick="closeDeleteModal()">QUAY LẠI</button>
                <asp:Button ID="btnConfirmDelete" runat="server" Text="XÓA VĨNH VIỄN" style="flex:1; padding:15px; border-radius:12px; border:none; background:#e11d48; color:white; font-weight:900;" OnClick="btnConfirmDelete_Click" />
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hfDeleteID" runat="server" />

    <div class="comment-header">
        <h2><i class="fa-solid fa-star-half-stroke"></i> QUẢN TRỊ <span>BÌNH LUẬN & ĐÁNH GIÁ</span></h2>
    </div>

    <div class="table-card">
        <asp:UpdatePanel ID="upComments" runat="server">
            <ContentTemplate>
                
                <asp:GridView ID="gvComments" runat="server" AutoGenerateColumns="False" 
                    CssClass="gv-comments" GridLines="None" DataKeyNames="MaBL">
                    <Columns>
                        <asp:TemplateField HeaderText="Sách đánh giá">
                            <ItemTemplate>
                                <div class="book-link-title"><%# Eval("TenSach") %></div>
                                <div style="font-size:11px; color:#94a3b8; margin-top:4px;">Mã sách: #<%# Eval("MaSach") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Người gửi">
                            <ItemTemplate>
                                <div class="admin-user-info">
                                    <img src='<%# ResolveUrl("~/Images/") + (Eval("AnhKH") != DBNull.Value && !string.IsNullOrEmpty(Eval("AnhKH").ToString()) ? Eval("AnhKH") : "no-avatar.jpg") %>' 
                                         class="admin-comment-avatar" onerror="this.src='../Images/no-avatar.jpg'" />
                                    <div>
                                        <div style="font-weight:800; color:#1e293b;"><%# Eval("HoTenKH") %></div>
                                        <div style="font-size:11px; color:#94a3b8;"><%# Eval("NgayBL", "{0:dd/MM/yyyy HH:mm}") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Đánh giá">
                            <ItemTemplate>
                                <div class="star-rating"><%# RenderStars(Eval("DanhGia")) %></div>
                                <div style="font-size:10px; font-weight:900; color:#cbd5e1; margin-top:3px;">RATING: <%# Eval("DanhGia") %>/5</div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Nội dung">
                            <ItemTemplate>
                                <div class="comment-text">"<%# Eval("NoiDung") %>"</div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- MỚI: CỘT CHI TIẾT TRANG KHÁCH [cite: 2026-03-14] --%>
                        <asp:TemplateField HeaderText="Xem trang">
                            <ItemTemplate>
                                <a href='<%# "../khach/chitiet.aspx?MaSach=" + Eval("MaSach") %>' target="_blank" class="btn-view-detail">
                                    <i class="fa-solid fa-up-right-from-square"></i> CHI TIẾT
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Hành động">
                            <ItemTemplate>
                                <button type="button" class="btn-delete-action" onclick='<%# "openDeleteModal(" + Eval("MaBL") + ")" %>'>
                                    <i class="fa-solid fa-trash-can"></i> XÓA
                                </button>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="text-align:center; padding:60px; color:#94a3b8;">
                            <i class="fa-solid fa-comment-slash" style="font-size:4rem; margin-bottom:20px; display:block;"></i>
                            Chưa có khách hàng nào đánh giá.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>

                <%-- PHÂN TRANG --%>
                <div class="pagination-wrapper">
                    <asp:HyperLink ID="lnkFirst" runat="server" CssClass="page-nav"><i class="fa-solid fa-angles-left"></i></asp:HyperLink>
                    <asp:HyperLink ID="lnkPrev" runat="server" CssClass="page-nav"><i class="fa-solid fa-chevron-left"></i></asp:HyperLink>
                    
                    <asp:Repeater ID="rptPaging" runat="server">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkPage" runat="server" 
                                NavigateUrl='<%# GetPageUrl(Eval("PageIndex")) %>'
                                Text='<%# Eval("PageText") %>'
                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "page-node active" : "page-node" %>'>
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:HyperLink ID="lnkNext" runat="server" CssClass="page-nav"><i class="fa-solid fa-chevron-right"></i></asp:HyperLink>
                    <asp:HyperLink ID="lnkLast" runat="server" CssClass="page-nav"><i class="fa-solid fa-angles-right"></i></asp:HyperLink>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>