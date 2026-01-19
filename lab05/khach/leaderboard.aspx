<%@ Page Title="BẢNG XẾP HẠNG" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="leaderboard.aspx.cs" Inherits="lab05.khach.leaderboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .leaderboard-container { max-width: 1200px; margin: 0 auto; padding: 40px 20px; }
        
        /* HEADER */
        .leaderboard-header { text-align: center; margin-bottom: 50px; }
        .leaderboard-header h1 { font-size: 3rem; font-weight: 800; color: var(--text); margin-bottom: 10px; }
        .leaderboard-header h1 span { color: var(--primary); position: relative; }
        .leaderboard-header p { color: #666; font-size: 1.1rem; }

        /* TOP 3 WINNERS SECTION */
        .top-winners { display: flex; align-items: flex-end; justify-content: center; gap: 20px; margin-bottom: 60px; padding-top: 40px; }
        
        .winner-card { background: white; border-radius: 25px; padding: 30px; text-align: center; position: relative; transition: 0.4s; box-shadow: 0 10px 30px rgba(0,0,0,0.05); cursor: pointer; }
        .winner-card:hover { transform: translateY(-15px); box-shadow: 0 20px 40px rgba(0,0,0,0.1); }
        
        /* Phân cấp độ cao Top 3 */
        .rank-1 { width: 350px; order: 2; border: 3px solid #FFD700; z-index: 3; } /* Vàng */
        .rank-2 { width: 300px; order: 1; border: 3px solid #C0C0C0; z-index: 2; } /* Bạc */
        .rank-3 { width: 300px; order: 3; border: 3px solid #CD7F32; z-index: 1; } /* Đồng */

        .medal-icon { position: absolute; top: -35px; left: 50%; transform: translateX(-50%); font-size: 50px; }
        
        .winner-img { width: 180px; height: 260px; object-fit: cover; border-radius: 15px; margin-bottom: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .rank-1 .winner-img { width: 200px; height: 290px; }

        .winner-name { font-weight: 800; font-size: 1.3rem; margin-bottom: 10px; color: #333; height: 3.2rem; overflow: hidden; }
        .winner-stats { font-weight: 700; color: var(--primary); font-size: 1.1rem; }

        /* LIST FROM RANK 4+ */
        .rank-list { background: white; border-radius: 25px; overflow: hidden; box-shadow: 0 5px 20px rgba(0,0,0,0.03); }
        .rank-item { display: grid; grid-template-columns: 80px 100px 1fr 150px 180px; align-items: center; padding: 20px; border-bottom: 1px solid #f1f1f1; transition: 0.3s; }
        .rank-item:hover { background: #fff9fb; }
        .rank-item:last-child { border-bottom: none; }

        .rank-number { font-size: 1.5rem; font-weight: 800; color: #cbd5e1; text-align: center; }
        .rank-thumb { width: 60px; height: 80px; object-fit: cover; border-radius: 8px; }
        .rank-info { padding-left: 20px; }
        .rank-name { font-weight: 700; font-size: 1.1rem; color: #333; text-decoration: none; }
        .rank-name:hover { color: var(--primary); }
        
        /* Tags trong List */
        .rank-tags { margin-top: 5px; display: flex; gap: 5px; }
        .tag-badge { background: #f1f5f9; color: #64748b; padding: 2px 8px; border-radius: 5px; font-size: 10px; font-weight: 700; text-transform: uppercase; }

        .rank-views { color: #64748b; font-weight: 600; font-size: 0.9rem; }
        .rank-views i { color: #f59e0b; margin-right: 5px; }

        .btn-rank-buy { 
            background: var(--primary); color: white !important; padding: 10px 20px; border-radius: 12px; 
            text-decoration: none; font-weight: 700; text-align: center; font-size: 0.9rem; transition: 0.3s;
        }
        .btn-rank-buy:hover { background: #333; transform: scale(1.05); }

        /* Responsive */
        @media (max-width: 992px) {
            .top-winners { flex-direction: column; align-items: center; }
            .winner-card { width: 100% !important; order: unset !important; }
            .rank-item { grid-template-columns: 50px 60px 1fr 120px; }
            .rank-item .btn-rank-buy { display: none; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="leaderboard-container">
        <header class="leaderboard-header">
            <h1>BẢNG XẾP HẠNG <span>SÁCH HOT</span></h1>
            <p>Khám phá những đầu sách đang dẫn đầu xu hướng năm 2026</p>
        </header>

        <%-- 1. KHU VỰC TOP 3 (VINH DANH) --%>
        <div class="top-winners">
            <asp:Repeater ID="rptTop3" runat="server">
                <ItemTemplate>
                    <div class='<%# "winner-card rank-" + (Container.ItemIndex + 1) %>' 
                         onclick="window.location.href='chitiet.aspx?MaSach=<%# Eval("MaSach") %>'">
                        <div class="medal-icon">
                            <%# Container.ItemIndex == 0 ? "🥇" : (Container.ItemIndex == 1 ? "🥈" : "🥉") %>
                        </div>
                        <img src='<%# "../Images/" + Eval("AnhBia") %>' class="winner-img" alt="Top Book" />
                        <div class="winner-name"><%# Eval("TenSach") %></div>
                        <div class="winner-stats">
                            <i class="fa-solid fa-fire"></i> <%# string.Format("{0:#,##0}", Eval("Soluotxem")) %> lượt quan tâm
                        </div>
                        <div class="mt-3">
                             <span class="badge bg-light text-dark shadow-sm p-2 px-3 rounded-pill">Hạng <%# Container.ItemIndex + 1 %></span>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <%-- 2. DANH SÁCH XẾP HẠNG CHI TIẾT (HẠNG 4+) --%>
        <div class="rank-list">
            <div class="rank-item" style="background: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                <div class="rank-number" style="font-size: 0.8rem; color: #64748b;">HẠNG</div>
                <div></div>
                <div style="font-weight: 800; color: #64748b; padding-left: 20px;">THÔNG TIN SÁCH</div>
                <div style="font-weight: 800; color: #64748b;">LƯỢT XEM</div>
                <div></div>
            </div>

            <asp:Repeater ID="rptOtherRanks" runat="server" OnItemCommand="rptOtherRanks_ItemCommand">
                <ItemTemplate>
                    <div class="rank-item">
                        <div class="rank-number">#<%# Container.ItemIndex + 4 %></div>
                        <img src='<%# "../Images/" + Eval("AnhBia") %>' class="rank-thumb" />
                        <div class="rank-info">
                            <a href='<%# "chitiet.aspx?MaSach=" + Eval("MaSach") %>' class="rank-name"><%# Eval("TenSach") %></a>
                            <div class="rank-tags">
                                <%# RenderTags(Eval("Tags")) %>
                            </div>
                        </div>
                        <div class="rank-views">
                            <i class="fa-solid fa-eye"></i><%# string.Format("{0:#,##0}", Eval("Soluotxem")) %>
                        </div>
                        <asp:LinkButton ID="btnBuyNow" runat="server" CssClass="btn-rank-buy" 
                            CommandName="ThemGioHang" CommandArgument='<%# Eval("MaSach") %>'
                            OnClientClick="event.stopPropagation();">
                            <i class="fa-solid fa-cart-plus"></i> MUA NGAY
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>