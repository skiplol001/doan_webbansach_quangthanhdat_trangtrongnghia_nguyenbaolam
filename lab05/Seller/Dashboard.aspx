<%@ Page Title="Thống kê doanh thu" Language="C#" MasterPageFile="~/Seller/Seller.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="lab05.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --seller-primary: #ff4081; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 20px; border: 1px solid #f1f5f9; transition: 0.3s; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); }
        .stat-icon { width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; color: white; }
        .stat-info h3 { margin: 0; color: #64748b; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700; }
        .stat-info p { margin: 5px 0 0; font-size: 24px; font-weight: 900; color: #1e293b; }
        
        .bg-blue { background: linear-gradient(135deg, #3b82f6, #2563eb); }
        .bg-green { background: linear-gradient(135deg, #10b981, #059669); }
        .bg-purple { background: linear-gradient(135deg, #8b5cf6, #7c3aed); }

        .dashboard-main { display: grid; grid-template-columns: 1.5fr 1fr; gap: 25px; }
        .chart-container, .recent-table { background: white; padding: 25px; border-radius: 20px; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        
        .table-title { font-size: 16px; font-weight: 800; margin-bottom: 20px; color: #1e293b; display: flex; align-items: center; gap: 10px; text-transform: uppercase; }
        .table-custom { width: 100%; border-collapse: collapse; }
        .table-custom th { text-align: left; padding: 12px; border-bottom: 2px solid #f8fafc; color: #94a3b8; font-size: 11px; }
        .table-custom td { padding: 15px 12px; border-bottom: 1px solid #f8fafc; color: #334155; font-size: 13px; }

        @media (max-width: 1024px) { .dashboard-main { grid-template-columns: 1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="display:flex; align-items:center; gap:10px; margin-bottom: 25px;">
        <i class="fa-solid fa-chart-line" style="color:var(--seller-primary); font-size: 1.5rem;"></i>
        <h2 style="margin:0; font-weight:900;">BÁO CÁO <span>HỆ THỐNG</span></h2>
    </div>
    
    <%-- THỐNG KÊ TỔNG QUAN --%>
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon bg-blue"><i class="fa-solid fa-coins"></i></div>
            <div class="stat-info">
                <h3>Thực thu (Đã giao)</h3>
                <p><asp:Literal ID="litRevenue" runat="server" Text="0"></asp:Literal> đ</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-green"><i class="fa-solid fa-boxes-packing"></i></div>
            <div class="stat-info">
                <h3>Tổng đơn hàng</h3>
                <p><asp:Literal ID="litOrders" runat="server" Text="0"></asp:Literal></p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-purple"><i class="fa-solid fa-book"></i></div>
            <div class="stat-info">
                <h3>Sản phẩm kho</h3>
                <p><asp:Literal ID="litBooks" runat="server" Text="0"></asp:Literal></p>
            </div>
        </div>
    </div>

    <div class="dashboard-main">
        <%-- BIỂU ĐỒ --%>
        <div class="chart-container">
            <div class="table-title"><i class="fa-solid fa-chart-area"></i> Biểu đồ doanh thu 7 ngày qua</div>
            <div style="height: 350px;">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>

        <%-- DANH SÁCH GIAO DỊCH GẦN NHẤT --%>
        <div class="recent-table">
            <div class="table-title"><i class="fa-solid fa-receipt"></i> Giao dịch gần nhất</div>
            <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="False" CssClass="table-custom" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="SoDH" HeaderText="MÃ" />
                    <asp:BoundField DataField="HoTenKH" HeaderText="KHÁCH HÀNG" />
                    <asp:BoundField DataField="Trigia" HeaderText="GIÁ TRỊ" DataFormatString="{0:#,##0}đ" ItemStyle-Font-Bold="true" />
                    <asp:TemplateField HeaderText="TRẠNG THÁI">
                        <ItemTemplate>
                            <%# (bool)Eval("Dagiao") ? 
                                "<span style='color:#10b981;'><i class='fa-solid fa-circle-check'></i></span>" : 
                                "<span style='color:#f59e0b;'><i class='fa-solid fa-circle-pause'></i></span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <script>
        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: [<%= ChartLabels %>], 
                datasets: [{
                    label: 'Doanh thu',
                    data: [<%= ChartData %>],
                    borderColor: '#ff4081',
                    backgroundColor: 'rgba(255, 64, 129, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 5,
                    pointBackgroundColor: '#fff',
                    pointBorderColor: '#ff4081',
                    pointBorderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, ticks: { font: { size: 11 } } },
                    x: { ticks: { font: { size: 11 } }, grid: { display: false } }
                }
            }
        });
    </script>
</asp:Content>