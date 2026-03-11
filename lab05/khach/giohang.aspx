<%@ Page Title="GIỎ HÀNG" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="giohang.aspx.cs" Inherits="lab05.giohang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary: #ff4081; --text-main: #1e293b; }

        /* PHÓNG TO GIAO DIỆN 120% */
        .cart-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; font-size: 15px; }
        .cart-card { background: white; border-radius: 24px; padding: 35px; box-shadow: 0 15px 35px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
        
        .cart-table { width: 100%; border-collapse: separate; border-spacing: 0 12px; }
        .cart-table th { color: #64748b; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; padding: 15px 20px; text-align: left; border-bottom: 2px solid #f8fafc; }
        .cart-table td { padding: 20px; background: #fff; vertical-align: middle; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
        
        .product-img { width: 80px; height: 110px; object-fit: contain; border-radius: 10px; filter: drop-shadow(0 5px 15px rgba(0,0,0,0.08)); }
        .book-title-cart { font-weight: 800; color: var(--text-main); font-size: 1.1rem; margin-bottom: 5px; }
        
        /* Input số lượng lớn hơn */
        .quantity-input { 
            width: 70px; height: 45px; text-align: center; border: 2px solid #e2e8f0; 
            border-radius: 12px; outline: none; font-weight: 800; font-size: 16px; transition: 0.3s;
        }
        .quantity-input:focus { border-color: var(--primary); box-shadow: 0 0 0 4px rgba(255, 64, 129, 0.1); }

        .price-val { font-weight: 600; color: #64748b; }
        .total-val { font-weight: 900; color: var(--primary); font-size: 1.2rem; }

        .btn-del-only { 
            background: #fff1f2; color: #f43f5e; width: 45px; height: 45px; 
            border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; 
            text-decoration: none; transition: 0.3s; border: none; cursor: pointer;
        }
        .btn-del-only:hover { background: #f43f5e; color: white; transform: scale(1.1); }

        .cart-footer { display: flex; justify-content: space-between; align-items: flex-end; margin-top: 40px; padding-top: 30px; border-top: 2px dashed #f1f5f9; }
        .big-price { font-size: 2.5rem; font-weight: 900; color: var(--text-main); line-height: 1; }
        .big-price span { color: var(--primary); font-size: 1.2rem; margin-left: 8px; }

        .btn-checkout { background: var(--primary); color: white !important; padding: 20px 45px; border-radius: 20px; font-weight: 800; text-decoration: none; box-shadow: 0 10px 25px rgba(255, 64, 129, 0.25); transition: 0.3s; border:none; cursor:pointer; font-size: 1.1rem; }
        .btn-checkout:hover { transform: translateY(-5px); filter: brightness(1.1); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="cart-container">
        <div class="cart-card">
            <h1 style="font-weight: 900; letter-spacing: -1.5px; margin-bottom: 35px; color: var(--text-main);">GIỎ HÀNG <span style="color:var(--primary)">HÓA ĐƠN</span></h1>

            <asp:UpdatePanel ID="upCart" runat="server">
                <ContentTemplate>
                    
                    <asp:Panel ID="pnlEmptyCart" runat="server" Style="text-align:center; padding:60px 0;">
                        <i class="fa-solid fa-basket-shopping" style="font-size: 80px; color: #f1f5f9; margin-bottom: 20px; display:block;"></i>
                        <h2 style="color: #cbd5e1; font-weight: 800;">Giỏ hàng đang trống</h2>
                        <a href="trangchu.aspx" class="btn-checkout" style="display:inline-block; margin-top:20px; font-size: 14px; padding: 12px 30px;">MUA SẮM NGAY</a>
                    </asp:Panel>

                    <asp:Panel ID="pnlCartContent" runat="server" Visible="false">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Chi tiết</th>
                                    <th>Số lượng</th>
                                    <th>Đơn giá</th>
                                    <th>Thành tiền</th>
                                    <th style="text-align:right">Xóa</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="width: 110px;">
                                                <img src='<%# ResolveUrl("~/Images/") + Eval("HinhAnh") %>' class="product-img" />
                                            </td>
                                            <td>
                                                <div class="book-title-cart"><%# Eval("TenSach") %></div>
                                                <span style="color:#94a3b8; font-weight:600;">Mã: #<%# Eval("MaSach") %></span>
                                            </td>
                                            <td>
                                                <%-- FIX TÍNH TOÁN TỨC THỜI: AutoPostBack="true" --%>
                                                <asp:HiddenField ID="hfMaSach" runat="server" Value='<%# Eval("MaSach") %>' />
                                                <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Soluong") %>' 
                                                    CssClass="quantity-input" TextMode="Number" min="1" 
                                                    AutoPostBack="true" OnTextChanged="txtQuantity_TextChanged" />
                                            </td>
                                            <td><span class="price-val"><%# string.Format("{0:#,##0}đ", Eval("Dongia")) %></span></td>
                                            <td><span class="total-val"><%# string.Format("{0:#,##0}đ", Eval("Thanhtien")) %></span></td>
                                            <td style="text-align:right">
                                                <asp:LinkButton runat="server" CommandName="Delete" CommandArgument='<%# Eval("MaSach") %>' 
                                                    CssClass="btn-del-only" OnClientClick="return confirm('Xóa sản phẩm này?');">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>

                        <div class="cart-footer">
                            <asp:LinkButton ID="btnClearAll" runat="server" OnClick="btnClear_Click" Style="color: #94a3b8; font-weight: 700; text-decoration: none; font-size: 14px;">
                                <i class="fa-solid fa-trash-sweep"></i> XÓA TẤT CẢ GIỎ HÀNG
                            </asp:LinkButton>

                            <div style="text-align: right;">
                                <p style="font-size: 13px; color: #64748b; text-transform: uppercase; font-weight: 800; margin-bottom: 10px;">Tổng tiền thanh toán</p>
                                <div class="big-price"><asp:Literal ID="litTongTien" runat="server"></asp:Literal><span>VNĐ</span></div>
                                <div style="margin-top: 30px;">
                                    <asp:LinkButton ID="btnOrderNow" runat="server" CssClass="btn-checkout" OnClick="btnOrder_Click">
                                        TIẾN HÀNH ĐẶT HÀNG <i class="fa-solid fa-arrow-right" style="margin-left:10px;"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>