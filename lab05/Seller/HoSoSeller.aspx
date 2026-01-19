<%@ Page Title="Hồ sơ người bán" Language="C#" MasterPageFile="~/Seller/Seller.Master" AutoEventWireup="true" CodeBehind="HoSoSeller.aspx.cs" Inherits="lab05.Admin.HoSoSeller" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-container { display: grid; grid-template-columns: 1fr 350px; gap: 30px; max-width: 1200px; }
        .card { background: white; padding: 35px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
        
        .section-title { font-size: 1.2rem; font-weight: 800; color: #1e293b; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; text-transform: uppercase; }
        .section-title i { color: var(--seller-primary); }

        /* Row Info Style */
        .info-group { margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid #f8fafc; }
        .info-label { font-size: 11px; font-weight: 800; color: #94a3b8; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; }
        .info-data { font-size: 16px; font-weight: 600; color: #334155; }

        /* Stats Card */
        .stat-box { background: #f1f5f9; padding: 20px; border-radius: 15px; margin-bottom: 20px; display: flex; align-items: center; gap: 15px; }
        .stat-icon { width: 45px; height: 45px; background: white; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: var(--seller-primary); font-size: 1.2rem; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .stat-val { display: block; font-size: 20px; font-weight: 800; color: #1e293b; }
        .stat-lab { font-size: 12px; color: #64748b; font-weight: 600; }

        .role-badge { background: #e0e7ff; color: #4338ca; padding: 6px 15px; border-radius: 50px; font-size: 11px; font-weight: 800; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profile-container">
        <%-- TRÁI: THÔNG TIN CÁ NHÂN (ẨN NẾU THIẾU) --%>
        <div class="card">
            <div class="section-title"><i class="fa-solid fa-address-card"></i> Thông tin đối tác</div>
            
            <asp:Panel ID="pnlHoTen" runat="server" CssClass="info-group">
                <div class="info-label">Họ tên người bán</div>
                <div class="info-data"><asp:Literal ID="litHoTen" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlTenDN" runat="server" CssClass="info-group">
                <div class="info-label">Tên tài khoản quản trị</div>
                <div class="info-data"><asp:Literal ID="litTenDN" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlEmail" runat="server" CssClass="info-group">
                <div class="info-label">Email liên hệ công việc</div>
                <div class="info-data"><asp:Literal ID="litEmail" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlPhone" runat="server" CssClass="info-group">
                <div class="info-label">Số điện thoại</div>
                <div class="info-data"><asp:Literal ID="litPhone" runat="server" /></div>
            </asp:Panel>

            <asp:Panel ID="pnlAddress" runat="server" CssClass="info-group">
                <div class="info-label">Địa chỉ kho hàng</div>
                <div class="info-data"><asp:Literal ID="litAddress" runat="server" /></div>
            </asp:Panel>

            <div style="margin-top: 10px;">
                <span class="role-badge"><i class="fa-solid fa-shield-check"></i> TÀI KHOẢN ĐÃ XÁC MINH</span>
            </div>
        </div>

        <%-- PHẢI: THỐNG KÊ NHANH --%>
        <div class="profile-stats">
            <div class="card">
                <div class="section-title"><i class="fa-solid fa-chart-simple"></i> Thống kê kho</div>
                
                <div class="stat-box">
                    <div class="stat-icon"><i class="fa-solid fa-book"></i></div>
                    <div>
                        <span class="stat-val"><asp:Literal ID="litTotalBooks" runat="server" Text="0" /></span>
                        <span class="stat-lab">Sách đang bán</span>
                    </div>
                </div>

                <div class="stat-box">
                    <div class="stat-icon"><i class="fa-solid fa-cart-shopping"></i></div>
                    <div>
                        <span class="stat-val"><asp:Literal ID="litTotalOrders" runat="server" Text="0" /></span>
                        <span class="stat-lab">Tổng số đơn hàng</span>
                    </div>
                </div>

                <div style="padding: 15px; background: #fff7ed; border-radius: 12px; border: 1px solid #ffedd5; font-size: 13px; color: #9a3412;">
                    <i class="fa-solid fa-circle-info"></i> <b>Lưu ý:</b> Các chỉ số này được cập nhật theo thời gian thực từ hệ thống.
                </div>
            </div>
        </div>
    </div>
</asp:Content>