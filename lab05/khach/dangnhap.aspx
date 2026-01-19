<%@ Page Title="ĐĂNG NHẬP" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="dangnhap.aspx.cs" Inherits="lab05.dangnhap" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .login-container { max-width: 400px; margin: 50px auto; padding: 0 20px; }
        .login-title { color: #ff4081; text-align: center; font-size: 28px; font-weight: 800; margin-bottom: 30px; text-transform: uppercase; }
        .login-form { background: white; padding: 35px; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
        
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 700; color: #333; font-size: 0.9rem; }
        .form-input { width: 100%; padding: 12px 15px; border: 1px solid #e2e8f0; border-radius: 10px; font-size: 15px; transition: all 0.3s; box-sizing: border-box; }
        .form-input:focus { border-color: #ff4081; outline: none; box-shadow: 0 0 0 4px rgba(255, 64, 129, 0.1); }
        
        .btn-login { width: 100%; padding: 14px; background: linear-gradient(135deg, #ff4081, #ff80ab); color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 800; cursor: pointer; transition: 0.3s; margin-top: 10px; }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255, 64, 129, 0.3); }
        
        .error-message { color: #ef4444; text-align: center; margin-top: 15px; padding: 12px; background: #fef2f2; border-radius: 8px; border: 1px solid #fee2e2; font-size: 0.85rem; font-weight: 600; display: block; }
        
        .register-link { text-align: center; margin-top: 25px; font-size: 0.9rem; color: #666; }
        .register-link a { color: #ff4081; text-decoration: none; font-weight: 700; }
        .register-link a:hover { text-decoration: underline; }
        .validator-style { font-size: 0.75rem; color: #ef4444; margin-top: 4px; display: block; }
          body { cursor: url('https://cur.cursors-4u.net/games/gam-4/gam372.cur'), auto !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container">
        <h2 class="login-title">Đăng Nhập</h2>
        <div class="login-form">
            <div class="form-group">
                <label class="form-label">Tên đăng nhập</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Nhập tài khoản..." />
                <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsername" 
                    ErrorMessage="Tên đăng nhập không được để trống" CssClass="validator-style" Display="Dynamic" />
            </div>
            
            <div class="form-group">
                <label class="form-label">Mật khẩu</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Nhập mật khẩu..." />
                <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" 
                    ErrorMessage="Mật khẩu không được để trống" CssClass="validator-style" Display="Dynamic" />
            </div>
            
            <asp:Button ID="btnLogin" runat="server" Text="ĐĂNG NHẬP" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <asp:Label ID="lblMessage" runat="server" CssClass="error-message" Visible="false"></asp:Label>

            <div class="register-link">
                Bạn chưa có tài khoản? 
                <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/khach/dangky.aspx">Đăng ký ngay</asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>