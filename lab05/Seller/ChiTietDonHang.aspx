<%@ Page Title="Chi tiết đơn hàng" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="ChiTietDonHang.aspx.cs" Inherits="lab05.Seller.ChiTietDonHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary-pink: #ff4081; --success-green: #10b981; --indigo: #6366f1; }
        .detail-card { background: white; padding: 40px; border-radius: 30px; box-shadow: 0 10px 50px rgba(0,0,0,0.1); max-width: 1100px; margin: 20px auto; position: relative; }
        
        /* HEADER THÔNG TIN */
        .info-header { display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; border-bottom: 2px dashed #f1f5f9; padding-bottom: 30px; margin-bottom: 30px; align-items: center; }
        .order-status-tag { display: inline-block; padding: 6px 15px; border-radius: 8px; font-weight: 800; font-size: 11px; text-transform: uppercase; margin-bottom: 10px; }
        .tag-waiting { background: #fff7ed; color: #ea580c; }
        .tag-done { background: #f0fdf4; color: #16a34a; }

        /* GRIDVIEW STYLE */
        .gv-style { width: 100%; border-collapse: collapse; }
        .gv-style th { background: #f8fafc; padding: 15px; text-align: left; color: #64748b; font-size: 12px; text-transform: uppercase; border-bottom: 2px solid #f1f5f9; }
        .gv-style td { padding: 20px 15px; border-bottom: 1px solid #f1f5f9; font-size: 15px; }

        .txt-edit { padding: 10px; border: 2px solid #f1f5f9; border-radius: 12px; font-weight: 800; color: var(--primary-pink); outline: none; transition: 0.3s; width: 85px; text-align: center; }
        .txt-edit:focus { border-color: var(--primary-pink); box-shadow: 0 0 0 4px rgba(255, 64, 129, 0.1); }
        .txt-date { padding: 10px; border: 2px solid #f1f5f9; border-radius: 12px; color: #1e293b; font-weight: 600; background: #fffcfd; }

        /* BUTTON GROUP */
        .btn-group { margin-top: 45px; display: flex; justify-content: center; gap: 15px; flex-wrap: wrap; }
        .btn-main { padding: 16px 35px; border-radius: 50px; font-weight: 800; cursor: pointer; border: none; text-decoration: none; display: inline-flex; align-items: center; gap: 10px; transition: 0.3s; font-size: 13px; }
        .btn-save { background: var(--primary-pink); color: white !important; box-shadow: 0 10px 25px rgba(255, 64, 129, 0.3); }
        .btn-save:hover { transform: translateY(-3px); filter: brightness(1.1); }
        .btn-back { background: #f1f5f9; color: #475569 !important; }
        .btn-back:hover { background: #e2e8f0; }
        
        /* MỚI: NÚT IN */
        .btn-print { background: var(--indigo); color: white !important; box-shadow: 0 10px 25px rgba(99, 102, 241, 0.3); }
        .btn-print:hover { transform: translateY(-3px); filter: brightness(1.1); }

        /* KHÓA DỮ LIỆU NHƯNG KHÔNG KHÓA NÚT QUAY LẠI */
        .order-locked-ui { filter: grayscale(0.5); opacity: 0.8; pointer-events: none; }
        .order-locked-ui input, .order-locked-ui select { cursor: not-allowed; }

        /* MODAL THÔNG BÁO */
        .notify-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(5px); display: none; align-items: center; justify-content: center; z-index: 10000; }
        .notify-overlay.active { display: flex; }
        .notify-content { background: white; padding: 40px; border-radius: 30px; text-align: center; max-width: 420px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.2); }

        /* --- CSS PRINT: THIẾT KẾ CHO BẢN IN PDF --- */
        @media print {
            .sidebar, .top-bar, .btn-group, .notify-overlay { display: none !important; }
            body { background: white !important; }
            .main-content { margin-left: 0 !important; width: 100% !important; }
            .detail-card { box-shadow: none !important; border: none !important; padding: 0 !important; width: 100% !important; max-width: 100% !important; }
            .info-header { border-bottom: 2px solid #000 !important; }
            .gv-style th { background: #eee !important; color: #000 !important; border-bottom: 1px solid #000 !important; }
            .gv-style td { border-bottom: 1px solid #eee !important; }
            .txt-edit { border: none !important; background: transparent !important; }
            .order-locked-ui { filter: none !important; opacity: 1 !important; }
        }
    </style>

    <script>
        function calculateLive() {
            let totalOrder = 0;
            const rows = document.querySelectorAll('.gv-style tr:not(:first-child)');
            rows.forEach(row => {
                const input = row.querySelector('.txt-edit');
                const rowTotalLabel = row.querySelector('.row-total-label');
                if (input && rowTotalLabel) {
                    const price = parseFloat(input.getAttribute('data-price'));
                    let qty = parseInt(input.value) || 0;
                    if (qty < 1) { qty = 1; input.value = 1; }
                    const totalRow = qty * price;
                    totalOrder += totalRow;
                    rowTotalLabel.innerText = totalRow.toLocaleString('vi-VN') + 'đ';
                }
            });
            const grandTotalLabel = document.querySelector('.grand-total-label');
            if (grandTotalLabel) grandTotalLabel.innerText = totalOrder.toLocaleString('vi-VN');
        }

        function showNotify(msg) {
            document.getElementById('notifyMsg').innerText = msg;
            document.getElementById('notifyModal').classList.add('active');
        }
        function closeNotify() { document.getElementById('notifyModal').classList.remove('active'); }

        // HÀM IN TRANG
        function printInvoice() { window.print(); }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="detail-card">
        
        <%-- KHU VỰC THÔNG TIN (Sẽ bị khóa nếu đã giao) --%>
        <div id="divMainInfo" runat="server">
            <div class="info-header">
                <div>
                    <span class='<%= IsDelivered ? "order-status-tag tag-done" : "order-status-tag tag-waiting" %>'>
                        <i class='<%= IsDelivered ? "fa-solid fa-circle-check" : "fa-solid fa-clock" %>'></i>
                        <%= IsDelivered ? "Đơn hàng đã hoàn tất" : "Đơn hàng đang xử lý" %>
                    </span>
                    <h1 style="margin:0; font-weight:900; font-size:2.4rem; color:#1e293b;">HÓA ĐƠN #<asp:Literal ID="litOrderID" runat="server" /></h1>
                    <div style="margin-top:15px; color:#64748b; font-size:1.1rem;">
                        <i class="fa-solid fa-user-circle"></i> Khách hàng: <b style="color:#1e293b;"><asp:Literal ID="litCustomerName" runat="server" /></b>
                    </div>
                    <div style="margin-top:10px;">
                        <i class="fa-solid fa-truck-clock"></i> Ngày dự kiến giao: 
                        <asp:TextBox ID="txtDeliveryDate" runat="server" TextMode="Date" CssClass="txt-date"></asp:TextBox>
                    </div>
                </div>
                <div style="text-align:right;">
                    <div style="font-size:12px; color:#94a3b8; font-weight:800; text-transform:uppercase;">Thành tiền</div>
                    <div style="color:var(--primary-pink); font-size:3.2rem; font-weight:900;">
                        <span class="grand-total-label"><asp:Literal ID="litTotal" runat="server" /></span> <small style="font-size:1.5rem;">đ</small>
                    </div>
                </div>
            </div>

            <asp:GridView ID="gvDetails" runat="server" AutoGenerateColumns="False" CssClass="gv-style" 
                DataKeyNames="MaSach" GridLines="None" OnRowDataBound="gvDetails_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="Thông tin sách">
                        <ItemTemplate>
                            <div style="display:flex; align-items:center; gap:20px;">
                                <img src='<%# Page.ResolveUrl("~/Images/" + Eval("AnhBia")) %>' style="width:55px; height:80px; object-fit:cover; border-radius:10px; box-shadow:0 8px 20px rgba(0,0,0,0.1);" />
                                <div>
                                    <div style="font-weight:800; color:#1e293b; font-size:1.1rem;"><%# Eval("TenSach") %></div>
                                    <div style="font-size:12px; color:#94a3b8;">Mã SKU: BK-<%# Eval("MaSach") %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Dongia" HeaderText="Đơn giá" DataFormatString="{0:#,##0}đ" ItemStyle-Font-Bold="true" />
                    <asp:TemplateField HeaderText="Số lượng">
                        <ItemTemplate>
                            <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Soluong") %>' 
                                CssClass="txt-edit" TextMode="Number" min="1"
                                oninput="calculateLive()" data-price='<%# Eval("Dongia") %>'></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Thành tiền">
                        <ItemTemplate>
                            <b class="row-total-label" style="color:var(--primary-pink); font-size:1.1rem;">
                                <%# string.Format("{0:#,##0}đ", Eval("Thanhtien")) %>
                            </b>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <%-- KHU VỰC NÚT BẤM (Luôn luôn sáng) --%>
        <div class="btn-group">
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Seller/QLDonHang.aspx" CssClass="btn-main btn-back">
                <i class="fa-solid fa-circle-arrow-left"></i> QUAY LẠI DANH SÁCH
            </asp:HyperLink>
            
            <button type="button" class="btn-main btn-print" onclick="printInvoice()">
                <i class="fa-solid fa-print"></i> IN HÓA ĐƠN (PDF)
            </button>

            <asp:LinkButton ID="btnSave" runat="server" CssClass="btn-main btn-save" OnClick="btnSave_Click">
                <i class="fa-solid fa-floppy-disk"></i> LƯU THAY ĐỔI DỮ LIỆU
            </asp:LinkButton>
        </div>
    </div>

    <%-- MODAL --%>
    <div id="notifyModal" class="notify-overlay">
        <div class="notify-content">
            <div style="font-size:4rem; color:var(--success-green); margin-bottom:20px;"><i class="fa-solid fa-circle-check"></i></div>
            <h2 style="font-weight:900; color:#1e293b;">Thành công!</h2>
            <p id="notifyMsg" style="color:#64748b; margin:20px 0 30px; line-height:1.6;"></p>
            <button type="button" class="btn-main btn-save" style="width:100%; justify-content:center;" onclick="closeNotify()">XÁC NHẬN</button>
        </div>
    </div>
</asp:Content>