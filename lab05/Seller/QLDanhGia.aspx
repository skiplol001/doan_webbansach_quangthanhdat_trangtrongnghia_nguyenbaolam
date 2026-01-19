<%@ Page Title="Quản lý đánh giá" Language="C#" MasterPageFile="~/Seller/Seller.Master" AutoEventWireup="true" CodeBehind="QLDanhGia.aspx.cs" Inherits="lab05.Admin.QLDanhGia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .comment-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .comment-header h2 { font-weight: 800; color: #1e293b; margin: 0; display: flex; align-items: center; gap: 12px; }
        .comment-header h2 i { color: var(--seller-primary); }

        .table-card { background: white; padding: 30px; border-radius: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }

        /* Custom GridView */
        .gv-comments { width: 100%; border-collapse: collapse; border-radius: 12px; overflow: hidden; }
        .gv-comments th { background: #f8fafc; color: #64748b; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; padding: 18px 15px; border-bottom: 2px solid #f1f5f9; text-align: left; }
        .gv-comments td { padding: 18px 15px; border-bottom: 1px solid #f1f5f9; color: #334155; font-size: 14px; vertical-align: middle; }
        .gv-comments tr:hover { background-color: #fcfdff; }

        .star-rating { color: #f59e0b; font-size: 14px; letter-spacing: 2px; }
        .book-link { color: #6366f1; font-weight: 700; text-decoration: none; transition: 0.2s; }
        .customer-name { font-weight: 600; display: flex; align-items: center; gap: 8px; color: #475569; }
        .comment-text { color: #64748b; font-style: italic; line-height: 1.5; max-width: 400px; }

        .btn-delete { 
            background: #fff1f2; color: #e11d48; border: none; padding: 8px 15px; border-radius: 8px; 
            font-size: 12px; font-weight: 700; cursor: pointer; transition: 0.3s; text-decoration: none;
            display: inline-flex; align-items: center; gap: 5px;
        }
        .btn-delete:hover { background: #e11d48; color: white; transform: translateY(-2px); }

        /* --- TOAST NOTIFICATION --- */
        #toastBox {
            position: fixed; bottom: -100px; left: 50%; transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.95); backdrop-filter: blur(10px); color: #fff;
            padding: 16px 35px; border-radius: 20px; z-index: 10000;
            display: flex; align-items: center; gap: 12px; box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55); font-weight: 600;
        }
        #toastBox.active { bottom: 40px; }

        /* --- CUSTOM MODAL DELETE --- */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.5); backdrop-filter: blur(4px);
            display: none; align-items: center; justify-content: center; z-index: 11000;
            opacity: 0; transition: 0.3s;
        }
        .modal-overlay.active { display: flex; opacity: 1; }
        .modal-content {
            background: white; padding: 40px; border-radius: 24px; max-width: 400px; width: 90%;
            text-align: center; box-shadow: 0 25px 50px rgba(0,0,0,0.2);
            transform: scale(0.9); transition: 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .modal-overlay.active .modal-content { transform: scale(1); }
        .modal-icon { width: 65px; height: 65px; background: #fff1f2; color: #e11d48; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 28px; margin: 0 auto 20px; }
        
        .btn-modal { padding: 12px 25px; border-radius: 12px; font-weight: 700; border: none; cursor: pointer; transition: 0.2s; flex: 1; }
        .btn-confirm { background: #e11d48; color: white; }
        .btn-cancel { background: #f1f5f9; color: #475569; }
    </style>

    <script>
        function showToast(message) {
            var toast = document.getElementById("toastBox");
            toast.innerHTML = "<i class='fa-solid fa-circle-check' style='color:#10b981;'></i> " + message;
            toast.classList.add("active");
            setTimeout(function () { toast.classList.remove("active"); }, 3000);
        }

        function openDeleteModal(maBL) {
            document.getElementById('<%= hfDeleteID.ClientID %>').value = maBL;
            document.getElementById('deleteModal').classList.add('active');
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox"></div>

    <%-- MODAL XÓA ĐÁNH GIÁ --%>
    <div id="deleteModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-icon"><i class="fa-solid fa-trash-can"></i></div>
            <h3 style="margin-bottom:10px; font-weight:800;">Xác nhận xóa?</h3>
            <p style="color:#64748b; font-size:14px; margin-bottom:30px;">Hành động này sẽ gỡ bỏ vĩnh viễn đánh giá của khách hàng khỏi hệ thống.</p>
            <div style="display:flex; gap:12px;">
                <button type="button" class="btn-modal btn-cancel" onclick="closeDeleteModal()">Hủy bỏ</button>
                <asp:Button ID="btnConfirmDelete" runat="server" Text="Đồng ý xóa" CssClass="btn-modal btn-confirm" OnClick="btnConfirmDelete_Click" />
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hfDeleteID" runat="server" />

    <div class="comment-header">
        <h2><i class="fa-solid fa-star-half-stroke"></i> QUẢN LÝ <span>ĐÁNH GIÁ</span></h2>
    </div>

    <div class="table-card">
        <%-- ĐÃ CÓ SCRIPTMANAGER Ở MASTER NÊN CHỈ CẦN UPDATEPANEL --%>
        <asp:UpdatePanel ID="upComments" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gvComments" runat="server" AutoGenerateColumns="False" 
                    CssClass="gv-comments" GridLines="None" DataKeyNames="MaBL">
                    <Columns>
                        <asp:TemplateField HeaderText="Sản phẩm">
                            <ItemTemplate>
                                <a href='<%# "../khach/chitiet.aspx?MaSach=" + Eval("MaSach") %>' target="_blank" class="book-link">
                                    <%# Eval("TenSach") %>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Người gửi">
                            <ItemTemplate>
                                <div class="customer-name">
                                    <i class="fa-solid fa-circle-user"></i> <%# Eval("HoTenKH") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Mức độ">
                            <ItemTemplate>
                                <div class="star-rating"><%# RenderStars(Eval("DanhGia")) %></div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Nội dung">
                            <ItemTemplate>
                                <div class="comment-text">"<%# Eval("NoiDung") %>"</div>
                                <div style="font-size: 11px; color:#cbd5e1; margin-top:5px;"><%# Eval("NgayBL", "{0:dd/MM/yyyy}") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <%-- GỌI MODAL TỰ CHẾ --%>
                                <asp:LinkButton ID="lnkXoa" runat="server" CssClass="btn-delete"
                                    OnClientClick='<%# "openDeleteModal(" + Eval("MaBL") + "); return false;" %>'>
                                    <i class="fa-solid fa-trash-can"></i> Xóa bỏ
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="text-align:center; padding:40px; color:#94a3b8;">Chưa có đánh giá nào.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>