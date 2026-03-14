<%@ Page Title="CHI TIẾT SÁCH" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="chitiet.aspx.cs" Inherits="lab05.chitiet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .chi-tiet-container { max-width: 1100px; margin: 0 auto; padding: 40px 20px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .section-title { color: #ff4081; font-size: 20px; font-weight: 800; margin: 30px 0 20px 0; padding-bottom: 10px; border-bottom: 2px solid #ff4081; text-transform: uppercase; display: flex; align-items: center; gap: 10px; }
        
        /* FIX LAYOUT CHI TIẾT SÁCH - ẢNH TO KHỚP GIAO DIỆN [cite: 2026-03-14] */
        .book-detail { display: flex; gap: 40px; margin-bottom: 50px; background: white; padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); align-items: flex-start; }
        .book-image-wrapper { position: relative; flex-shrink: 0; border-radius: 15px; overflow: hidden; box-shadow: 0 5px 20px rgba(0,0,0,0.1); background: #f8fafc; width: 300px; height: 420px; display: flex; align-items: center; justify-content: center; }
        .book-image-large { width: 100%; height: 100%; object-fit: contain; display: block; transition: 0.5s; padding: 10px; }
        .book-image-wrapper:hover .book-image-large { transform: scale(1.05); }

        /* FIX TAGS: HIỂN THỊ ĐẸP ĐÈ LÊN ẢNH [cite: 2026-03-14] */
        .tags-overlay { position: absolute; top: 15px; left: 15px; display: flex; flex-wrap: wrap; gap: 5px; z-index: 5; }
        .tag-badge { background: rgba(255, 255, 255, 0.95); color: #ff4081; padding: 5px 12px; border-radius: 8px; font-size: 10px; font-weight: 800; text-transform: uppercase; border-left: 4px solid #ff4081; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }

        .book-name { color: #333; font-size: 32px; font-weight: 800; margin-bottom: 10px; }
        .book-price-large { color: #ff4081; font-size: 30px; font-weight: 800; margin: 20px 0; }
        .book-description { line-height: 1.8; color: #555; background: #fdf2f8; padding: 20px; border-radius: 12px; border-left: 5px solid #ff4081; }
        
        .btn-add-cart-large { background: linear-gradient(135deg, #ff4081, #ff80ab); color: white !important; border: none; padding: 15px 40px; border-radius: 30px; font-weight: 800; text-decoration: none; cursor: pointer; transition: 0.3s; }

        /* FIX LAYOUT GỢI Ý - 5 CỘT [cite: 2026-03-14] */
        .related-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 18px; margin-bottom: 50px; min-height: 200px; }
        .related-item { background: white; padding: 12px; border-radius: 15px; border: 1px solid #f1f1f1; transition: 0.3s; text-decoration: none; display: flex; flex-direction: column; }
        .related-item:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.05); border-color: #ff4081; }
        .related-img-box { height: 180px; display: flex; align-items: center; justify-content: center; background: #fcfcfc; border-radius: 10px; margin-bottom: 10px; overflow: hidden; }
        .related-img { max-width: 90%; max-height: 90%; object-fit: contain; }
        .related-title { font-weight: 700; color: #1e293b; font-size: 13px; height: 2.6rem; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; line-height: 1.3; }
        .related-price { color: #ff4081; font-weight: 800; font-size: 14px; margin-top: auto; padding-top: 5px; }

        /* COMMENT STYLES GỐC */
        .comment-item { position: relative; padding: 25px 0; border-bottom: 1px solid #f1f1f1; }
        .comment-options { position: absolute; top: 20px; right: 0; }
        .dot-btn { background: none; border: none; color: #ccc; cursor: pointer; padding: 5px 10px; font-size: 18px; transition: 0.3s; }
        .dot-btn:hover { color: #ff4081; }
        .options-menu { display: none; position: absolute; right: 0; top: 35px; background: white; box-shadow: 0 5px 15px rgba(0,0,0,0.1); border-radius: 10px; z-index: 100; min-width: 120px; overflow: hidden; border: 1px solid #eee; }
        .comment-options:hover .options-menu { display: block; }
        .menu-item { display: flex; align-items: center; gap: 8px; padding: 10px 15px; color: #555; text-decoration: none; font-size: 13px; font-weight: 600; transition: 0.2s; width: 100%; border: none; background: none; text-align: left; cursor: pointer; }
        .menu-item:hover { background: #fff0f6; color: #ff4081; }

        .user-info-box { display: flex; align-items: center; gap: 15px; margin-bottom: 10px; }
        .comment-avatar { width: 45px; height: 45px; border-radius: 50%; object-fit: cover; border: 2px solid #fdf2f8; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

        .edit-mode-box { background: #f8fafc; padding: 20px; border-radius: 15px; border: 1px solid #e2e8f0; margin-top: 10px; }
        .btn-gui-bl { background: #333; color: white; border: none; padding: 12px 35px; border-radius: 10px; font-weight: 700; cursor: pointer; margin-top: 15px; transition: 0.3s; }
        .btn-gui-bl:hover { background: #ff4081; }
        
        body { cursor: url('https://cur.cursors-4u.net/games/gam-4/gam372.cur'), auto !important; }

        #toastBox { position: fixed; bottom: -100px; left: 50%; transform: translateX(-50%); background: rgba(30, 41, 59, 0.9); backdrop-filter: blur(10px); color: #fff; padding: 18px 40px; border-radius: 20px; z-index: 10000; box-shadow: 0 20px 50px rgba(0,0,0,0.3); font-weight: 600; display: flex; align-items: center; gap: 12px; border: 1px solid rgba(255,255,255,0.1); transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55); }
        #toastBox.active { bottom: 40px; }
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; z-index: 11000; opacity: 0; transition: 0.3s; }
        .modal-overlay.active { display: flex; opacity: 1; }
        .modal-content { background: white; padding: 35px; border-radius: 24px; max-width: 400px; width: 90%; text-align: center; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); transform: scale(0.8); transition: 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); }
        .modal-overlay.active .modal-content { transform: scale(1); }
        /* --- POLICY BOX STYLE [cite: 2026-03-14] --- */
.policy-container {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
    margin-top: 30px;
    padding-top: 25px;
    border-top: 1px dashed #eee;
}
.policy-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 15px;
    background: #fffcfd;
    border-radius: 12px;
    border: 1px solid #ffeff7;
    transition: 0.3s;
}
.policy-item:hover {
    border-color: #ff4081;
    background: white;
    box-shadow: 0 5px 15px rgba(255, 64, 129, 0.08);
}
.policy-icon {
    width: 40px;
    height: 40px;
    background: #ff4081;
    color: white;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    flex-shrink: 0;
}
.policy-text b {
    display: block;
    font-size: 13.5px;
    color: #1e293b;
    margin-bottom: 2px;
}
.policy-text span {
    font-size: 12px;
    color: #64748b;
    line-height: 1.4;
}
    </style>

    <script>
        function showToast(message) {
            var toast = document.getElementById("toastBox");
            toast.innerHTML = "<i class='fa-solid fa-circle-check' style='color:#4ade80;'></i> " + message;
            toast.classList.add("active");
            setTimeout(function () { toast.classList.remove("active"); }, 3000);
        }
        function openDeleteModal(maBL) {
            document.getElementById('<%= hfDeleteID.ClientID %>').value = maBL;
            document.getElementById('deleteModal').classList.add('active');
        }
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <div id="deleteModal" class="modal-overlay">
        <div class="modal-content">
            <div style="font-size:50px; color:#e11d48; margin-bottom:20px;"><i class="fa-solid fa-trash-can"></i></div>
            <div style="font-size: 1.2rem; font-weight: 800; color: #1e293b; margin-bottom: 10px;">Xác nhận xóa?</div>
            <div style="color: #64748b; font-size: 14px; line-height: 1.6; margin-bottom: 30px;">Bạn có chắc muốn xóa nhận xét này không?</div>
            <div style="display: flex; gap: 12px; justify-content: center;">
                <button type="button" class="btn-gui-bl" style="background:#f1f5f9; color:#475569;" onclick="closeDeleteModal()">QUAY LẠI</button>
                <asp:Button ID="btnConfirmDelete" runat="server" Text="VẪN XÓA" CssClass="btn-gui-bl" style="background:#e11d48; color:white;" OnClick="btnConfirmDelete_Click" />
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hfDeleteID" runat="server" />

    <div class="chi-tiet-container">
        <h2 class="section-title"><i class="fa-solid fa-circle-info"></i> Thông tin chi tiết</h2>
        <asp:FormView ID="FormViewChiTiet" runat="server" DataSourceID="SqlDataSourceChiTiet" Width="100%">
            <ItemTemplate>
                <div class="book-detail">
                    <div class="book-image-wrapper">
                        <div class="tags-overlay"><%# RenderTags(Eval("Tags")) %></div>
                        <asp:Image ID="imgSach" runat="server" ImageUrl='<%# "~/Images/" + Eval("AnhBia") %>' CssClass="book-image-large" />
                    </div>
                    <div class="book-info">
                        <h1 class="book-name"><%# Eval("TenSach") %></h1>
                        <div class="book-meta">
                            <span><i class="fa-solid fa-bookmark"></i> <strong>Chủ đề:</strong> <%# Eval("Tenchude") %></span>
                            <span style="margin: 0 15px;">|</span>
                            <span><i class="fa-solid fa-building"></i> <strong>NXB:</strong> <%# Eval("TenNXB") %></span>
                        </div>
                        <div class="book-price-large"><%# Eval("Dongia", "{0:#,##0} VNĐ") %></div>
                        <div class="book-description"><strong>Mô tả:</strong><br /><%# Eval("Mota") %></div>
                        <asp:LinkButton ID="btnThemGioHang" runat="server" CssClass="btn-add-cart-large" 
                            CommandArgument='<%# Eval("MaSach") %>' OnClick="btnThemGioHang_Click" style="margin-top:20px;">
                            <i class="fa-solid fa-cart-plus"></i> THÊM VÀO GIỎ HÀNG
                        </asp:LinkButton>
                        <div class="policy-container">
    <div class="policy-item">
        <div class="policy-icon"><i class="fa-solid fa-shield-heart"></i></div>
        <div class="policy-text">
            <b>Sách Chính Hãng</b>
            <span>Hoàn tiền 200% nếu phát hiện sách giả.</span>
        </div>
    </div>
    
    <div class="policy-item">
        <div class="policy-icon"><i class="fa-solid fa-truck-fast"></i></div>
        <div class="policy-text">
            <b>Giao Hàng Siêu Tốc</b>
            <span>Nội thành nhận hàng trong 2h - 4h.</span>
        </div>
    </div>
    
    <div class="policy-item">
        <div class="policy-icon"><i class="fa-solid fa-rotate-left"></i></div>
        <div class="policy-text">
            <b>Đổi Trả Dễ Dàng</b>
            <span>Đổi mới trong 7 ngày nếu có lỗi in ấn.</span>
        </div>
    </div>
    
    <div class="policy-item">
        <div class="policy-icon"><i class="fa-solid fa-box-open"></i></div>
        <div class="policy-text">
            <b>Kiểm Hàng Trước</b>
            <span>Được xem hàng trước khi thanh toán (COD).</span>
        </div>
    </div>
</div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:FormView>

        <%-- PHẦN GỢI Ý - FIX TRỐNG TRƠN [cite: 2026-03-14] --%>
        <h2 class="section-title"><i class="fa-solid fa-fire-flame-curved"></i> Đang nổi bật cùng chủ đề</h2>
        <asp:Panel ID="pnlNoRelated" runat="server" Visible="false" style="text-align:center; padding:30px; color:#94a3b8;">Chưa có gợi ý khác cùng chủ đề này.</asp:Panel>
        <div class="related-grid">
            <asp:Repeater ID="rptRelated" runat="server">
                <ItemTemplate>
                    <a href='chitiet.aspx?MaSach=<%# Eval("MaSach") %>' class="related-item">
                        <div class="related-img-box">
                            <img src='<%# ResolveUrl("~/Images/") + Eval("AnhBia") %>' class="related-img" />
                        </div>
                        <div class="related-title"><%# Eval("TenSach") %></div>
                        <div class="related-price"><%# Eval("Dongia", "{0:#,##0}đ") %></div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <h2 class="section-title"><i class="fa-solid fa-comments"></i> Đánh giá từ khách hàng</h2>
        <div class="comment-section">
            <asp:Panel ID="pnlCommentForm" runat="server">
                <label style="font-weight: 700;">Bạn cảm thấy quyển sách này thế nào?<br />
                <asp:DropDownList ID="ddlStars" runat="server" CssClass="ddl-stars" Width="320px" style="padding:10px; border-radius:8px; margin:10px 0;">
                    <asp:ListItem Value="5">★★★★★ (Tuyệt vời)</asp:ListItem>
                    <asp:ListItem Value="4">★★★★ (Rất tốt)</asp:ListItem>
                    <asp:ListItem Value="3">★★★ (Bình thường)</asp:ListItem>
                    <asp:ListItem Value="2">★★ (Tạm được)</asp:ListItem>
                    <asp:ListItem Value="1">★ (Kém)</asp:ListItem>
                </asp:DropDownList>
                </label><br />
                <asp:TextBox ID="txtNoiDungBL" runat="server" placeholder="Nhập nhận xét..." Rows="3" TextMode="MultiLine" Width="100%" MaxLength="500" style="padding:15px; border-radius:10px; border:1px solid #ddd;"></asp:TextBox>
                <br />
                <asp:Button ID="btnGuiBL" runat="server" CssClass="btn-gui-bl" OnClick="btnGuiBL_Click" Text="ĐĂNG NHẬN XÉT" />
            </asp:Panel>

            <asp:Panel ID="pnlLoginReq" runat="server" Visible="false" Style="text-align:center; padding:20px;">
                Vui lòng <a href="DangNhap.aspx" style="color:#ff4081; font-weight:800;">Đăng nhập</a> để đánh giá.
            </asp:Panel>

            <div class="comment-list mt-4">
                <asp:UpdatePanel ID="upComments" runat="server">
                    <ContentTemplate>
                        <asp:Repeater ID="rptComments" runat="server" DataSourceID="SqlDataSourceComments" OnItemCommand="rptComments_ItemCommand">
                            <ItemTemplate>
                                <div class="comment-item">
                                    <asp:HiddenField ID="hfMaBL" runat="server" Value='<%# Eval("MaBL") %>' />
                                    <asp:Panel ID="pnlView" runat="server">
                                        <div class="comment-options" runat="server" visible='<%# IsMyComment(Eval("MaKH")) %>'>
                                            <button type="button" class="dot-btn"><i class="fa-solid fa-ellipsis-vertical"></i></button>
                                            <div class="options-menu">
                                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditMode" CssClass="menu-item"><i class="fa-solid fa-pen-to-square"></i> Chỉnh sửa</asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CssClass="menu-item" OnClientClick='<%# "openDeleteModal(" + Eval("MaBL") + "); return false;" %>'><i class="fa-solid fa-trash-can"></i> Xóa</asp:LinkButton>
                                            </div>
                                        </div>
                                        <div class="user-info-box">
                                            <img src='<%# ResolveUrl("~/Images/") + (Eval("AnhKH") != DBNull.Value && !string.IsNullOrEmpty(Eval("AnhKH").ToString()) ? Eval("AnhKH") : "no-avatar.jpg") %>' 
                                                 class="comment-avatar" onerror="this.src='../Images/no-avatar.jpg'" />
                                            <div>
                                                <div style="font-weight:800; color:#1e293b;"><%# Eval("HoTenKH") %></div>
                                                <div style="font-size:11px; color:#bbb;"><%# Eval("NgayBL", "{0:dd/MM/yyyy HH:mm}") %></div>
                                            </div>
                                        </div>
                                        <div style="color:#ffc107; margin: 8px 0;"><%# RenderStars(Eval("DanhGia")) %></div>
                                        <div style="color:#666; padding-left: 60px;"><%# Eval("NoiDung") %></div>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlEdit" runat="server" Visible="false" CssClass="edit-mode-box">
                                        <asp:TextBox ID="txtEditContent" runat="server" TextMode="MultiLine" Rows="3" Width="100%" Text='<%# Eval("NoiDung") %>' style="padding:10px; border-radius:8px;"></asp:TextBox>
                                        <div style="margin-top:10px; display:flex; gap:10px;">
                                            <asp:LinkButton ID="btnUpdate" runat="server" CommandName="UpdateComm" CssClass="btn-gui-bl" Style="padding:8px 20px; font-size:13px;">Lưu</asp:LinkButton>
                                            <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelEdit" CssClass="btn-gui-bl" Style="background:#94a3b8; padding:8px 20px; font-size:13px;">Hủy</asp:LinkButton>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <asp:SqlDataSource ID="SqlDataSourceChiTiet" runat="server" ConnectionString="<%$ ConnectionStrings:BookStoreDB %>"
            SelectCommand="SELECT S.*, C.Tenchude, N.TenNXB FROM Sach S JOIN ChuDe C ON S.MaCD = C.MaCD JOIN NhaXuatBan N ON S.MaNXB = N.MaNXB WHERE S.MaSach = @MaSach">
            <SelectParameters><asp:QueryStringParameter Name="MaSach" QueryStringField="MaSach" Type="Int32" /></SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSourceComments" runat="server" ConnectionString="<%$ ConnectionStrings:BookStoreDB %>"
            SelectCommand="SELECT C.*, K.HoTenKH, K.AnhKH FROM Comment C JOIN KhachHang K ON C.MaKH = K.MaKH WHERE C.MaSach = @MaSach ORDER BY C.NgayBL DESC">
            <SelectParameters><asp:QueryStringParameter Name="MaSach" QueryStringField="MaSach" Type="Int32" /></SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>