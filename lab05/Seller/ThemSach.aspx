<%@ Page Title="Thêm Sách Mới" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="ThemSach.aspx.cs" Inherits="lab05.Seller.ThemSach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary: #6366f1; --bg-body: #f8fafc; }

        /* PHÓNG TO GIAO DIỆN 120% [cite: 2026-03-11] */
        body { font-size: 14.5px; background-color: var(--bg-body); }
        .form-container { background: white; padding: 35px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.06); max-width: 900px; margin: 30px auto; border: 1px solid #f1f5f9; }
        
        .header-title { font-weight: 900; color: #1e293b; margin-bottom: 30px; text-transform: uppercase; font-size: 1.5rem; border-left: 6px solid var(--primary); padding-left: 15px; }
        
        .form-group { margin-bottom: 25px; }
        .form-label { display: block; margin-bottom: 10px; font-weight: 700; color: #475569; font-size: 13px; text-transform: uppercase; }
        
        /* Input lớn hơn */
        .form-control { width: 100%; padding: 12px 18px; border: 2px solid #e2e8f0; border-radius: 12px; font-size: 15px; transition: 0.3s; box-sizing: border-box; }
        .form-control:focus { border-color: var(--primary); outline: none; box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1); }
        
        .grid-row { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }

        .btn-save { background: var(--primary); color: white; border: none; padding: 18px; border-radius: 15px; cursor: pointer; font-weight: 900; width: 100%; font-size: 16px; text-transform: uppercase; letter-spacing: 1px; transition: 0.3s; margin-top: 10px; box-shadow: 0 10px 20px rgba(99, 102, 241, 0.2); }
        .btn-save:hover { transform: translateY(-3px); filter: brightness(1.1); box-shadow: 0 15px 30px rgba(99, 102, 241, 0.3); }
        
        .error-msg { color: #ef4444; font-size: 13px; margin-top: 8px; font-weight: 600; display: block; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="form-container">
        <h2 class="header-title">NHẬP SÁCH <span>MỚI</span></h2>
        
        <div class="form-group">
            <label class="form-label">Tên tiêu đề sách (*)</label>
            <asp:TextBox ID="txtTenSach" runat="server" CssClass="form-control" placeholder="Nhập tên sách đầy đủ..."></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvTen" runat="server" ControlToValidate="txtTenSach" ErrorMessage="Bắt buộc nhập tên sách" CssClass="error-msg" Display="Dynamic" />
        </div>

        <div class="grid-row">
            <div class="form-group">
                <label class="form-label">Chủ đề phân loại</label>
                <asp:DropDownList ID="ddlChuDe" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="form-group">
                <label class="form-label">Nhà xuất bản</label>
                <asp:DropDownList ID="ddlNXB" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
        </div>

        <div class="grid-row">
            <div class="form-group">
                <label class="form-label">Giá niêm yết (VNĐ) (*)</label>
                <asp:TextBox ID="txtGia" runat="server" CssClass="form-control" TextMode="Number" placeholder="0"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvGia" runat="server" ControlToValidate="txtGia" ErrorMessage="Bắt buộc nhập giá bán" CssClass="error-msg" Display="Dynamic" />
            </div>
            <div class="form-group">
                <label class="form-label">Hình ảnh minh họa (*)</label>
                <asp:FileUpload ID="fuAnh" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvAnh" runat="server" ControlToValidate="fuAnh" ErrorMessage="Bắt buộc chọn ảnh bìa" CssClass="error-msg" Display="Dynamic" />
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Tóm tắt nội dung</label>
            <asp:TextBox ID="txtMoTa" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Viết mô tả ngắn về sách..."></asp:TextBox>
        </div>

        <asp:Button ID="btnLuu" runat="server" Text="HOÀN TẤT THÊM MỚI" CssClass="btn-save" OnClick="btnLuu_Click" />
    </div>
</asp:Content>