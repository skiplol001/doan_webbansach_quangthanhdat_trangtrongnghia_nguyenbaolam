<%@ Page Title="ĐĂNG KÝ" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="dangky.aspx.cs" Inherits="lab05.dangky" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .register-container { max-width: 500px; margin: 30px auto; padding: 20px; }
        .register-title { color: #ff4081; text-align: center; font-size: 28px; margin-bottom: 20px; text-transform: uppercase; font-weight: 800; }
        .register-form { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        .form-table { width: 100%; }
        .form-table td { padding: 10px 5px; }
        .label-cell { width: 150px; font-weight: 600; color: #333; font-size: 14px; }
        .text-input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .btn-submit { width: 100%; padding: 15px; background: linear-gradient(135deg, #ff4081, #ff80ab); color: white; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        .btn-submit:hover { filter: brightness(1.1); }
        .validator-msg { font-size: 12px; display: block; margin-top: 5px; }
        /* Style cho checkbox */
        .checkbox-container { display: flex; align-items: center; gap: 8px; font-weight: 600; color: #ff4081; cursor: pointer; }
        .checkbox-container input { width: 18px; height: 18px; cursor: pointer; }
          body { cursor: url('https://cur.cursors-4u.net/games/gam-4/gam372.cur'), auto !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="register-container">
        <h2 class="register-title">ĐĂNG KÝ THÀNH VIÊN</h2>
        <div class="register-form">
            <table class="form-table">
                <tr>
                    <td class="label-cell">Họ tên (*):</td>
                    <td>
                        <asp:TextBox ID="txtHoTen" runat="server" CssClass="text-input" placeholder="Nguyễn Văn A"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtHoTen" ErrorMessage="Chưa nhập họ tên" Display="Dynamic" ForeColor="Red" CssClass="validator-msg"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Tên đăng nhập (*):</td>
                    <td>
                        <asp:TextBox ID="txtTendangnhap" runat="server" CssClass="text-input" placeholder="username123"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv2" runat="server" ControlToValidate="txtTendangnhap" ErrorMessage="Chưa nhập tên đăng nhập" Display="Dynamic" ForeColor="Red" CssClass="validator-msg"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Mật khẩu (*):</td>
                    <td>
                        <asp:TextBox ID="txtMatkhau" runat="server" CssClass="text-input" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv3" runat="server" ControlToValidate="txtMatkhau" ErrorMessage="Chưa nhập mật khẩu" Display="Dynamic" ForeColor="Red" CssClass="validator-msg"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Xác nhận MK (*):</td>
                    <td>
                        <asp:TextBox ID="txtCfmk" runat="server" CssClass="text-input" TextMode="Password"></asp:TextBox>
                        <asp:CompareValidator ID="cv1" runat="server" ControlToCompare="txtMatkhau" ControlToValidate="txtCfmk" ErrorMessage="Mật khẩu không khớp" Display="Dynamic" ForeColor="Red" CssClass="validator-msg"></asp:CompareValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Email:</td>
                    <td>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="text-input" placeholder="example@gmail.com"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="rev1" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email không hợp lệ" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" ForeColor="Red" CssClass="validator-msg"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Điện thoại (*):</td>
                    <td>
                        <asp:TextBox ID="txtSDT" runat="server" CssClass="text-input"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfv4" runat="server" ControlToValidate="txtSDT" ErrorMessage="Chưa nhập số điện thoại" Display="Dynamic" ForeColor="Red" CssClass="validator-msg"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="label-cell">Địa chỉ:</td>
                    <td><asp:TextBox ID="txtDiachi" runat="server" CssClass="text-input" TextMode="MultiLine" Rows="2"></asp:TextBox></td>
                </tr>
                <tr>
                    <td class="label-cell">Ngày sinh:</td>
                    <td><asp:TextBox ID="txtNgay" runat="server" CssClass="text-input" TextMode="Date"></asp:TextBox></td>
                </tr>
                <tr>
                    <td class="label-cell"></td>
                    <td>
                        <div class="checkbox-container">
                           <asp:CheckBox ID="chkBanHang" runat="server" Text="" Visible="false" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btndangky" runat="server" Text="ĐĂNG KÝ NGAY" CssClass="btn-submit" OnClick="btnthem_Click" />
                        <div style="text-align:center; margin-top:15px;">
                            <asp:Label ID="lblThongBao" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>