<%@ Page Title="Hồ sơ người dùng" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="thongtin-taikhoan.aspx.cs" Inherits="lab05.thongtin_taikhoan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .account-wrapper { max-width: 1240px; margin: 40px auto; display: grid; grid-template-columns: 350px 1fr; gap: 30px; padding: 0 20px; }
        .profile-card, .orders-card { background: #ffffff; padding: 30px; border-radius: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
        
        .section-header { display: flex; align-items: center; gap: 10px; font-weight: 800; color: #1e293b; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #fdf2f8; text-transform: uppercase; font-size: 1rem; }

        /* Style dòng thông tin (Bên trái) */
        .info-row { margin-bottom: 22px; padding-left: 15px; border-left: 4px solid #ff4081; background: #fffcfd; padding: 12px; border-radius: 0 12px 12px 0; }
        .info-label { font-size: 10px; font-weight: 800; color: #94a3b8; text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 4px; }
        .info-value { font-size: 15px; font-weight: 700; color: #334155; }

        /* Bảng Đơn hàng (Bên phải) */
        .order-table { width: 100%; border-collapse: collapse; }
        .order-table th { text-align: left; padding: 15px; background: #f8fafc; color: #64748b; font-size: 11px; font-weight: 800; text-transform: uppercase; border-bottom: 2px solid #f1f5f9; }
        .order-table td { padding: 18px 15px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        
        .book-img-small { width: 50px; height: 70px; object-fit: cover; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .status-badge { padding: 6px 14px; border-radius: 50px; font-size: 10px; font-weight: 700; text-transform: uppercase; display: inline-flex; align-items: center; gap: 5px; }
        .status-delivered { background: #dcfce7; color: #166534; }
        .status-pending { background: #fef3c7; color: #92400e; }

        @media (max-width: 992px) { .account-wrapper { grid-template-columns: 1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="account-wrapper">
        <%-- TRÁI: THÔNG TIN CÁ NHÂN (ẨN HẲN NẾU THIẾU) --%>
        <aside class="profile-card">
            <div class="section-header"><i class="fa-solid fa-user-shield" style="color:#ff4081;"></i> Hồ sơ cá nhân</div>

            <asp:Panel ID="pnlHoTen" runat="server" CssClass="info-row">
                <div class="info-label">Họ tên khách hàng</div>
                <div class="info-value"><asp:Literal ID="litHoTen" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlTenDN" runat="server" CssClass="info-row">
                <div class="info-label">Tên đăng nhập</div>
                <div class="info-value"><asp:Literal ID="litTenDN" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlEmail" runat="server" CssClass="info-row">
                <div class="info-label">Địa chỉ Email</div>
                <div class="info-value"><asp:Literal ID="litEmail" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlDienThoai" runat="server" CssClass="info-row">
                <div class="info-label">Số điện thoại</div>
                <div class="info-value"><asp:Literal ID="litDienThoai" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlDiaChi" runat="server" CssClass="info-row">
                <div class="info-label">Địa chỉ giao hàng</div>
                <div class="info-value"><asp:Literal ID="litDiaChi" runat="server" /></div>
            </asp:Panel>
        </aside>

        <%-- PHẢI: DANH SÁCH SÁCH ĐÃ MUA --%>
        <main class="orders-card">
            <div class="section-header"><i class="fa-solid fa-receipt" style="color:#ff4081;"></i> Lịch sử mua hàng</div>

            <asp:GridView ID="gvPurchasedBooks" runat="server" AutoGenerateColumns="False" CssClass="order-table" GridLines="None" Width="100%">
                <Columns>
                    <asp:TemplateField HeaderText="Sách đã mua">
                        <ItemTemplate>
                            <div style="display:flex; align-items:center; gap:15px;">
                                <img src='<%# ResolveUrl("~/Images/") + Eval("AnhBia") %>' class="book-img-small" onerror="this.src='../Images/no-image.jpg'" />
                                <span style="font-weight:800; color:#1e293b;"><%# Eval("TenSach") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="NgayDH" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-Font-Bold="true" />

                    <asp:TemplateField HeaderText="Trạng thái">
                        <ItemTemplate>
                            <%# (bool)Eval("Dagiao") ? 
                                "<span class='status-badge status-delivered'><i class='fa-solid fa-circle-check'></i> Đã giao hàng</span>" : 
                                "<span class='status-badge status-pending'><i class='fa-solid fa-clock-rotate-left'></i> Đang xử lý</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="text-align:center; padding:60px; color:#94a3b8;">
                        <i class="fa-solid fa-box-open" style="font-size:40px; margin-bottom:15px; opacity:0.3;"></i><br />
                        Bạn chưa sở hữu quyển sách nào. Hãy bắt đầu mua sắm ngay!
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </main>
    </div>
</asp:Content>