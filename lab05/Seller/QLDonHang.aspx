<%@ Page Title="Quản lý đơn hàng" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="QLDonHang.aspx.cs" Inherits="lab05.Seller.QLDonHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary-pink: #ff4081; --primary-blue: #3b82f6; --success-green: #10b981; }
        body { font-size: 14px; }
        .table-card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); border: 1px solid #f1f5f9; }
        .action-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        h2 { font-size: 1.4rem !important; font-weight: 900; margin: 0; text-transform: uppercase; color: #1e293b; letter-spacing: 0.5px; }
        .search-box { display: flex; align-items: center; background: white; border: 2px solid #e2e8f0; border-radius: 12px; padding: 5px 15px; width: 420px; transition: 0.3s; }
        .search-box:focus-within { border-color: var(--primary-pink); box-shadow: 0 0 0 4px rgba(255, 64, 129, 0.1); }
        .search-input { border: none; outline: none; padding: 10px; width: 100%; font-size: 14px; }
        .btn-search-icon { color: #94a3b8; background: none; border: none; cursor: pointer; font-size: 18px; }
        .gv-full { width: 100%; border-collapse: collapse; }
        .gv-full th { background: #fdf2f8; color: #64748b; padding: 15px 20px; text-align: left; font-size: 11px; text-transform: uppercase; border-bottom: 2px solid #ffeff7; }
        .gv-full td { padding: 18px 20px; border-bottom: 1px solid #f1f5f9; font-size: 14.5px; color: #334155; }
        .badge { padding: 6px 14px; border-radius: 8px; font-size: 11px; font-weight: 800; text-transform: uppercase; }
        .bg-waiting { background: #fff7ed; color: #ea580c; border: 1px solid #ffedd5; }
        .bg-done { background: #f0fdf4; color: #16a34a; border: 1px solid #dcfce7; }
        .btn-detail-full { background: #f1f5f9; color: #1e293b !important; padding: 10px 18px; border-radius: 10px; text-decoration: none; font-weight: 800; font-size: 12px; display: inline-flex; align-items: center; gap: 8px; transition: 0.3s; border: none; cursor: pointer; }
        .btn-detail-full:hover { background: #e2e8f0; transform: translateY(-2px); }
        
        /* MỚI: Style cho nút Xác nhận giao hàng */
        .btn-confirm-delivery { background: var(--success-green); color: white !important; padding: 10px 18px; border-radius: 10px; font-weight: 800; font-size: 12px; border: none; cursor: pointer; transition: 0.3s; }
        .btn-confirm-delivery:hover { filter: brightness(1.1); box-shadow: 0 5px 15px rgba(16, 185, 129, 0.3); }

        .pagination-wrapper { display: flex; justify-content: center; gap: 8px; margin-top: 30px; align-items: center; }
        .page-node { text-decoration: none; padding: 8px 16px; border-radius: 10px; background: white; color: #64748b; font-weight: 800; transition: 0.3s; border: 2px solid #e2e8f0; font-size: 13px; min-width: 45px; text-align: center; }
        .page-node.active { background: var(--primary-pink); color: white; border-color: var(--primary-pink); box-shadow: 0 8px 20px rgba(255, 64, 129, 0.3); }
        .page-nav-trigger { color: #cbd5e1; font-size: 1.4rem; padding: 0 10px; transition: 0.3s; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upOrders" runat="server">
        <ContentTemplate>
            <div class="action-bar">
                <h2>BẢNG ĐIỀU KHIỂN <span style="color:var(--primary-pink);">ĐƠN HÀNG</span></h2>
                <div class="search-box">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Nhập mã đơn hoặc tên khách hàng..." CssClass="search-input" AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn-search-icon" OnClick="btnSearch_Click"><i class="fa-solid fa-magnifying-glass"></i></asp:LinkButton>
                </div>
            </div>

            <div class="table-card">
                <%-- BỔ SUNG OnRowCommand ĐỂ XỬ LÝ NÚT XÁC NHẬN --%>
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" CssClass="gv-full" 
                    DataKeyNames="SoDH" GridLines="None" OnRowCommand="gvOrders_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="SoDH" HeaderText="Mã số ĐH" ItemStyle-Font-Bold="true" />
                        <asp:TemplateField HeaderText="Khách hàng">
                            <ItemTemplate>
                                <div style="font-weight: 700; color: #1e293b;"><%# Eval("HoTenKH") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="NgayDH" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:TemplateField HeaderText="Tổng tiền">
                            <ItemTemplate>
                                <b style="color:var(--primary-pink); font-size: 1.1rem;"><%# string.Format("{0:#,##0}", Eval("Trigia")) %>đ</b>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Trạng thái">
                            <ItemTemplate>
                                <span class='<%# (bool)Eval("Dagiao") ? "badge bg-done" : "badge bg-waiting" %>'>
                                    <%# (bool)Eval("Dagiao") ? "Đã hoàn tất" : "Đang xử lý" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <div style="display:flex; gap:10px;">
                                    <%-- NÚT XÁC NHẬN GIAO: Chỉ hiện khi Đang xử lý (Dagiao = false) --%>
                                    <asp:LinkButton ID="btnConfirm" runat="server" 
                                        CommandName="ConfirmDelivery" 
                                        CommandArgument='<%# Eval("SoDH") %>'
                                        CssClass="btn-confirm-delivery"
                                        Visible='<%# !(bool)Eval("Dagiao") %>'
                                        OnClientClick="return confirm('Bạn có chắc chắn muốn xác nhận giao hàng cho đơn này? Hệ thống sẽ tự động trừ tồn kho của sản phẩm.');">
                                        <i class="fa-solid fa-truck-ramp-box"></i> GIAO HÀNG
                                    </asp:LinkButton>

                                    <asp:HyperLink ID="lnkView" runat="server" 
                                        NavigateUrl='<%# "ChiTietDonHang.aspx?id=" + Eval("SoDH") %>' CssClass="btn-detail-full">
                                        <i class="fa-solid fa-file-invoice-dollar"></i> CHI TIẾT
                                    </asp:HyperLink>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <div class="pagination-wrapper">
                    <asp:HyperLink ID="lnkFirst" runat="server" CssClass="page-nav-trigger" ToolTip="Trang đầu"><i class="fa-solid fa-angles-left"></i></asp:HyperLink>
                    <asp:HyperLink ID="lnkPrev" runat="server" CssClass="page-nav-trigger" ToolTip="Trang trước"><i class="fa-solid fa-chevron-left"></i></asp:HyperLink>
                    <asp:Repeater ID="rptPaging" runat="server">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkPage" runat="server" 
                                NavigateUrl='<%# GetPageUrl(Eval("PageIndex")) %>'
                                Text='<%# Eval("PageText") %>'
                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "page-node active" : "page-node" %>'>
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:HyperLink ID="lnkNext" runat="server" CssClass="page-nav-trigger" ToolTip="Trang sau"><i class="fa-solid fa-chevron-right"></i></asp:HyperLink>
                    <asp:HyperLink ID="lnkLast" runat="server" CssClass="page-nav-trigger" ToolTip="Trang cuối"><i class="fa-solid fa-angles-right"></i></asp:HyperLink>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>