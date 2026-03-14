<%@ Page Title="Quản lý Danh mục" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="QLDanhMuc.aspx.cs" Inherits="lab05.Seller.QLDanhMuc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary: #6366f1; --primary-dark: #4f46e5; --bg-body: #f8fafc; }
        body { font-size: 14.5px; background-color: var(--bg-body); }

        /* HỆ THỐNG TAB [cite: 2026-03-14] */
        .tab-container { max-width: 1100px; margin: 30px auto; }
        .tab-header { display: flex; gap: 10px; margin-bottom: 25px; background: #e2e8f0; padding: 6px; border-radius: 16px; width: fit-content; }
        .tab-btn { padding: 12px 30px; border-radius: 12px; border: none; background: transparent; color: #64748b; font-weight: 800; cursor: pointer; transition: 0.3s; }
        .tab-btn.active { background: white; color: var(--primary); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        
        .tab-content { display: none; animation: fadeIn 0.4s ease; }
        .tab-content.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* CARD STYLE */
        .admin-card { background: white; padding: 35px; border-radius: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); border: 1px solid #f1f5f9; }
        .header-flex { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header-title { font-weight: 900; color: #1e293b; text-transform: uppercase; border-left: 6px solid var(--primary); padding-left: 15px; margin: 0; font-size: 1.3rem; }
        
        .btn-add-new { background: var(--primary); color: white; border: none; padding: 14px 25px; border-radius: 12px; font-weight: 800; cursor: pointer; transition: 0.3s; display: flex; align-items: center; gap: 8px; box-shadow: 0 8px 20px rgba(99, 102, 241, 0.2); }
        .btn-add-new:hover { transform: translateY(-3px); background: var(--primary-dark); }

        /* GRIDVIEW STYLE */
        .gv-admin { width: 100%; border-collapse: collapse; }
        .gv-admin th { background: #f8fafc; color: #64748b; font-size: 11px; font-weight: 800; text-transform: uppercase; padding: 18px; text-align: left; border-bottom: 2px solid #f1f5f9; }
        .gv-admin td { padding: 18px; border-bottom: 1px solid #f1f5f9; color: #334155; }
        .gv-admin tr:hover { background-color: #fcfdff; }

        .badge-indigo { background: #e0e7ff; color: #4338ca; padding: 6px 12px; border-radius: 8px; font-size: 11px; font-weight: 800; }

        /* MODAL POPUP [cite: 2026-03-14] */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; z-index: 1000; transition: 0.3s; }
        .modal-overlay.active { display: flex; }
        .modal-content { background: white; padding: 40px; border-radius: 28px; width: 480px; box-shadow: 0 25px 50px rgba(0,0,0,0.2); transform: scale(0.9); transition: 0.3s; }
        .modal-overlay.active .modal-content { transform: scale(1); }
        
        .form-group { margin-bottom: 22px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 700; color: #475569; font-size: 12px; text-transform: uppercase; }
        .form-control { width: 100%; padding: 13px 16px; border: 2px solid #f1f5f9; border-radius: 12px; font-weight: 600; transition: 0.3s; }
        .form-control:focus { border-color: var(--primary); outline: none; background: #fff; }
        
        .btn-action { padding: 12px 18px; border-radius: 10px; font-weight: 800; cursor: pointer; border: none; transition: 0.2s; font-size: 13px; }
        .btn-edit { background: #ecfdf5; color: #10b981; margin-right: 5px; }
        .btn-delete { background: #fff1f2; color: #e11d48; }
    </style>

    <script>
        function switchTab(tabId, btn) {
            // Chuyển Tab
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
            
            // Đổi style nút
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            // Lưu trạng thái vào HiddenField để không bị reset khi PostBack
            document.getElementById('<%= hfActiveTab.ClientID %>').value = tabId;
        }

        function openModal(id) { document.getElementById(id).classList.add('active'); }
        function closeModal(id) { document.getElementById(id).classList.remove('active'); }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hfActiveTab" runat="server" Value="tabChuDe" />

    <div class="tab-container">
        <div class="tab-header">
            <button type="button" class="tab-btn active" onclick="switchTab('tabChuDe', this)">CHỦ ĐỀ SÁCH</button>
            <button type="button" class="tab-btn" onclick="switchTab('tabNhaXuatBan', this)">NHÀ XUẤT BẢN</button>
        </div>

        <%-- ================= TAB 1: CHỦ ĐỀ ================= --%>
        <div id="tabChuDe" class="tab-content active">
            <div class="admin-card">
                <div class="header-flex">
                    <h2 class="header-title">Quản lý <span>Danh mục / Chủ đề</span></h2>
                    <button type="button" class="btn-add-new" onclick="openModal('modalCD')">
                        <i class="fa-solid fa-folder-plus"></i> THÊM MỚI
                    </button>
                </div>
                <asp:GridView ID="gvChuDe" runat="server" AutoGenerateColumns="False" CssClass="gv-admin" GridLines="None" DataKeyNames="MaCD" OnRowCommand="gvChuDe_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="MaCD" HeaderText="ID" ItemStyle-Width="60px" />
                        <asp:BoundField DataField="Tenchude" HeaderText="Tên Chủ Đề" ItemStyle-Font-Bold="true" />
                        <asp:TemplateField HeaderText="Nhóm Phân Loại">
                            <ItemTemplate><span class="badge-indigo"><%# Eval("TenLoai") %></span></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Hành động">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCD" CommandArgument='<%# Eval("MaCD") %>' CssClass="btn-action btn-edit"><i class="fa-solid fa-pen"></i></asp:LinkButton>
                                <asp:LinkButton ID="btnDel" runat="server" CommandName="DeleteCD" CommandArgument='<%# Eval("MaCD") %>' CssClass="btn-action btn-delete" OnClientClick="return confirm('Xóa chủ đề này sẽ ảnh hưởng đến sách liên quan. Đồng ý?')"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <%-- ================= TAB 2: NHÀ XUẤT BẢN ================= --%>
        <div id="tabNhaXuatBan" class="tab-content">
            <div class="admin-card">
                <div class="header-flex">
                    <h2 class="header-title">Quản lý <span>Nhà xuất bản / Thương hiệu</span></h2>
                    <button type="button" class="btn-add-new" onclick="openModal('modalNXB')">
                        <i class="fa-solid fa-building-circle-plus"></i> THÊM MỚI
                    </button>
                </div>
                <asp:GridView ID="gvNXB" runat="server" AutoGenerateColumns="False" CssClass="gv-admin" GridLines="None" DataKeyNames="MaNXB" OnRowCommand="gvNXB_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="MaNXB" HeaderText="ID" ItemStyle-Width="60px" />
                        <asp:BoundField DataField="TenNXB" HeaderText="Tên NXB" ItemStyle-Font-Bold="true" />
                        <asp:BoundField DataField="Diachi" HeaderText="Địa chỉ liên hệ" />
                        <asp:BoundField DataField="Dienthoai" HeaderText="Số điện thoại" />
                        <asp:TemplateField HeaderText="Hành động">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditNXB" CommandArgument='<%# Eval("MaNXB") %>' CssClass="btn-action btn-edit"><i class="fa-solid fa-pen-to-square"></i></asp:LinkButton>
                                <asp:LinkButton ID="btnDel" runat="server" CommandName="DeleteNXB" CommandArgument='<%# Eval("MaNXB") %>' CssClass="btn-action btn-delete" OnClientClick="return confirm('Xóa nhà xuất bản này?')"><i class="fa-solid fa-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <%-- MODAL CHỦ ĐỀ --%>
    <div id="modalCD" class="modal-overlay">
        <div class="modal-content">
            <h3 style="font-weight:900; color:var(--primary); margin-bottom:25px;">THÔNG TIN CHỦ ĐỀ</h3>
            <asp:HiddenField ID="hfMaCD" runat="server" />
            <div class="form-group">
                <label class="form-label">Tên chủ đề sách</label>
                <asp:TextBox ID="txtTenCD" runat="server" CssClass="form-control" placeholder="VD: Kinh tế chính trị..."></asp:TextBox>
            </div>
            <div class="form-group">
                <label class="form-label">Thuộc phân loại</label>
                <asp:DropDownList ID="ddlPhanLoai" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div style="display:flex; gap:12px; margin-top:35px;">
                <button type="button" class="btn-action" style="flex:1; background:#f1f5f9; color:#64748b;" onclick="closeModal('modalCD')">ĐÓNG</button>
                <asp:Button ID="btnSaveCD" runat="server" Text="LƯU DỮ LIỆU" CssClass="btn-action" style="flex:1; background:var(--primary); color:white;" OnClick="btnSaveCD_Click" />
            </div>
        </div>
    </div>

    <%-- MODAL NXB --%>
    <div id="modalNXB" class="modal-overlay">
        <div class="modal-content">
            <h3 style="font-weight:900; color:var(--primary); margin-bottom:25px;">THÔNG TIN NHÀ XUẤT BẢN</h3>
            <asp:HiddenField ID="hfMaNXB" runat="server" />
            <div class="form-group">
                <label class="form-label">Tên Nhà xuất bản</label>
                <asp:TextBox ID="txtTenNXB" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label class="form-label">Địa chỉ trụ sở</label>
                <asp:TextBox ID="txtDiaChiNXB" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label class="form-label">Điện thoại liên lạc</label>
                <asp:TextBox ID="txtSDTNXB" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div style="display:flex; gap:12px; margin-top:35px;">
                <button type="button" class="btn-action" style="flex:1; background:#f1f5f9; color:#64748b;" onclick="closeModal('modalNXB')">ĐÓNG</button>
                <asp:Button ID="btnSaveNXB" runat="server" Text="LƯU DỮ LIỆU" CssClass="btn-action" style="flex:1; background:var(--primary); color:white;" OnClick="btnSaveNXB_Click" />
            </div>
        </div>
    </div>

    <%-- SCRIPT GIỮ TRẠNG THÁI TAB SAU KHI POSTBACK --%>
    <script>
        window.onload = function() {
            var activeTab = document.getElementById('<%= hfActiveTab.ClientID %>').value;
            var btn = (activeTab === 'tabChuDe') ? document.querySelector('.tab-btn:first-child') : document.querySelector('.tab-btn:last-child');
            switchTab(activeTab, btn);
        };
    </script>
</asp:Content>