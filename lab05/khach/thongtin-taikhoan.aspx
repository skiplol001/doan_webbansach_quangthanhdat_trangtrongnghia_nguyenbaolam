<%@ Page Title="Hồ sơ cá nhân" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="thongtin-taikhoan.aspx.cs" Inherits="lab05.thongtin_taikhoan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary: #ff4081; --primary-hover: #f50057; --bg-card: #ffffff; }

        /* PHÓNG TO GIAO DIỆN 120% */
        .account-wrapper { max-width: 1280px; margin: 40px auto; display: grid; grid-template-columns: 380px 1fr; gap: 35px; padding: 0 20px; font-size: 15px; }
        .profile-card, .orders-card { background: var(--bg-card); padding: 35px; border-radius: 28px; box-shadow: 0 15px 40px rgba(0,0,0,0.06); border: 1px solid #f1f5f9; }
        
        .section-header { display: flex; align-items: center; gap: 12px; font-weight: 900; color: #1e293b; margin-bottom: 30px; padding-bottom: 15px; border-bottom: 2px solid #fdf2f8; text-transform: uppercase; font-size: 1.1rem; }

        /* --- PHẦN AVATAR --- */
        .avatar-section { text-align: center; margin-bottom: 30px; position: relative; }
        .avatar-img { width: 140px; height: 140px; border-radius: 50%; object-fit: cover; border: 5px solid #fff; box-shadow: 0 10px 25px rgba(255, 64, 129, 0.2); background: #f8fafc; margin-bottom: 15px; }
        .upload-btn-wrapper { position: relative; overflow: hidden; display: inline-block; }
        .btn-upload { border: 2px solid #e2e8f0; color: #64748b; background-color: white; padding: 8px 20px; border-radius: 12px; font-size: 12px; font-weight: 800; cursor: pointer; transition: 0.3s; }
        .btn-upload:hover { border-color: var(--primary); color: var(--primary); }
        .upload-btn-wrapper input[type=file] { font-size: 100px; position: absolute; left: 0; top: 0; opacity: 0; cursor: pointer; }

        /* --- FORM CHỈNH SỬA --- */
        .form-group { margin-bottom: 25px; }
        .form-label { display: block; font-size: 11px; font-weight: 800; color: #94a3b8; text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 8px; }
        .form-control-edit { width: 100%; padding: 14px 18px; border: 2px solid #f1f5f9; border-radius: 14px; font-size: 15px; font-weight: 700; color: #334155; transition: 0.3s; background: #fffcfd; }
        .form-control-edit:focus { border-color: var(--primary); outline: none; background: #fff; box-shadow: 0 0 0 5px rgba(255, 64, 129, 0.05); }
        .form-control-readonly { background: #f8fafc; border-color: #f1f5f9; color: #94a3b8; cursor: not-allowed; }

        .btn-save-profile { background: var(--primary); color: white; border: none; padding: 18px; border-radius: 16px; font-weight: 900; width: 100%; cursor: pointer; transition: 0.3s; box-shadow: 0 10px 20px rgba(255, 64, 129, 0.2); text-transform: uppercase; letter-spacing: 1px; }
        .btn-save-profile:hover { transform: translateY(-3px); background: var(--primary-hover); box-shadow: 0 15px 30px rgba(255, 64, 129, 0.3); }

        /* --- MỚI: STYLE CHO PHẦN ĐỔI MẬT KHẨU [cite: 2026-03-14] --- */
        .password-section { margin-top: 30px; padding-top: 25px; border-top: 2px dashed #f1f5f9; }
        .btn-toggle-pass { background: #f8fafc; color: #64748b; border: 2px solid #e2e8f0; padding: 12px; border-radius: 12px; width: 100%; font-weight: 800; font-size: 12px; cursor: pointer; transition: 0.3s; margin-bottom: 20px; }
        .btn-toggle-pass:hover { background: #fff; border-color: var(--primary); color: var(--primary); }
        .change-pass-box { background: #fffcfd; padding: 20px; border-radius: 18px; border: 1px solid #ffeff7; }

        /* --- LỊCH SỬ MUA HÀNG --- */
        .order-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .order-table th { text-align: left; padding: 15px 20px; color: #64748b; font-size: 11px; font-weight: 800; text-transform: uppercase; }
        .order-table td { padding: 20px; background: #fff; vertical-align: middle; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
        .order-table td:first-child { border-left: 1px solid #f1f5f9; border-top-left-radius: 15px; border-bottom-left-radius: 15px; }
        .order-table td:last-child { border-right: 1px solid #f1f5f9; border-top-right-radius: 15px; border-bottom-right-radius: 15px; }
        
        .book-link { display: flex; align-items: center; gap: 15px; text-decoration: none; color: #1e293b; font-weight: 800; transition: 0.2s; }
        .book-link:hover { color: var(--primary); }
        .book-img-small { width: 55px; height: 75px; object-fit: cover; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.08); }

        .status-badge { padding: 8px 16px; border-radius: 12px; font-size: 11px; font-weight: 800; text-transform: uppercase; display: inline-flex; align-items: center; gap: 6px; }
        .status-delivered { background: #ecfdf5; color: #10b981; }
        .status-pending { background: #fffbeb; color: #d97706; }

        @media (max-width: 992px) { .account-wrapper { grid-template-columns: 1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="account-wrapper">
        <%-- PHẦN 1: CẬP NHẬT HỒ SƠ --%>
        <aside class="profile-card">
            <div class="section-header"><i class="fa-solid fa-user-pen" style="color:var(--primary);"></i> Chỉnh sửa hồ sơ</div>

            <div class="avatar-section">
                <asp:Image ID="imgKH" runat="server" CssClass="avatar-img" ImageUrl="~/Images/no-avatar.jpg" />
                <div class="upload-btn-wrapper">
                    <button class="btn-upload" type="button"><i class="fa-solid fa-camera"></i> Đổi ảnh đại diện</button>
                    <asp:FileUpload ID="fuAvatar" runat="server" onchange="this.form.submit()" />
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Họ tên của bạn</label>
                <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control-edit" placeholder="Nhập họ tên..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Tên đăng nhập (Cố định)</label>
                <asp:TextBox ID="txtTenDN" runat="server" CssClass="form-control-edit form-control-readonly" ReadOnly="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Email liên hệ</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control-edit" TextMode="Email"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Số điện thoại</label>
                <asp:TextBox ID="txtDienThoai" runat="server" CssClass="form-control-edit"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Địa chỉ nhận hàng</label>
                <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control-edit" TextMode="MultiLine" Rows="2"></asp:TextBox>
            </div>

            <asp:Button ID="btnUpdate" runat="server" Text="LƯU THÔNG TIN" CssClass="btn-save-profile" OnClick="btnUpdate_Click" />

            <%-- MỚI: KHU VỰC ĐỔI MẬT KHẨU [cite: 2026-03-14] --%>
            <div class="password-section">
                <asp:Button ID="btnTogglePass" runat="server" Text="🛡️ THAY ĐỔI MẬT KHẨU" CssClass="btn-toggle-pass" OnClick="btnTogglePass_Click" />
                
                <asp:Panel ID="pnlChangePass" runat="server" Visible="false" CssClass="change-pass-box">
                    <div class="form-group">
                        <label class="form-label">Mật khẩu hiện tại</label>
                        <asp:TextBox ID="txtOldPass" runat="server" CssClass="form-control-edit" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Mật khẩu mới</label>
                        <asp:TextBox ID="txtNewPass" runat="server" CssClass="form-control-edit" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Xác nhận mật khẩu mới</label>
                        <asp:TextBox ID="txtConfirmPass" runat="server" CssClass="form-control-edit" TextMode="Password"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnConfirmChangePass" runat="server" Text="CẬP NHẬT MẬT KHẨU" CssClass="btn-save-profile" style="font-size:12px; padding:12px;" OnClick="btnConfirmChangePass_Click" />
                </asp:Panel>
            </div>
        </aside>

        <%-- PHẦN 2: LỊCH SỬ MUA HÀNG --%>
        <main class="orders-card">
            <div class="section-header"><i class="fa-solid fa-clock-rotate-left" style="color:var(--primary);"></i> Lịch sử mua hàng</div>

            <asp:GridView ID="gvPurchasedBooks" runat="server" AutoGenerateColumns="False" CssClass="order-table" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Thông tin sản phẩm">
                        <ItemTemplate>
                            <a href='<%# "chitiet.aspx?MaSach=" + Eval("MaSach") %>' class="book-link">
                                <img src='<%# ResolveUrl("~/Images/") + Eval("AnhBia") %>' class="book-img-small" />
                                <span><%# Eval("TenSach") %></span>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="NgayDH" HeaderText="Ngày mua" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Width="120px" ItemStyle-Font-Bold="true" />

                    <asp:TemplateField HeaderText="Thành tiền">
                        <ItemTemplate>
                            <span style="color:var(--primary); font-weight:800;"><%# string.Format("{0:#,##0}đ", Eval("Thanhtien")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Trạng thái">
                        <ItemTemplate>
                            <%# (bool)Eval("Dagiao") ? 
                                "<span class='status-badge status-delivered'><i class='fa-solid fa-check'></i> Thành công</span>" : 
                                "<span class='status-badge status-pending'><i class='fa-solid fa-truck-fast'></i> Đang giao</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="text-align:center; padding:100px 0; color:#cbd5e1;">
                        <i class="fa-solid fa-cart-arrow-down" style="font-size:60px; margin-bottom:20px;"></i>
                        <h3 style="color:#94a3b8;">Bạn chưa mua quyển sách nào!</h3>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </main>
    </div>
</asp:Content>