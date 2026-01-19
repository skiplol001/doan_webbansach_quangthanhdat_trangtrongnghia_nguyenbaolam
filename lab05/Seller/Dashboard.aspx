<%@ Page Title="Thống kê doanh thu" Language="C#" MasterPageFile="~/Seller/Seller.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="lab05.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); display: flex; align-items: center; gap: 20px; border: 1px solid #f1f5f9; }
        .stat-icon { width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; color: white; }
        .stat-info h3 { margin: 0; color: #64748b; font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-info p { margin: 5px 0 0; font-size: 24px; font-weight: 800; color: #1e293b; }
        
        .bg-blue { background: #3b82f6; }
        .bg-green { background: #10b981; }
        .bg-purple { background: #8b5cf6; }

        .recent-table { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border: 1px solid #f1f5f9; }
        .table-title { font-size: 18px; font-weight: 700; margin-bottom: 20px; color: #1e293b; display: flex; align-items: center; gap: 10px; }
        
        /* Custom GridView Style */
        .table-custom { width: 100%; border-collapse: collapse; }
        .table-custom th { text-align: left; padding: 15px; border-bottom: 2px solid #f1f5f9; color: #64748b; font-size: 0.85rem; }
        .table-custom td { padding: 15px; border-bottom: 1px solid #f1f5f9; color: #334155; font-size: 0.9rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="display:flex; align-items:center; gap:10px; margin-bottom: 25px;">
        <i class="fa-solid fa-gauge-high" style="color:var(--seller-primary); font-size: 1.5rem;"></i>
        <h2 style="margin:0;">TỔNG QUAN <span>KINH DOANH</span></h2>
    </div>
    
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon bg-blue"><i class="fa-solid fa-money-bill-trend-up"></i></div>
            <div class="stat-info">
                <h3>Doanh thu</h3>
                <p><asp:Literal ID="litRevenue" runat="server" Text="0"></asp:Literal> đ</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-green"><i class="fa-solid fa-cart-check"></i></div>
            <div class="stat-info">
                <h3>Đơn hàng</h3>
                <p><asp:Literal ID="litOrders" runat="server" Text="0"></asp:Literal></p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-purple"><i class="fa-solid fa-book-open"></i></div>
            <div class="stat-info">
                <h3>Sách đang bán</h3>
                <p><asp:Literal ID="litBooks" runat="server" Text="0"></asp:Literal></p>
            </div>
        </div>
    </div>

    <div class="recent-table">
        <div class="table-title">
            <i class="fa-solid fa-clock-rotate-left"></i> Đơn hàng mới nhất
        </div>
        <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="False" 
            CssClass="table-custom" GridLines="None" Width="100%">
            <Columns>
                <asp:BoundField DataField="SoDH" HeaderText="MÃ ĐH" ItemStyle-Font-Bold="true" />
                <asp:BoundField DataField="NgayDH" HeaderText="NGÀY ĐẶT" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:BoundField DataField="HoTenKH" HeaderText="KHÁCH HÀNG" />
                <asp:BoundField DataField="Trigia" HeaderText="TRỊ GIÁ" DataFormatString="{0:#,##0} đ" ItemStyle-ForeColor="#ef4444" ItemStyle-Font-Bold="true" />
                <asp:TemplateField HeaderText="TRẠNG THÁI">
                    <ItemTemplate>
                        <%# (bool)Eval("Dagiao") ? 
                            "<span style='background:#dcfce7; color:#166534; padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700;'>ĐÃ GIAO</span>" : 
                            "<span style='background:#fef3c7; color:#92400e; padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700;'>ĐANG XỬ LÝ</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div style="text-align:center; padding:50px; color:#94a3b8;">
                    Chưa có đơn hàng nào được thực hiện.
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>