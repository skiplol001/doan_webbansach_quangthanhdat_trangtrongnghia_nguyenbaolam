<%@ Page Title="Quản lý tài khoản" Language="C#" MasterPageFile="~/Seller/Seller.Master" AutoEventWireup="true" CodeBehind="QLTaiKhoan.aspx.cs" Inherits="lab05.Admin.QLTaiKhoan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --seller-primary: #ff4081; --primary-blue: #3b82f6; }

        /* PHÓNG TO GIAO DIỆN 120% [cite: 2026-03-11] */
        body { font-size: 14.5px; } 
        .table-card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); border: 1px solid #f1f5f9; }
        
        .account-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .account-header h2 { font-weight: 900; color: #1e293b; margin: 0; text-transform: uppercase; font-size: 1.4rem !important; display: flex; align-items: center; gap: 12px; }

        .search-box { display: flex; align-items: center; background: white; border: 2px solid #e2e8f0; border-radius: 12px; padding: 5px 15px; width: 420px; transition: 0.3s; }
        .search-box:focus-within { border-color: var(--seller-primary); box-shadow: 0 0 0 4px rgba(255, 64, 129, 0.1); }
        .search-input { border: none; outline: none; padding: 10px; width: 100%; font-size: 14px; }
        .btn-search { color: #94a3b8; background: none; border: none; cursor: pointer; font-size: 18px; }

        .gv-accounts { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .gv-accounts th { background: #f8fafc; color: #64748b; font-size: 11px; font-weight: 800; text-transform: uppercase; padding: 18px 20px; border-bottom: 2px solid #f1f5f9; text-align: left; }
        .gv-accounts td { padding: 18px 20px; border-bottom: 1px solid #f1f5f9; font-size: 15px; vertical-align: middle; }

        /* Trạng thái Online/Offline */
        .status-dot { width: 12px; height: 12px; border-radius: 50%; display: inline-block; margin-right: 10px; }
        .dot-online { background: #10b981; box-shadow: 0 0 12px rgba(16, 185, 129, 0.5); }
        .dot-offline { background: #cbd5e1; }
        
        .badge-role { padding: 6px 12px; border-radius: 8px; font-size: 11px; font-weight: 800; text-transform: uppercase; }
        .role-admin { background: #eef2ff; color: #4338ca; border: 1px solid #e0e7ff; }
        .role-user { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }

        /* PHÂN TRANG REPEATER SLIDING WINDOW */
        .pagination-wrapper { display: flex; justify-content: center; gap: 8px; margin-top: 30px; align-items: center; }
        .page-node { text-decoration: none; padding: 8px 18px; border-radius: 10px; background: white; color: #64748b; font-weight: 800; transition: 0.3s; border: 2px solid #e2e8f0; font-size: 13px; min-width: 45px; text-align: center; }
        .page-node.active { background: var(--seller-primary); color: white; border-color: var(--seller-primary); box-shadow: 0 8px 20px rgba(255, 64, 129, 0.3); }
        .page-nav { color: #cbd5e1; font-size: 1.4rem; padding: 0 10px; transition: 0.3s; text-decoration: none; }
        .page-nav:hover:not(.disabled) { color: var(--seller-primary); }
        .disabled { opacity: 0.3; pointer-events: none; }

        #toastBox { position: fixed; bottom: -100px; left: 50%; transform: translateX(-50%); background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(10px); color: #fff; padding: 18px 40px; border-radius: 50px; z-index: 10000; display: flex; align-items: center; gap: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3); transition: 0.5s; font-weight: 600; }
        #toastBox.active { bottom: 40px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <div class="account-header">
        <h2><i class="fa-solid fa-users-viewfinder"></i> QUẢN TRỊ <span>THÀNH VIÊN</span></h2>
        
        <div class="search-box">
            <asp:TextBox ID="txtSearch" runat="server" placeholder="Tìm tên hoặc email..." CssClass="search-input" AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
            <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn-search" OnClick="btnSearch_Click">
                <i class="fa-solid fa-magnifying-glass"></i>
            </asp:LinkButton>
        </div>
    </div>

    <div class="table-card">
        <asp:UpdatePanel ID="upAccounts" runat="server">
            <ContentTemplate>
                <asp:Timer ID="tmrRefresh" runat="server" Interval="30000" OnTick="tmrRefresh_Tick"></asp:Timer>
                
                <asp:GridView ID="gvAccounts" runat="server" AutoGenerateColumns="False" 
                    CssClass="gv-accounts" GridLines="None" DataKeyNames="MaKH">
                    <Columns>
                        <asp:TemplateField HeaderText="Người dùng">
                            <ItemTemplate>
                                <div style="display:flex; align-items:center; gap:12px;">
                                    <div style="width:42px; height:42px; border-radius:50%; background:#fdf2f8; display:flex; align-items:center; justify-content:center; color:var(--seller-primary); font-weight:900; border:1px solid #ffeff7;">
                                        <%# Eval("HoTenKH").ToString().Substring(0,1).ToUpper() %>
                                    </div>
                                    <div>
                                        <div style="font-weight:800; color:#1e293b;"><%# Eval("HoTenKH") %></div>
                                        <div style="font-size:12px; color:#94a3b8;">@<%# Eval("TenDN") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Email" HeaderText="Email" />

                        <asp:TemplateField HeaderText="Vai trò">
                            <ItemTemplate>
                                <span class='<%# Eval("MaRole").ToString() == "2" ? "badge-role role-admin" : "badge-role role-user" %>'>
                                    <%# Eval("MaRole").ToString() == "2" ? "ADMIN" : "CUSTOMER" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Trạng thái">
                            <ItemTemplate>
                                <%-- GỌI HÀM IsUserOnline TỪ CODE BEHIND ĐỂ FIX LỖI DBNULL --%>
                                <div style="display:flex; align-items:center;">
                                    <span class='<%# IsUserOnline(Eval("IsOnline")) ? "status-dot dot-online" : "status-dot dot-offline" %>'></span>
                                    <b style='<%# IsUserOnline(Eval("IsOnline")) ? "color:#10b981;" : "color:#64748b;" %>'>
                                        <%# IsUserOnline(Eval("IsOnline")) ? "Đang hoạt động" : "Ngoại tuyến" %>
                                    </b>
                                </div>
                                <div style="font-size:11px; color:#94a3b8; margin-top:4px; margin-left:22px;">
                                    <%# Eval("LastSeen") != DBNull.Value ? "Lần cuối: " + Eval("LastSeen", "{0:dd/MM HH:mm}") : "" %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnPing" runat="server" OnClientClick="showToast('Đã gửi yêu cầu kiểm tra!'); return false;" 
                                    Style="color:var(--primary-blue); font-size:13px; font-weight:800; text-decoration:none;">
                                    <i class="fa-solid fa-satellite-dish"></i> KIỂM TRA
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <div class="pagination-wrapper">
                    <asp:HyperLink ID="lnkFirst" runat="server" CssClass="page-nav"><i class="fa-solid fa-angles-left"></i></asp:HyperLink>
                    <asp:HyperLink ID="lnkPrev" runat="server" CssClass="page-nav"><i class="fa-solid fa-chevron-left"></i></asp:HyperLink>
                    <asp:Repeater ID="rptPaging" runat="server">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkPage" runat="server" 
                                NavigateUrl='<%# GetPageUrl(Eval("PageIndex")) %>'
                                Text='<%# Eval("PageText") %>'
                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "page-node active" : "page-node" %>'>
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:HyperLink ID="lnkNext" runat="server" CssClass="page-nav"><i class="fa-solid fa-chevron-right"></i></asp:HyperLink>
                    <asp:HyperLink ID="lnkLast" runat="server" CssClass="page-nav"><i class="fa-solid fa-angles-right"></i></asp:HyperLink>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <script>
        function showToast(m) {
            var t = document.getElementById("toastBox");
            t.innerHTML = "<i class='fa-solid fa-circle-check' style='color:#10b981;'></i> " + m;
            t.classList.add("active");
            setTimeout(() => t.classList.remove("active"), 3000);
        }
    </script>
</asp:Content>