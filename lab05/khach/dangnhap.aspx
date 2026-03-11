<%@ Page Title="ĐĂNG NHẬP" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="dangnhap.aspx.cs" Inherits="lab05.dangnhap" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .login-container { max-width: 400px; margin: 60px auto; padding: 0 20px; }
        .login-title { color: #ff4081; text-align: center; font-size: 32px; font-weight: 900; margin-bottom: 30px; text-transform: uppercase; letter-spacing: -1px; }
        .login-form { background: white; padding: 40px 35px; border-radius: 24px; box-shadow: 0 15px 35px rgba(0,0,0,0.07); border: 1px solid #f1f5f9; }
        
        .form-group { margin-bottom: 25px; }
        .form-label { display: block; margin-bottom: 10px; font-weight: 800; color: #1e293b; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-input { width: 100%; padding: 14px 18px; border: 2px solid #f1f5f9; border-radius: 12px; font-size: 15px; transition: all 0.3s ease; box-sizing: border-box; font-weight: 600; color: #334155; }
        .form-input:focus { border-color: #ff4081; outline: none; box-shadow: 0 0 0 5px rgba(255, 64, 129, 0.08); background: #fffcfd; }
        
        .btn-login { width: 100%; padding: 16px; background: linear-gradient(135deg, #ff4081, #ff80ab); color: white; border: none; border-radius: 12px; font-size: 16px; font-weight: 800; cursor: pointer; transition: 0.4s; margin-top: 10px; box-shadow: 0 10px 20px rgba(255, 64, 129, 0.2); }
        .btn-login:hover { transform: translateY(-3px); box-shadow: 0 15px 25px rgba(255, 64, 129, 0.3); }
        
        .error-message { color: #e11d48; text-align: center; margin-top: 20px; padding: 15px; background: #fff1f2; border-radius: 12px; border: 1px solid #ffe4e6; font-size: 0.9rem; font-weight: 700; display: block; }
        
        .register-link { text-align: center; margin-top: 30px; font-size: 0.95rem; color: #64748b; font-weight: 600; }
        .register-link a { color: #ff4081; text-decoration: none; font-weight: 800; margin-left: 5px; }
        .register-link a:hover { text-decoration: underline; }
        
        .validator-style { font-size: 11px; color: #e11d48; margin-top: 6px; font-weight: 700; display: block; }
        body { cursor: url('https://cur.cursors-4u.net/games/gam-4/gam372.cur'), auto !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container">
        <h2 class="login-title">Chào Mừng Trở Lại</h2>
        <div class="login-form">
            <div class="form-group">
                <label class="form-label">Tên đăng nhập</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Nhập tài khoản của bạn..." />
                <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsername" 
                    ErrorMessage="* Vui lòng nhập tên đăng nhập" CssClass="validator-style" Display="Dynamic" />
            </div>
            
            <div class="form-group">
                <label class="form-label">Mật khẩu bảo mật</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="••••••••" />
                <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" 
                    ErrorMessage="* Vui lòng nhập mật khẩu" CssClass="validator-style" Display="Dynamic" />
            </div>
            
            <asp:Button ID="btnLogin" runat="server" Text="ĐĂNG NHẬP NGAY" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <asp:Label ID="lblMessage" runat="server" CssClass="error-message" Visible="false"></asp:Label>

            <div class="register-link">
                Bạn là thành viên mới? 
                <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/khach/dangky.aspx">Tham gia ngay</asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>