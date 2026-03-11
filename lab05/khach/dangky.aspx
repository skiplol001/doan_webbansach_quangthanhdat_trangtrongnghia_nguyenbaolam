<%@ Page Title="ĐĂNG KÝ THÀNH VIÊN" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="dangky.aspx.cs" Inherits="lab05.dangky" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* PHÓNG TO GIAO DIỆN 120% [cite: 2026-03-11] */
        .register-container { max-width: 550px; margin: 40px auto; padding: 20px; }
        .register-title { color: #ff4081; text-align: center; font-size: 32px; margin-bottom: 30px; text-transform: uppercase; font-weight: 900; letter-spacing: -1px; }
        .register-form { background: white; padding: 40px; border-radius: 24px; box-shadow: 0 15px 40px rgba(0,0,0,0.07); border: 1px solid #f1f5f9; }
        
        .form-table { width: 100%; border-collapse: collapse; }
        .form-table td { padding: 12px 5px; vertical-align: top; }
        .label-cell { width: 160px; font-weight: 800; color: #1e293b; font-size: 14px; padding-top: 15px !important; text-transform: uppercase; letter-spacing: 0.5px; }
        
        .text-input { width: 100%; padding: 14px 18px; border: 2px solid #f1f5f9; border-radius: 12px; font-size: 15px; font-weight: 600; color: #334155; transition: all 0.3s ease; box-sizing: border-box; }
        .text-input:focus { border-color: #ff4081; outline: none; box-shadow: 0 0 0 5px rgba(255, 64, 129, 0.08); background: #fffcfd; }
        
        .btn-submit { width: 100%; padding: 18px; background: linear-gradient(135deg, #ff4081, #ff80ab); color: white; border: none; border-radius: 15px; font-size: 16px; font-weight: 900; cursor: pointer; margin-top: 20px; transition: 0.4s; box-shadow: 0 10px 20px rgba(255, 64, 129, 0.2); text-transform: uppercase; }
        .btn-submit:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(255, 64, 129, 0.3); }
        
        .validator-msg { font-size: 11px; font-weight: 700; color: #e11d48; display: block; margin-top: 6px; }
        .checkbox-container { display: flex; align-items: center; gap: 10px; font-weight: 800; color: #64748b; font-size: 13px; cursor: pointer; margin-top: 10px; }
        
        .status-msg { text-align: center; margin-top: 20px; padding: 15px; border-radius: 12px; font-weight: 700; font-size: 14px; display: block; }
        .msg-error { background: #fff1f2; color: #e11d48; border: 1px solid #ffe4e6; }
        .msg-success { background: #f0fdf4; color: #16a34a; border: 1px solid #dcfce7; }

        body { cursor: url('https://cur.cursors-4u.net/games/gam-4/gam372.cur'), auto !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="register-container">
        <h2 class="register-title"><i class="fa-solid fa-user-plus"></i> Đăng Ký Thành Viên</h2>
        <div class="register-form">
            <table class="form-table">
                <tr>
                    <td class="label-cell">Họ tên (*):</td>
                    <td>
                        <asp:TextBox ID="txtHoTen" runat="server" CssClass="text-input" placeholder="Nguyễn Văn A"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtHoTen" ErrorMessage="* Họ tên không được để trống" Display="Dynamic" CssClass="validator-msg"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Tài khoản (*):</td>
                    <td>
                        <asp:TextBox ID="txtTendangnhap" runat="server" CssClass="text-input" placeholder="Tên đăng nhập..."></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv2" runat="server" ControlToValidate="txtTendangnhap" ErrorMessage="* Chưa nhập tên đăng nhập" Display="Dynamic" CssClass="validator-msg"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Mật khẩu (*):</td>
                    <td>
                        <asp:TextBox ID="txtMatkhau" runat="server" CssClass="text-input" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv3" runat="server" ControlToValidate="txtMatkhau" ErrorMessage="* Mật khẩu không được để trống" Display="Dynamic" CssClass="validator-msg"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Xác nhận (*):</td>
                    <td>
                        <asp:TextBox ID="txtCfmk" runat="server" CssClass="text-input" TextMode="Password" placeholder="Nhập lại mật khẩu..."></asp:TextBox>
                        <asp:CompareValidator ID="cv1" runat="server" ControlToCompare="txtMatkhau" ControlToValidate="txtCfmk" ErrorMessage="* Mật khẩu xác nhận không khớp" Display="Dynamic" CssClass="validator-msg"></asp:CompareValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Email:</td>
                    <td>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="text-input" placeholder="example@gmail.com"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="rev1" runat="server" ControlToValidate="txtEmail" ErrorMessage="* Định dạng Email không hợp lệ" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" CssClass="validator-msg"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Điện thoại (*):</td>
                    <td>
                        <asp:TextBox ID="txtSDT" runat="server" CssClass="text-input" placeholder="Số điện thoại liên lạc..."></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv4" runat="server" ControlToValidate="txtSDT" ErrorMessage="* Vui lòng nhập số điện thoại" Display="Dynamic" CssClass="validator-msg"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Địa chỉ:</td>
                    <td><asp:TextBox ID="txtDiachi" runat="server" CssClass="text-input" TextMode="MultiLine" Rows="2" placeholder="Địa chỉ giao hàng..."></asp:TextBox></td>
                </tr>
                <tr>
                    <td class="label-cell">Ngày sinh:</td>
                    <td><asp:TextBox ID="txtNgay" runat="server" CssClass="text-input" TextMode="Date"></asp:TextBox></td>
                </tr>
                <tr>
                    <td class="label-cell">Vai trò:</td>
                    <td>
                        <div class="checkbox-container">
                           <asp:CheckBox ID="chkBanHang" runat="server" Text=" Đăng ký làm người bán hàng" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btndangky" runat="server" Text="XÁC NHẬN ĐĂNG KÝ" CssClass="btn-submit" OnClick="btnthem_Click" />
                        <asp:Label ID="lblThongBao" runat="server" CssClass="status-msg" Visible="false"></asp:Label>
                        
                        <div style="text-align:center; margin-top:20px; font-weight:600; color:#64748b; font-size:14px;">
                            Đã có tài khoản? <a href="dangnhap.aspx" style="color:#ff4081; text-decoration:none; font-weight:800;">Đăng nhập ngay</a>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>