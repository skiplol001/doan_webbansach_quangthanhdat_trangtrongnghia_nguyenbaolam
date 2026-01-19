<%@ Page Title="Quản lý tài khoản" Language="C#" MasterPageFile="~/Seller/Seller.Master" AutoEventWireup="true" CodeBehind="QLTaiKhoan.aspx.cs" Inherits="lab05.Admin.QLTaiKhoan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .account-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .account-header h2 { font-weight: 800; color: #1e293b; margin: 0; display: flex; align-items: center; gap: 12px; }
        .account-header h2 i { color: var(--seller-primary); }

        .table-card { background: white; padding: 30px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }

        .gv-accounts { width: 100%; border-collapse: collapse; }
        .gv-accounts th { background: #f8fafc; color: #64748b; font-size: 11px; font-weight: 800; text-transform: uppercase; padding: 15px; border-bottom: 2px solid #f1f5f9; text-align: left; }
        .gv-accounts td { padding: 15px; border-bottom: 1px solid #f1f5f9; font-size: 14px; vertical-align: middle; }
        
        /* Badge Trạng thái */
        .status-dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; margin-right: 8px; }
        .dot-online { background: #10b981; box-shadow: 0 0 10px rgba(16, 185, 129, 0.5); }
        .dot-offline { background: #cbd5e1; }
        
        .badge-role { padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 700; }
        .role-admin { background: #eef2ff; color: #4338ca; }
        .role-user { background: #f1f5f9; color: #475569; }

        /* Toast thông báo */
        #toastBox {
            position: fixed; bottom: -100px; left: 50%; transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(10px); color: #fff;
            padding: 16px 35px; border-radius: 16px; z-index: 10000;
            display: flex; align-items: center; gap: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55); font-weight: 600;
        }
        #toastBox.active { bottom: 40px; }
    </style>
    <script>
        function showToast(message) {
            var toast = document.getElementById("toastBox");
            toast.innerHTML = "<i class='fa-solid fa-shield-check' style='color:#10b981;'></i> " + message;
            toast.classList.add("active");
            setTimeout(function () { toast.classList.remove("active"); }, 3000);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <div class="account-header">
        <h2><i class="fa-solid fa-users-gear"></i> KIỂM TRA <span>TÀI KHOẢN</span></h2>
    </div>

    <div class="table-card">
        <asp:UpdatePanel ID="upAccounts" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gvAccounts" runat="server" AutoGenerateColumns="False" 
                    CssClass="gv-accounts" GridLines="None" DataKeyNames="MaKH">
                    <Columns>
                        <%-- Thông tin cơ bản --%>
                        <asp:TemplateField HeaderText="Người dùng">
                            <ItemTemplate>
                                <div style="font-weight:700;"><%# Eval("HoTenKH") %></div>
                                <div style="font-size:12px; color:#94a3b8;">@<%# Eval("TenDN") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Email" HeaderText="Email" />

                        <%-- Vai trò --%>
                        <asp:TemplateField HeaderText="Vai trò">
                            <ItemTemplate>
                                <span class='<%# Eval("MaRole").ToString() == "2" ? "badge-role role-admin" : "badge-role role-user" %>'>
                                    <%# Eval("MaRole").ToString() == "2" ? "SELLER" : "CUSTOMER" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Trạng thái Online/Offline --%>
                        <asp:TemplateField HeaderText="Trạng thái">
                            <ItemTemplate>
                                <div style="display:flex; align-items:center;">
                                    <span class='<%# Convert.ToBoolean(Eval("IsOnline")) ? "status-dot dot-online" : "status-dot dot-offline" %>'></span>
                                    <span style='<%# Convert.ToBoolean(Eval("IsOnline")) ? "color:#10b981; font-weight:700;" : "color:#64748b;" %>'>
                                        <%# Convert.ToBoolean(Eval("IsOnline")) ? "Đang hoạt động" : "Ngoại tuyến" %>
                                    </span>
                                </div>
                                <div style="font-size:11px; color:#cbd5e1; margin-top:4px;">
                                    <%# Eval("LastSeen") != DBNull.Value ? "Lần cuối: " + Eval("LastSeen", "{0:dd/MM HH:mm}") : "" %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Thao tác --%>
                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnPing" runat="server" OnClientClick="showToast('Đã gửi yêu cầu kiểm tra tới hệ thống!'); return false;" 
                                    Style="color:#6366f1; font-size:12px; font-weight:700; text-decoration:none;">
                                    <i class="fa-solid fa-satellite-dish"></i> Kiểm tra
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="text-align:center; padding:40px; color:#94a3b8;">Chưa có tài khoản nào đăng ký.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>