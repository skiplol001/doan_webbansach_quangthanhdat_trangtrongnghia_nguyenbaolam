<%@ Page Title="Chi tiết đơn hàng" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="ChiTietDonHang.aspx.cs" Inherits="lab05.Seller.ChiTietDonHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary-pink: #ff4081; --success-green: #10b981; }
        .detail-card { background: white; padding: 40px; border-radius: 30px; box-shadow: 0 10px 50px rgba(0,0,0,0.1); max-width: 1100px; margin: 20px auto; }
        .info-header { display: grid; grid-template-columns: 1.5fr 1fr; gap: 30px; border-bottom: 2px dashed #f1f5f9; padding-bottom: 30px; margin-bottom: 30px; align-items: center; }
        
        .gv-style { width: 100%; border-collapse: collapse; }
        .gv-style th { background: #f8fafc; padding: 15px; text-align: left; color: #64748b; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; border-bottom: 2px solid #f1f5f9; }
        .gv-style td { padding: 20px 15px; border-bottom: 1px solid #f1f5f9; font-size: 15px; }

        .txt-edit { padding: 10px; border: 2px solid #f1f5f9; border-radius: 12px; font-weight: 800; color: var(--primary-pink); outline: none; transition: 0.3s; width: 85px; text-align: center; }
        .txt-edit:focus { border-color: var(--primary-pink); box-shadow: 0 0 0 4px rgba(255, 64, 129, 0.1); }
        .txt-date { padding: 10px; border: 2px solid #f1f5f9; border-radius: 12px; color: #1e293b; font-weight: 600; }

        /* MODAL THÔNG BÁO CUSTOM */
        .notify-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(5px); display: none; align-items: center; justify-content: center; z-index: 10000; }
        .notify-overlay.active { display: flex; }
        .notify-content { background: white; padding: 40px; border-radius: 30px; text-align: center; max-width: 420px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.2); }
        .notify-icon { font-size: 4.5rem; color: var(--success-green); margin-bottom: 20px; }

        .btn-group { margin-top: 45px; display: flex; justify-content: center; gap: 20px; }
        .btn-main { padding: 16px 45px; border-radius: 50px; font-weight: 800; cursor: pointer; border: none; text-decoration: none; display: inline-flex; align-items: center; gap: 10px; transition: 0.3s; }
        .btn-save { background: var(--primary-pink); color: white !important; box-shadow: 0 10px 25px rgba(255, 64, 129, 0.3); }
        .btn-back { background: #f1f5f9; color: #1e293b !important; }
        
        .order-locked { filter: grayscale(1); opacity: 0.7; pointer-events: none; }
    </style>

    <script>
        // --- HÀM TÍNH TOÁN TIỀN TỨC THÌ (REAL-TIME) ---
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

        // --- HÀM HIỂN THỊ MODAL THÔNG BÁO ---
        function showNotify(msg) {
            document.getElementById('notifyMsg').innerText = msg;
            document.getElementById('notifyModal').classList.add('active');
        }
        function closeNotify() {
            document.getElementById('notifyModal').classList.remove('active');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="detail-card">
        <%-- Class order-locked sẽ tự thêm vào nếu IsDelivered = true --%>
        <div class='<%= IsDelivered ? "order-locked" : "" %>'>
            
            <div class="info-header">
                <div>
                    <h1 style="margin:0; font-weight:900; font-size:2.4rem; color:#1e293b;">HÓA ĐƠN #<asp:Literal ID="litOrderID" runat="server" /></h1>
                    <div style="margin-top:15px; color:#64748b; font-size:1.1rem;">
                        <i class="fa-solid fa-user-circle"></i> Khách hàng: <b style="color:#1e293b;"><asp:Literal ID="litCustomerName" runat="server" /></b>
                    </div>
                    <div style="margin-top:10px;">
                        <i class="fa-solid fa-truck-clock"></i> Cập nhật ngày giao: 
                        <asp:TextBox ID="txtDeliveryDate" runat="server" TextMode="Date" CssClass="txt-date"></asp:TextBox>
                    </div>
                </div>
                <div style="text-align:right;">
                    <div style="font-size:12px; color:#94a3b8; font-weight:800; text-transform:uppercase; letter-spacing:1px;">Tổng tiền thanh toán</div>
                    <div style="color:var(--primary-pink); font-size:3.2rem; font-weight:900;">
                        <span class="grand-total-label"><asp:Literal ID="litTotal" runat="server" /></span> <small style="font-size:1.5rem;">đ</small>
                    </div>
                </div>
            </div>

            <asp:GridView ID="gvDetails" runat="server" AutoGenerateColumns="False" CssClass="gv-style" 
                DataKeyNames="MaSach" GridLines="None" OnRowDataBound="gvDetails_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="Sản phẩm / Ấn phẩm">
                        <ItemTemplate>
                            <div style="display:flex; align-items:center; gap:20px;">
                                <img src='<%# Page.ResolveUrl("~/Images/" + Eval("AnhBia")) %>' style="width:55px; height:80px; object-fit:cover; border-radius:10px; box-shadow:0 8px 20px rgba(0,0,0,0.1);" />
                                <div>
                                    <div style="font-weight:800; color:#1e293b; font-size:1.1rem;"><%# Eval("TenSach") %></div>
                                    <div style="font-size:12px; color:#94a3b8; margin-top:5px;">Mã định danh: #<%# Eval("MaSach") %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Dongia" HeaderText="Đơn giá" DataFormatString="{0:#,##0}đ" ItemStyle-Font-Bold="true" ItemStyle-ForeColor="#64748b" />
                    <asp:TemplateField HeaderText="Số lượng">
                        <ItemTemplate>
                            <%-- ONINPUT: TÍNH TIỀN TỨC THÌ QUA JAVASCRIPT --%>
                            <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Soluong") %>' 
                                CssClass="txt-edit" TextMode="Number" min="1"
                                oninput="calculateLive()" data-price='<%# Eval("Dongia") %>'></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Thành tiền">
                        <ItemTemplate>
                            <b class="row-total-label" style="color:var(--primary-pink); font-size:1.2rem;">
                                <%# string.Format("{0:#,##0}đ", Eval("Thanhtien")) %>
                            </b>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <div class="btn-group">
                <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Seller/QLDonHang.aspx" CssClass="btn-main btn-back">
                    <i class="fa-solid fa-arrow-left-long"></i> QUAY LẠI DANH SÁCH
                </asp:HyperLink>
                <asp:LinkButton ID="btnSave" runat="server" CssClass="btn-main btn-save" OnClick="btnSave_Click">
                    <i class="fa-solid fa-cloud-arrow-up"></i> XÁC NHẬN LƯU DATABASE
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <%-- MODAL THÔNG BÁO THÀNH CÔNG --%>
    <div id="notifyModal" class="notify-overlay">
        <div class="notify-content">
            <div class="notify-icon"><i class="fa-solid fa-check-double"></i></div>
            <h2 style="font-weight:900; margin-bottom:12px; color:#1e293b;">Hoàn tất cập nhật!</h2>
            <p id="notifyMsg" style="color:#64748b; margin-bottom:35px; line-height:1.6;"></p>
            <button type="button" class="btn-main btn-save" style="width:100%; justify-content:center;" onclick="closeNotify()">XÁC NHẬN</button>
        </div>
    </div>
</asp:Content>