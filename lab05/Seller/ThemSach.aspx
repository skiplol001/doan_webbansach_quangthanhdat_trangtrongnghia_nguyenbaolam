<%@ Page Title="Thêm Sách Mới" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="ThemSach.aspx.cs" Inherits="lab05.Seller.ThemSach" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-container { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); max-width: 800px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; color: #334155; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 8px; box-sizing: border-box; }
        .btn-save { background: #6366f1; color: white; border: none; padding: 12px 25px; border-radius: 8px; cursor: pointer; font-weight: bold; width: 100%; }
        .btn-save:hover { background: #4f46e5; }
        .error-msg { color: #ef4444; font-size: 13px; margin-top: 5px; display: block; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="form-container">
        <h2 style="margin-bottom: 25px; color: #1e293b;">Thêm Sách Vào Cửa Hàng</h2>
        
        <div class="form-group">
            <label class="form-label">Tên sách (*)</label>
            <asp:TextBox ID="txtTenSach" runat="server" CssClass="form-control" placeholder="Ví dụ: Lập trình C# cơ bản"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvTen" runat="server" ControlToValidate="txtTenSach" ErrorMessage="Vui lòng nhập tên sách" CssClass="error-msg" Display="Dynamic" />
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="form-group">
                <label class="form-label">Chủ đề</label>
                <asp:DropDownList ID="ddlChuDe" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            <div class="form-group">
                <label class="form-label">Nhà xuất bản</label>
                <asp:DropDownList ID="ddlNXB" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="form-group">
                <label class="form-label">Giá bán (VNĐ) (*)</label>
                <asp:TextBox ID="txtGia" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvGia" runat="server" ControlToValidate="txtGia" ErrorMessage="Vui lòng nhập giá" CssClass="error-msg" Display="Dynamic" />
            </div>
            <div class="form-group">
                <label class="form-label">Ảnh bìa (*)</label>
                <asp:FileUpload ID="fuAnh" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvAnh" runat="server" ControlToValidate="fuAnh" ErrorMessage="Vui lòng chọn ảnh" CssClass="error-msg" Display="Dynamic" />
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">Mô tả nội dung</label>
            <asp:TextBox ID="txtMoTa" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control"></asp:TextBox>
        </div>

        <asp:Button ID="btnLuu" runat="server" Text="Lưu Sách Mới" CssClass="btn-save" OnClick="btnLuu_Click" />
    </div>
</asp:Content>