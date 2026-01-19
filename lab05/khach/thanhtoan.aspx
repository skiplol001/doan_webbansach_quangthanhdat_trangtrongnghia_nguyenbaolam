<%@ Page Title="THANH TOÁN" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="thanhtoan.aspx.cs" Inherits="lab05.thanhtoan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary-color: #ff4081; --primary-dark: #f50057; --text-main: #0f172a;
            --text-muted: #64748b; --shadow-soft: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .checkout-container { display: grid; grid-template-columns: 1fr 400px; gap: 30px; max-width: 1200px; margin: 30px auto; align-items: start; }
        .checkout-card { background: white; padding: 35px; border-radius: 24px; box-shadow: var(--shadow-soft); border: 1px solid #f1f5f9; }
        .checkout-title { font-size: 1.4rem; font-weight: 800; color: var(--text-main); margin-bottom: 25px; display: flex; align-items: center; gap: 12px; }
        .checkout-title i { color: #ff00ff; }

        /* Form fields */
        .form-group { margin-bottom: 22px; }
        .form-label { display: block; font-size: 0.75rem; font-weight: 800; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 1px; }
        .form-control { width: 100%; padding: 14px 18px; border-radius: 14px; border: 2px solid #f1f5f9; background: #f8fafc; font-family: inherit; transition: var(--transition); font-size: 0.95rem; }
        .form-control:focus { border-color: #ff00ff; background: white; outline: none; box-shadow: 0 0 0 4px rgba(255, 0, 255, 0.1); }

        /* Order Summary */
        .summary-item { display: flex; justify-content: space-between; padding: 15px 0; border-bottom: 1px dashed #e2e8f0; font-size: 0.95rem; color: var(--text-main); }
        .summary-item b { color: #ff00ff; }
        .summary-total { display: flex; justify-content: space-between; padding-top: 25px; margin-top: 15px; font-size: 1.4rem; font-weight: 900; color: #ff00ff; border-top: 2px solid #fdf2f8; }

        /* Nút Thanh Toán */
        .btn-pay { 
            width: 100%; padding: 18px; border-radius: 16px; background: #ff00ff; color: #ffffff !important; 
            border: none; font-weight: 800; font-size: 1.1rem; text-transform: uppercase; cursor: pointer; 
            transition: var(--transition); margin-top: 25px; box-shadow: 0 6px 15px rgba(255, 0, 255, 0.3);
            display: flex; align-items: center; justify-content: center; gap: 10px;
        }
        .btn-pay:hover { background: var(--primary-dark); transform: translateY(-4px); box-shadow: 0 12px 25px rgb(47 222 252); }

        .info-delivery { background: #fff9fc; padding: 15px; border-radius: 12px; border: 1px solid #ffeff7; margin-top: 10px; font-size: 0.9rem; color: #ff4081; font-weight: 600; }

        /* --- TOAST NOTIFICATION --- */
        #toastBox {
            position: fixed; bottom: -100px; left: 50%; transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(10px); color: #fff;
            padding: 18px 40px; border-radius: 20px; z-index: 10000;
            display: flex; align-items: center; gap: 12px; box-shadow: 0 20px 50px rgba(0,0,0,0.3);
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
            background: white; padding: 40px; border-radius: 28px; max-width: 450px; width: 90%;
            text-align: center; box-shadow: 0 25px 50px rgba(0,0,0,0.2);
            transform: scale(0.9); transition: 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .modal-overlay.active .modal-content { transform: scale(1); }
        .modal-icon { width: 70px; height: 70px; background: #fdf2f8; color: #ff00ff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 30px; margin: 0 auto 20px; }
        
        .modal-actions { display: flex; gap: 15px; margin-top: 30px; }
        .btn-modal { padding: 14px 25px; border-radius: 14px; font-weight: 700; border: none; cursor: pointer; transition: 0.2s; flex: 1; font-size: 15px; }
        .btn-confirm-order { background: #ff00ff; color: white; }
        .btn-cancel-order { background: #f1f5f9; color: #475569; }

        @media (max-width: 992px) { .checkout-container { grid-template-columns: 1fr; } }
        body { cursor: url('https://cur.cursors-4u.net/games/gam-4/gam372.cur'), auto !important; }
    </style>

    <script>
        function showToast(message) {
            var toast = document.getElementById("toastBox");
            toast.innerHTML = "<i class='fa-solid fa-circle-check'></i> " + message;
            toast.classList.add("active");
            setTimeout(function () { toast.classList.remove("active"); }, 3000);
        }

        function openConfirmModal() {
            // Kiểm tra Validation trước khi mở Modal
            if (typeof (Page_ClientValidate) == 'function') {
                if (Page_ClientValidate() == false) return false;
            }
            document.getElementById('orderModal').classList.add('active');
            return false;
        }

        function closeConfirmModal() {
            document.getElementById('orderModal').classList.remove('active');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <%-- MODAL XÁC NHẬN ĐẶT HÀNG --%>
    <div id="orderModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-icon"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            <h3 style="font-weight:800; color:#1e293b; margin-bottom:12px;">Xác nhận đặt hàng?</h3>
            <p style="color:#64748b; font-size:15px; line-height:1.6;">Vui lòng kiểm tra kỹ thông tin giao hàng. Sau khi xác nhận, đơn hàng sẽ được chuyển cho đơn vị vận chuyển.</p>
            <div class="modal-actions">
                <button type="button" class="btn-modal btn-cancel-order" onclick="closeConfirmModal()">Kiểm tra lại</button>
                <asp:Button ID="btnFinalSubmit" runat="server" Text="Đồng ý đặt hàng" CssClass="btn-modal btn-confirm-order" OnClick="btnDatHang_Click" />
            </div>
        </div>
    </div>

    <div class="checkout-container">
        <%-- THÔNG TIN GIAO HÀNG --%>
        <div class="checkout-card">
            <div class="checkout-title"><i class="fa-solid fa-truck-fast"></i> THÔNG TIN GIAO HÀNG</div>
            
            <div class="form-group">
                <label class="form-label">Họ tên người nhận</label>
                <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control" placeholder="Họ và tên đầy đủ"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtHoTen" ErrorMessage="(*) Vui lòng nhập họ tên" ForeColor="Red" Display="Dynamic" Font-Size="12px" Font-Bold="true"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Số điện thoại liên lạc</label>
                <asp:TextBox ID="txtDienThoai" runat="server" CssClass="form-control" placeholder="Ví dụ: 090xxxxxxx"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfv2" runat="server" ControlToValidate="txtDienThoai" ErrorMessage="(*) Vui lòng nhập số điện thoại" ForeColor="Red" Display="Dynamic" Font-Size="12px" Font-Bold="true"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Địa chỉ nhận hàng chi tiết</label>
                <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Số nhà, tên đường, Phường/Xã..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfv3" runat="server" ControlToValidate="txtDiaChi" ErrorMessage="(*) Vui lòng nhập địa chỉ giao hàng" ForeColor="Red" Display="Dynamic" Font-Size="12px" Font-Bold="true"></asp:RequiredFieldValidator>
            </div>

            <div class="info-delivery">
                <i class="fa-solid fa-calendar-check"></i> Dự kiến giao hàng vào: 
                <asp:Literal ID="litNgayGiaoShow" runat="server"></asp:Literal>
                <br />
                <small style="font-weight:400; color:#94a3b8;">(Mặc định giao sau 14 ngày kể từ khi đặt hàng)</small>
            </div>
        </div>

        <%-- TÓM TẮT ĐƠN HÀNG --%>
        <div class="checkout-card">
            <div class="checkout-title"><i class="fa-solid fa-receipt"></i> TÓM TẮT ĐƠN HÀNG</div>
            
            <asp:Repeater ID="rptSummary" runat="server">
                <ItemTemplate>
                    <div class="summary-item">
                        <span><%# Eval("TenSach") %> <b>x<%# Eval("Soluong") %></b></span>
                        <span style="font-weight:700;"><%# string.Format("{0:#,##0} đ", Eval("Thanhtien")) %></span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="summary-total">
                <span>TỔNG CỘNG:</span>
                <asp:Label ID="lblTongTien" runat="server" Text="0 đ"></asp:Label>
            </div>

            <%-- NÚT GỌI MODAL --%>
            <asp:LinkButton ID="btnOpenModal" runat="server" CssClass="btn-pay" OnClientClick="return openConfirmModal();">
                <i class="fa-solid fa-lock"></i> XÁC NHẬN THANH TOÁN
            </asp:LinkButton>
            
            <p style="text-align:center; margin-top:20px; font-size:0.85rem;">
                <a href="giohang.aspx" style="color:var(--text-muted); text-decoration:none; font-weight:700;">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại giỏ hàng
                </a>
            </p>
        </div>
    </div>
</asp:Content>