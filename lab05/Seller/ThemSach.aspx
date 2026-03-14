<%@ Page Title="Thêm Sách Mới" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="ThemSach.aspx.cs" Inherits="lab05.Seller.ThemSach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary: #6366f1; --primary-dark: #4f46e5; --bg-body: #f8fafc; }

        body { font-size: 14.5px; background-color: var(--bg-body); }
        .form-container { background: white; padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.06); max-width: 900px; margin: 30px auto; border: 1px solid #f1f5f9; }
        
        .header-title { font-weight: 900; color: #1e293b; margin-bottom: 30px; text-transform: uppercase; font-size: 1.5rem; border-left: 6px solid var(--primary); padding-left: 15px; }
        
        .form-group { margin-bottom: 25px; }
        .form-label { display: block; margin-bottom: 10px; font-weight: 700; color: #475569; font-size: 13px; text-transform: uppercase; }
        
        .form-control { width: 100%; padding: 12px 18px; border: 2px solid #e2e8f0; border-radius: 12px; font-size: 15px; transition: 0.3s; box-sizing: border-box; }
        .form-control:focus { border-color: var(--primary); outline: none; box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1); }
        
        .grid-row { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }

        /* STYLE CHO NÚT THÊM NHANH (+) [cite: 2026-03-14] */
        .input-group-flex { display: flex; gap: 10px; }
        .btn-quick-add { background: #f1f5f9; color: var(--primary); border: 2px solid #e2e8f0; border-radius: 12px; width: 48px; height: 48px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 20px; transition: 0.3s; flex-shrink: 0; }
        .btn-quick-add:hover { background: var(--primary); color: white; border-color: var(--primary); transform: rotate(90deg); }

        .btn-save { background: var(--primary); color: white; border: none; padding: 18px; border-radius: 15px; cursor: pointer; font-weight: 900; width: 100%; font-size: 16px; text-transform: uppercase; letter-spacing: 1px; transition: 0.3s; margin-top: 10px; box-shadow: 0 10px 20px rgba(99, 102, 241, 0.2); }
        .btn-save:hover { transform: translateY(-3px); filter: brightness(1.1); box-shadow: 0 15px 30px rgba(99, 102, 241, 0.3); }
        
        .error-msg { color: #ef4444; font-size: 13px; margin-top: 8px; font-weight: 600; display: block; }

        /* --- STYLE MODAL [cite: 2026-03-14] --- */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; z-index: 1000; opacity: 0; transition: 0.3s; }
        .modal-overlay.active { display: flex; opacity: 1; }
        .modal-content { background: white; padding: 35px; border-radius: 24px; width: 90%; max-width: 500px; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); transform: scale(0.9); transition: 0.3s; }
        .modal-overlay.active .modal-content { transform: scale(1); }
        .modal-header { font-weight: 900; font-size: 1.2rem; color: #1e293b; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .modal-footer { display: flex; gap: 12px; margin-top: 25px; }
        .btn-modal { flex: 1; padding: 14px; border-radius: 12px; font-weight: 800; cursor: pointer; border: none; transition: 0.2s; }
        .btn-modal-save { background: var(--primary); color: white; }
        .btn-modal-close { background: #f1f5f9; color: #64748b; }
    </style>

    <script>
        function openModal(type) {
            document.getElementById('modalOverlay').classList.add('active');
            document.getElementById('divChuDe').style.display = (type === 'CD') ? 'block' : 'none';
            document.getElementById('divNXB').style.display = (type === 'NXB') ? 'block' : 'none';
            document.getElementById('modalTitle').innerText = (type === 'CD') ? 'THÊM CHỦ ĐỀ MỚI' : 'THÊM NHÀ XUẤT BẢN';
            // Lưu loại đang thêm vào hidden field để code-behind biết
            document.getElementById('<%= hfAddType.ClientID %>').value = type;
        }
        function closeModal() {
            document.getElementById('modalOverlay').classList.remove('active');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="form-container">
        <h2 class="header-title">NHẬP SÁCH <span>MỚI</span></h2>
        
        <div class="form-group">
            <label class="form-label">Tên tiêu đề sách (*)</label>
            <asp:TextBox ID="txtTenSach" runat="server" CssClass="form-control" placeholder="Nhập tên sách đầy đủ..."></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvTen" runat="server" ControlToValidate="txtTenSach" ErrorMessage="Bắt buộc nhập tên sách" CssClass="error-msg" Display="Dynamic" ValidationGroup="G1" />
        </div>

        <div class="grid-row">
            <div class="form-group">
                <label class="form-label">Chủ đề phân loại</label>
                <div class="input-group-flex">
                    <asp:DropDownList ID="ddlChuDe" runat="server" CssClass="form-control"></asp:DropDownList>
                    <button type="button" class="btn-quick-add" onclick="openModal('CD')"><i class="fa-solid fa-plus"></i></button>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Nhà xuất bản</label>
                <div class="input-group-flex">
                    <asp:DropDownList ID="ddlNXB" runat="server" CssClass="form-control"></asp:DropDownList>
                    <button type="button" class="btn-quick-add" onclick="openModal('NXB')"><i class="fa-solid fa-plus"></i></button>
                </div>
            </div>
        </div>

        <div class="grid-row">
            <div class="form-group">
                <label class="form-label">Giá niêm yết (VNĐ) (*)</label>
                <asp:TextBox ID="txtGia" runat="server" CssClass="form-control" TextMode="Number" placeholder="0"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvGia" runat="server" ControlToValidate="txtGia" ErrorMessage="Bắt buộc nhập giá bán" CssClass="error-msg" Display="Dynamic" ValidationGroup="G1" />
            </div>
            <div class="form-group">
                <label class="form-label">Hình ảnh minh họa (*)</label>
                <asp:FileUpload ID="fuAnh" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvAnh" runat="server" ControlToValidate="fuAnh" ErrorMessage="Bắt buộc chọn ảnh bìa" CssClass="error-msg" Display="Dynamic" ValidationGroup="G1" />
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Tóm tắt nội dung</label>
            <asp:TextBox ID="txtMoTa" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Viết mô tả ngắn về sách..."></asp:TextBox>
        </div>

        <asp:Button ID="btnLuu" runat="server" Text="HOÀN TẤT THÊM MỚI" CssClass="btn-save" OnClick="btnLuu_Click" ValidationGroup="G1" />
    </div>

    <%-- MODAL THÊM NHANH CHỦ ĐỀ/NXB [cite: 2026-03-14] --%>
    <div id="modalOverlay" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <i class="fa-solid fa-folder-plus" style="color:var(--primary);"></i>
                <span id="modalTitle">THÊM MỚI</span>
            </div>
            
            <asp:HiddenField ID="hfAddType" runat="server" />

            <%-- Form thêm Chủ đề --%>
            <div id="divChuDe">
                <div class="form-group">
                    <label class="form-label">Tên chủ đề</label>
                    <asp:TextBox ID="txtNewTenCD" runat="server" CssClass="form-control" placeholder="VD: Truyện ma y học..."></asp:TextBox>
                </div>
                <div class="form-group">
                    <label class="form-label">Thuộc phân loại</label>
                    <asp:DropDownList ID="ddlModalPhanLoai" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
            </div>

            <%-- Form thêm NXB --%>
            <div id="divNXB" style="display:none;">
                <div class="form-group">
                    <label class="form-label">Tên nhà xuất bản</label>
                    <asp:TextBox ID="txtNewTenNXB" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label class="form-label">Địa chỉ</label>
                    <asp:TextBox ID="txtNewDiaChiNXB" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label class="form-label">Số điện thoại</label>
                    <asp:TextBox ID="txtNewSDTNXB" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-modal btn-modal-close" onclick="closeModal()">HỦY BỎ</button>
                <asp:Button ID="btnSaveQuick" runat="server" Text="LƯU LẠI" CssClass="btn-modal btn-modal-save" OnClick="btnSaveQuick_Click" />
            </div>
        </div>
    </div>
</asp:Content>  