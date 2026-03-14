<%@ Page Title="Quản lý Sách (Compact)" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="QLSach.aspx.cs" Inherits="lab05.Seller.QLSach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --primary-blue: #3b82f6; --success: #10b981; --danger: #ef4444; }
        
        /* TINH CHỈNH COMPACT NHỎ LẠI 20% [cite: 2026-03-11] */
        body { font-size: 11.5px; }
        .action-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        h2 { font-size: 0.9rem !important; font-weight: 900; margin: 0; text-transform: uppercase; }
        
        .search-box { display: flex; align-items: center; background: white; border: 1px solid #e2e8f0; border-radius: 6px; padding: 0 8px; width: 280px; }
        .search-input { border: none; outline: none; padding: 5px; width: 100%; font-size: 10.5px; }
        .btn-search { color: #94a3b8; background: none; border: none; cursor: pointer; font-size: 12px; }

        .btn-add { background: var(--success); color: white !important; padding: 6px 14px; border-radius: 6px; text-decoration: none; font-weight: 700; font-size: 10px; }
        
        .grid-wrapper { background: white; padding: 10px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; }
        .img-thumb { width: 32px; height: 44px; object-fit: cover; border-radius: 3px; border: 1px solid #f1f5f9; }

        /* TABLE COMPACT STYLE */
        .table-mini { width: 100%; border-collapse: collapse; }
        .table-mini th { text-align: left; padding: 8px 10px; background: #f8fafc; color: #64748b; font-size: 8.5px; text-transform: uppercase; border-bottom: 2px solid #edf2f7; }
        .table-mini td { padding: 8px 10px; border-bottom: 1px solid #f1f5f9; color: #1e293b; font-size: 11.5px; }

        /* MỚI: Cảnh báo hết hàng [cite: 2026-03-14] */
        .stock-low { color: var(--danger); font-weight: 800; }
        .stock-ok { color: #64748b; font-weight: 600; }

        /* PHÂN TRANG REPEATER: TRƯỢT SỐ TRUNG TÂM */
        .pagination-wrapper { display: flex; justify-content: center; gap: 4px; margin-top: 15px; align-items: center; }
        .page-node { 
            text-decoration: none; padding: 4px 10px; border-radius: 6px; background: white; 
            color: #64748b; font-weight: 700; transition: 0.3s; border: 1px solid #eee; 
            font-size: 10px; min-width: 32px; text-align: center; 
        }
        .page-node:hover { background: #f8fafc; color: var(--primary-blue); border-color: var(--primary-blue); }
        .page-node.active { background: var(--primary-blue); color: white; border-color: var(--primary-blue); box-shadow: 0 4px 8px rgba(59, 130, 246, 0.2); }
        .page-nav { color: #cbd5e1; font-size: 1.1rem; padding: 0 5px; transition: 0.3s; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="upQLSach" runat="server">
        <ContentTemplate>
            
            <div class="action-bar">
                <h2>QUẢN LÝ <span style="color:var(--primary-blue);">KHO SÁCH</span></h2>
                
                <div class="search-box">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Tìm kiếm tên sách..." CssClass="search-input" AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
                    <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn-search" OnClick="btnSearch_Click">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </asp:LinkButton>
                </div>

                <asp:HyperLink ID="lnkAdd" runat="server" NavigateUrl="~/Seller/ThemSach.aspx" CssClass="btn-add">
                    <i class="fa-solid fa-plus-circle"></i> THÊM MỚI
                </asp:HyperLink>
            </div>

            <div class="grid-wrapper">
                <asp:GridView ID="gvSach" runat="server" AutoGenerateColumns="False" CssClass="table-mini" 
                    DataKeyNames="MaSach" OnRowDeleting="gvSach_RowDeleting" GridLines="None" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="Ảnh">
                            <ItemTemplate>
                                <img src='<%# Page.ResolveUrl("~/Images/" + Eval("AnhBia")) %>' class="img-thumb" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="TenSach" HeaderText="Tiêu đề sách" ItemStyle-Font-Bold="true" />
                        
                        <asp:TemplateField HeaderText="Giá niêm yết">
                            <ItemTemplate>
                                <b style="color:var(--danger);"><%# string.Format("{0:#,##0}", Eval("Dongia")) %>đ</b>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- MỚI: HIỂN THỊ SỐ LƯỢNG TỒN KHO [cite: 2026-03-14] --%>
                        <asp:TemplateField HeaderText="Số lượng">
                            <ItemTemplate>
                                <span class='<%# Convert.ToInt32(Eval("Soluongton")) < 5 ? "stock-low" : "stock-ok" %>'>
                                    <i class="fa-solid fa-boxes-stacked"></i> <%# Eval("Soluongton") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Ngaycapnhat" HeaderText="Cập nhật" DataFormatString="{0:dd/MM/yy}" ItemStyle-ForeColor="#94a3b8" />

                        <asp:TemplateField HeaderText="Công cụ">
                            <ItemTemplate>
                                <div style="display:flex; gap:10px;">
                                    <asp:HyperLink ID="lnkEdit" runat="server" NavigateUrl='<%# "SuaSach.aspx?id=" + Eval("MaSach") %>' style="color:var(--primary-blue); font-size:14px;"><i class="fa-solid fa-pen-to-square"></i></asp:HyperLink>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" style="color:var(--danger); font-size:14px;" OnClientClick="return confirm('Xác nhận xóa quyển sách này khỏi hệ thống?');"><i class="fa-solid fa-trash-can"></i></asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="text-align:center; padding:30px; color:#94a3b8;">Không tìm thấy sách nào trong kho.</div>
                    </EmptyDataTemplate>
                </asp:GridView>

                <%-- PHÂN TRANG --%>
                <div class="pagination-wrapper">
                    <asp:HyperLink ID="lnkFirst" runat="server" CssClass="page-nav" ToolTip="Trang đầu"><i class="fa-solid fa-angles-left"></i></asp:HyperLink>
                    <asp:HyperLink ID="lnkPrev" runat="server" CssClass="page-nav"><i class="fa-solid fa-angle-left"></i></asp:HyperLink>
                    
                    <asp:Repeater ID="rptPaging" runat="server">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkPage" runat="server" 
                                NavigateUrl='<%# GetPageUrl(Eval("PageIndex")) %>'
                                Text='<%# Eval("PageText") %>'
                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "page-node active" : "page-node" %>'>
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:HyperLink ID="lnkNext" runat="server" CssClass="page-nav"><i class="fa-solid fa-angle-right"></i></asp:HyperLink>
                    <asp:HyperLink ID="lnkLast" runat="server" CssClass="page-nav" ToolTip="Trang cuối"><i class="fa-solid fa-angles-right"></i></asp:HyperLink>
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>