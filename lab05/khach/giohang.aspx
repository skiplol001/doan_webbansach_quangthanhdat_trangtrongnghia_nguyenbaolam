<%@ Page Title="GIỎ HÀNG" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="giohang.aspx.cs" Inherits="lab05.giohang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .cart-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        .cart-card { background: white; border-radius: 24px; padding: 30px; box-shadow: var(--shadow); border: 1px solid rgba(0,0,0,0.05); }
        
        /* Cấu trúc bảng hiện đại */
        .cart-table { width: 100%; border-collapse: separate; border-spacing: 0 15px; }
        .cart-table th { color: var(--text-light); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; padding: 10px 20px; text-align: left; }
        .cart-table td { padding: 20px; background: #fff; vertical-align: middle; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
        .cart-table td:first-child { border-left: 1px solid #f1f5f9; border-top-left-radius: 15px; border-bottom-left-radius: 15px; }
        .cart-table td:last-child { border-right: 1px solid #f1f5f9; border-top-right-radius: 15px; border-bottom-right-radius: 15px; }

        .product-img { width: 70px; height: 100px; object-fit: contain; border-radius: 8px; filter: drop-shadow(0 5px 10px rgba(0,0,0,0.1)); }
        .book-title-cart { font-weight: 700; color: var(--text); font-size: 1rem; margin-bottom: 4px; }
        
        .quantity-wrapper { display: flex; align-items: center; gap: 10px; }
        .quantity-input { width: 60px; height: 38px; text-align: center; border: 2px solid #f1f5f9; border-radius: 10px; outline: none; font-weight: 700; }
        .quantity-input:focus { border-color: var(--primary); }

        .price-val { font-weight: 600; color: var(--text-light); }
        .total-val { font-weight: 800; color: var(--primary); font-size: 1.1rem; }

        /* Nút thao tác */
        .btn-action-cart { border: none; width: 38px; height: 38px; border-radius: 10px; cursor: pointer; transition: 0.3s; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; }
        .btn-save { background: #ecfdf5; color: #10b981; margin-right: 5px; }
        .btn-save:hover { background: #10b981; color: white; }
        .btn-del { background: #fff1f2; color: #f43f5e; }
        .btn-del:hover { background: #f43f5e; color: white; }

        .cart-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 40px; padding-top: 30px; border-top: 2px dashed #f1f5f9; }
        .big-price { font-size: 2.2rem; font-weight: 800; color: var(--text); }
        .big-price span { color: var(--primary); font-size: 1.2rem; margin-left: 5px; }

        .btn-checkout { background: var(--primary); color: white !important; padding: 18px 40px; border-radius: 18px; font-weight: 800; text-decoration: none; box-shadow: 0 10px 20px rgba(255, 64, 129, 0.2); transition: 0.3s; border:none; cursor:pointer; }
        .btn-checkout:hover { transform: translateY(-3px); background: var(--primary-dark); }
        
        .empty-cart-ui { text-align: center; padding: 80px 0; }
        .empty-cart-ui i { font-size: 70px; color: #f1f5f9; margin-bottom: 20px; display: block; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="cart-container">
        <div class="cart-card">
            <h1 style="font-weight: 800; letter-spacing: -1px; margin-bottom: 30px; color: var(--text);">GIỎ HÀNG <span style="color:var(--primary)">CỦA BẠN</span></h1>

            <asp:Panel ID="pnlEmptyCart" runat="server" CssClass="empty-cart-ui">
                <i class="fa-solid fa-cart-shopping"></i>
                <h2 style="color: #cbd5e1;">Giỏ hàng của bạn đang trống</h2>
                <p style="margin: 15px 0 30px; color: #94a3b8;">Hãy chọn cho mình những cuốn sách yêu thích nhé!</p>
                <a href="trangchu.aspx" class="btn-checkout" style="padding: 12px 30px; font-size: 0.9rem;">TIẾP TỤC MUA SẮM</a>
            </asp:Panel>

            <asp:Panel ID="pnlCartContent" runat="server" Visible="false">
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Thông tin</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                            <th style="text-align:right">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td style="width: 100px;">
                                        <img src='<%# ResolveUrl("~/Images/") + Eval("HinhAnh") %>' class="product-img" />
                                    </td>
                                    <td>
                                        <div class="book-title-cart"><%# Eval("TenSach") %></div>
                                        <small style="color:#94a3b8">Mã sách: #<%# Eval("MaSach") %></small>
                                    </td>
                                    <td>
                                        <div class="quantity-wrapper">
                                            <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Soluong") %>' CssClass="quantity-input" TextMode="Number" min="1" />
                                        </div>
                                    </td>
                                    <td><span class="price-val"><%# string.Format("{0:#,##0}đ", Eval("Dongia")) %></span></td>
                                    <td><span class="total-val"><%# string.Format("{0:#,##0}đ", Eval("Thanhtien")) %></span></td>
                                    <td style="text-align:right">
                                        <asp:LinkButton runat="server" CommandName="Update" CommandArgument='<%# Eval("MaSach") %>' CssClass="btn-action-cart btn-save" title="Lưu thay đổi"><i class="fa-solid fa-check"></i></asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="Delete" CommandArgument='<%# Eval("MaSach") %>' CssClass="btn-action-cart btn-del" title="Xóa khỏi giỏ"><i class="fa-solid fa-trash-can"></i></asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>

                <div class="cart-footer">
                    <asp:LinkButton ID="btnClearAll" runat="server" OnClick="btnClear_Click" Style="color: #94a3b8; font-weight: 600; text-decoration: none; font-size: 0.85rem;">
                        <i class="fa-solid fa-trash-sweep" style="margin-right:5px;"></i> Xóa sạch giỏ hàng
                    </asp:LinkButton>

                    <div style="text-align: right;">
                        <h3 style="font-size: 0.8rem; color: var(--text-light); text-transform: uppercase;">Tổng thanh toán</h3>
                        <div class="big-price"><asp:Literal ID="litTongTien" runat="server"></asp:Literal><span>VNĐ</span></div>
                        <div style="margin-top: 25px;">
                            <asp:LinkButton ID="btnOrderNow" runat="server" CssClass="btn-checkout" OnClick="btnOrder_Click">
                                XÁC NHẬN ĐẶT HÀNG <i class="fa-solid fa-chevron-right" style="margin-left:10px;"></i>
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>