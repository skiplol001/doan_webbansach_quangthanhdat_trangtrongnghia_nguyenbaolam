<%@ Page Title="Sửa Sách" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="SuaSach.aspx.cs" Inherits="lab05.Seller.SuaSach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-container { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); max-width: 800px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; color: #334155; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 8px; box-sizing: border-box; }
        .btn-save { background: #6366f1; color: white; border: none; padding: 12px 25px; border-radius: 8px; cursor: pointer; font-weight: bold; width: 100%; transition: 0.3s; }
        .btn-save:hover { background: #4f46e5; transform: translateY(-2px); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="form-container">
        <h2 style="margin-bottom: 25px; color: #1e293b;">Chỉnh Sửa Thông Tin Sách</h2>
        
        <div class="form-group">
            <label class="form-label">Tên sách</label>
            <asp:TextBox ID="txtTenSach" runat="server" CssClass="form-control"></asp:TextBox>
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

        <div class="form-group">
            <label class="form-label">Giá bán (VNĐ)</label>
            <asp:TextBox ID="txtGia" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="form-group">
            <label class="form-label">Ảnh hiện tại</label>
            <div style="margin-bottom: 10px;">
                <asp:Image ID="imgHienTai" runat="server" Width="120px" style="border-radius: 8px; border: 1px solid #ddd;" />
            </div>
            <label class="form-label">Thay đổi ảnh (Để trống nếu giữ nguyên)</label>
            <asp:FileUpload ID="fuAnh" runat="server" CssClass="form-control" />
        </div>

        <div class="form-group">
            <label class="form-label">Mô tả</label>
            <asp:TextBox ID="txtMoTa" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control"></asp:TextBox>
        </div>

        <asp:Button ID="btnCapNhat" runat="server" Text="Lưu Thay Đổi" CssClass="btn-save" OnClick="btnCapNhat_Click" />
        <div style="text-align:center; margin-top:15px;">
            <a href="QLSach.aspx" style="color: #64748b; text-decoration: none; font-size: 14px;">Quay lại danh sách</a>
        </div>
    </div>
</asp:Content>