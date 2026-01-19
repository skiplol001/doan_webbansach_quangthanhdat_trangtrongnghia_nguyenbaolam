<%@ Page Title="SẢN PHẨM ĐÃ XEM" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="sanpham-daxem.aspx.cs" Inherits="lab05.khach.sanpham_daxem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .viewed-container { max-width: 1300px; margin: 0 auto; padding: 40px 20px; }
        .page-title { font-size: 2.5rem; font-weight: 800; text-align: center; margin-bottom: 40px; }
        .page-title span { color: var(--primary); }
        
        .history-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 30px; }
        /* Tái sử dụng style book-card từ trang chủ của bạn */
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="viewed-container">
        <h2 class="page-title">Sách Bạn <span>Đã Xem</span></h2>
        
        <asp:Panel ID="pnlNoData" runat="server" Visible="false" Style="text-align:center; padding: 100px 0;">
             <i class="fa-solid fa-clock-rotate-left" style="font-size: 50px; color: #ddd; margin-bottom: 20px;"></i>
             <p style="color:#999;">Bạn chưa xem quyển sách nào gần đây.</p>
        </asp:Panel>

        <div class="history-grid">
            <asp:Repeater ID="rptViewed" runat="server">
                <ItemTemplate>
                    <div class="book-card" onclick="window.location.href='../khach/chitiet.aspx?MaSach=<%# Eval("MaSach") %>'">
                        <div class="card-img">
                            <div class="tags-overlay">
                                <%# RenderTags(Eval("Tags")) %>
                            </div>
                            <img src='<%# ResolveUrl("~/Images/") + Eval("AnhBia") %>' />
                        </div>
                        <div class="card-body">
                            <div class="book-title"><%# Eval("TenSach") %></div>
                            <span class="book-price"><%# string.Format("{0:#,##0} đ", Eval("Dongia")) %></span>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>