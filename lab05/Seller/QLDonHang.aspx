<%@ Page Title="Quản lý đơn hàng" Language="C#" MasterPageFile="~/Seller/Seller.Master" AutoEventWireup="true" CodeBehind="QLDonHang.aspx.cs" Inherits="lab05.Admin.QLDonHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .table-card { background: white; padding: 30px; border-radius: 24px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
        .gv-orders { width: 100%; border-collapse: collapse; }
        .gv-orders th { background: #f8fafc; color: #64748b; font-size: 11px; font-weight: 800; text-transform: uppercase; padding: 15px; border-bottom: 2px solid #f1f5f9; text-align: left; }
        .gv-orders td { padding: 15px; border-bottom: 1px solid #f1f5f9; font-size: 14px; vertical-align: middle; }
        
        .badge { padding: 6px 12px; border-radius: 50px; font-size: 10px; font-weight: 700; text-transform: uppercase; display: inline-flex; align-items: center; gap: 5px; }
        .bg-delivered { background: #dcfce7; color: #166534; }
        .bg-waiting { background: #fef3c7; color: #92400e; }

        .delay-box { display: flex; flex-direction: column; gap: 8px; max-width: 190px; background: #fff1f2; padding: 12px; border-radius: 12px; border: 1px solid #ffe4e6; margin-top: 10px; }
        .date-input { width: 100%; padding: 7px; border: 1px solid #fb7185; border-radius: 8px; font-size: 12px; outline: none; background: white; font-family: inherit; }
        
        .btn-small { padding: 8px 12px; border-radius: 8px; font-size: 11px; font-weight: 700; cursor: pointer; border: none; transition: 0.2s; text-decoration: none; text-align: center; display: inline-block; }
        .btn-delay-apply { background: #e11d48; color: white !important; }
        .btn-done { background: #10b981; color: white !important; padding: 10px 18px; border-radius: 10px; border: none; }

        /* --- TOAST NOTIFICATION --- */
        #toastBox {
            position: fixed; bottom: -100px; left: 50%; transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(10px); color: #fff;
            padding: 16px 35px; border-radius: 16px; z-index: 10000;
            display: flex; align-items: center; gap: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.1); font-weight: 600;
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        #toastBox.active { bottom: 40px; }
        #toastBox i { color: #10b981; font-size: 1.2rem; }

        /* --- CUSTOM CONFIRM MODAL --- */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4); backdrop-filter: blur(4px);
            display: none; align-items: center; justify-content: center; z-index: 11000;
            opacity: 0; transition: 0.3s;
        }
        .modal-overlay.active { display: flex; opacity: 1; }
        .modal-content {
            background: white; padding: 35px; border-radius: 24px; max-width: 400px; width: 90%;
            text-align: center; box-shadow: 0 25px 50px rgba(0,0,0,0.2);
            transform: scale(0.9); transition: 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .modal-overlay.active .modal-content { transform: scale(1); }
        .modal-icon { width: 65px; height: 65px; background: #ecfdf5; color: #10b981; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 28px; margin: 0 auto 20px; }
        
        .modal-actions { display: flex; gap: 12px; margin-top: 25px; }
        .btn-modal { padding: 12px 20px; border-radius: 12px; font-weight: 700; border: none; cursor: pointer; transition: 0.2s; flex: 1; font-size: 14px; }
        .btn-confirm { background: #10b981; color: white; }
        .btn-cancel { background: #f1f5f9; color: #475569; }
    </style>

    <script>
        function showToast(message) {
            var toast = document.getElementById("toastBox");
            toast.innerHTML = "<i class='fa-solid fa-circle-check'></i> " + message;
            toast.classList.add("active");
            setTimeout(function () { toast.classList.remove("active"); }, 3000);
        }

        function openConfirmModal(soDH) {
            document.getElementById('<%= hfSelectedOrder.ClientID %>').value = soDH;
            document.getElementById('confirmModal').classList.add('active');
        }

        function closeConfirmModal() {
            document.getElementById('confirmModal').classList.remove('active');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <%-- MODAL XÁC NHẬN CHỐT ĐƠN --%>
    <div id="confirmModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-icon"><i class="fa-solid fa-truck-check"></i></div>
            <h3 style="font-weight:800; color:#1e293b; margin-bottom:10px;">Xác nhận hoàn tất?</h3>
            <p style="color:#64748b; font-size:14px; line-height:1.6;">Bạn có chắc chắn đơn hàng này đã được giao thành công cho khách hàng?</p>
            <div class="modal-actions">
                <button type="button" class="btn-modal btn-cancel" onclick="closeConfirmModal()">Quay lại</button>
                <asp:Button ID="btnFinalDone" runat="server" Text="Chốt đơn ngay" CssClass="btn-modal btn-confirm" OnClick="btnFinalDone_Click" />
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hfSelectedOrder" runat="server" />


    <div class="header-title">
        <i class="fa-solid fa-truck-ramp-box"></i>
        <h2>Điều phối <span>Vận chuyển</span></h2>
    </div>

    <div class="table-card">
        <asp:UpdatePanel ID="upOrders" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
                    CssClass="gv-orders" GridLines="None" OnRowCommand="gvOrders_RowCommand" 
                    DataKeyNames="SoDH">
                    <Columns>
                        <asp:BoundField DataField="SoDH" HeaderText="Mã ĐH" ItemStyle-Font-Bold="true" />
                        
                        <asp:TemplateField HeaderText="Khách hàng">
                            <ItemTemplate>
                                <div style="font-weight:700; color:#1e293b;"><%# Eval("HoTenKH") %></div>
                                <div style="font-size:12px; color:#64748b;"><i class="fa-solid fa-phone"></i> <%# Eval("Dienthoai") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Lịch trình & Hoãn">
                            <ItemTemplate>
                                <div style="color:#1e293b; font-weight:700; margin-bottom:5px;">
                                    <i class="fa-regular fa-calendar-check"></i> <%# Eval("Ngaygiao", "{0:dd/MM/yyyy}") %>
                                </div>
                                <asp:Panel ID="pnlDelayForm" runat="server" Visible='<%# !(bool)Eval("Dagiao") %>' CssClass="delay-box">
                                    <span style="font-size:10px; font-weight:900; color:#e11d48;">NGÀY HOÃN MỚI:</span>
                                    <asp:TextBox ID="txtNewDate" runat="server" TextMode="Date" CssClass="date-input"></asp:TextBox>
                                    <asp:LinkButton ID="btnHoan" runat="server" CommandName="HoanDon" 
                                        CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn-small btn-delay-apply">
                                        <i class="fa-solid fa-clock-rotate-left"></i> XÁC NHẬN HOÃN
                                    </asp:LinkButton>
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Tình trạng">
                            <ItemTemplate>
                                <span class='<%# (bool)Eval("Dagiao") ? "badge bg-delivered" : "badge bg-waiting" %>'>
                                    <i class='<%# (bool)Eval("Dagiao") ? "fa-solid fa-circle-check" : "fa-solid fa-truck-fast" %>'></i>
                                    <%# (bool)Eval("Dagiao") ? "Đã hoàn tất" : "Đang chờ giao" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <%-- GỌI MODAL THAY VÌ CONFIRM CỦA HTML --%>
                                <asp:LinkButton ID="btnConfirmDone" runat="server" CssClass="btn-small btn-done"
                                    Visible='<%# !(bool)Eval("Dagiao") %>'
                                    OnClientClick='<%# "openConfirmModal(" + Eval("SoDH") + "); return false;" %>'>
                                    <i class="fa-solid fa-check"></i> CHỐT ĐƠN
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="text-align:center; padding:50px; color:#94a3b8;">Hiện không có đơn hàng nào cần điều phối.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>