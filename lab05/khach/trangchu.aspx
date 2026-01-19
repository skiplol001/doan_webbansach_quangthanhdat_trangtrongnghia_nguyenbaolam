<%@ Page Title="TRANG CHỦ" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="trangchu.aspx.cs" Inherits="lab05.trangchu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #ff4081;
            --primary-light: #fdf2f8;
            --text: #2d3436;
            --white: #ffffff;
            --bg: #f8f9fa;
            --shadow-custom: 0 20px 40px rgba(0,0,0,0.08);
            --transition-smooth: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        body { background-color: var(--bg); font-family: 'Inter', sans-serif; }
        .home-wrapper { padding-bottom: 80px; max-width: 1300px; margin: 0 auto; }

        /* --- TIÊU ĐỀ HERO --- */
        .hero-title { 
            text-align: center; margin: 60px 0 40px; 
            font-size: 2.5rem; font-weight: 800; color: var(--text);
            text-transform: uppercase; letter-spacing: -1px;
        }
        .hero-title span { color: var(--primary); }

        /* --- CAROUSEL HOT BOOKS (FIX ĐÈ VÀ NHÂN BẢN) --- */
        .carousel-container { overflow: hidden; position: relative; }
        .carousel-title { font-weight: 800; color: var(--text); font-size: 1.5rem; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .carousel-inner { padding: 15px 0; }
        .carousel-inner .carousel-item { transition: transform 0.6s ease-in-out, opacity 0.4s ease; opacity: 0; display: none; backface-visibility: hidden; }
        .carousel-inner .carousel-item.active, .carousel-inner .carousel-item-next, .carousel-inner .carousel-item-prev { display: flex; opacity: 1; }
        
        /* Hiển thị 4 sách trên 1 hàng (Desktop) */
        .carousel-item .col-book { flex: 0 0 25%; padding: 0 12px; }

       @media (min-width: 768px) {
    /* 4. Fix lỗi bị nhảy hình khi bắt đầu trượt */
    .carousel-inner .carousel-item-next,
    .carousel-inner .carousel-item-prev,
    .carousel-inner .carousel-item.active {
        display: flex !important;
    }
    /* 5. Ép khoảng cách trượt đúng bằng chiều rộng 1 item (25%) */
    .carousel-inner .carousel-item-end.active,
    .carousel-inner .carousel-item-next {
        transform: translateX(25%);
    }

    .carousel-inner .carousel-item-start.active,
    .carousel-inner .carousel-item-prev {
        transform: translateX(-25%);
    }

    /* 6. Loại bỏ thuộc tính mặc định của Bootstrap gây đè ảnh */
    .carousel-inner .carousel-item-end,
    .carousel-inner .carousel-item-start {
        transform: translateX(0);
    }

        .carousel-control-prev, .carousel-control-next { 
            z-index: 20; background-color: var(--primary); width: 45px; height: 45px; 
            border-radius: 50%; top: 50%; transform: translateY(-50%); 
            border: 3px solid #fff; opacity: 0.9; transition: 0.3s;
        }
        .carousel-control-prev:hover, .carousel-control-next:hover { background-color: #333; transform: translateY(-50%) scale(1.1); }

        /* --- BOOK CARDS STYLES --- */
        .book-card { 
            background: var(--white); border-radius: 24px; padding: 22px;
            border: 1px solid rgba(0,0,0,0.03); transition: var(--transition-smooth);
            display: flex; flex-direction: column; position: relative;
            height: 100%; cursor: pointer;
        }
        .book-card:hover { 
            transform: translateY(-15px); 
            box-shadow: var(--shadow-custom);
            border-color: var(--primary);
        }

        .card-img { 
            height: 260px; background: #fff; border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 18px; overflow: hidden; position: relative;
        }
        .card-img img { max-width: 90%; max-height: 90%; transition: 0.5s; object-fit: contain; }
        .book-card:hover .card-img img { transform: scale(1.1); }

        /* Tags Badge Overlay */
        .tags-overlay { position: absolute; top: 12px; left: 12px; display: flex; flex-wrap: wrap; gap: 5px; z-index: 10; }
        .tag-badge { 
            background: rgba(255, 255, 255, 0.95); color: var(--primary); 
            padding: 4px 10px; border-radius: 8px; font-size: 10px; font-weight: 800;
            text-transform: uppercase; border-left: 4px solid var(--primary);
            box-shadow: 0 4px 10px rgba(0,0,0,0.05); pointer-events: none;
        }

        .book-title { 
            font-weight: 700; font-size: 1.05rem; color: var(--text);
            margin-bottom: 10px; height: 3.1rem; overflow: hidden;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
            line-height: 1.5;
        }
        .book-price { color: var(--primary); font-weight: 800; font-size: 1.3rem; display: block; }
        .view-count { font-size: 0.8rem; color: #94a3b8; margin-top: 8px; display: flex; align-items: center; gap: 5px; }

        /* --- GRID HỆ THỐNG --- */
        .book-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 30px; }

        .btn-cart { 
            background: var(--primary); color: white !important;
            height: 50px; border-radius: 15px; border: none;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; cursor: pointer; text-decoration: none;
            transition: 0.3s; margin-top: 20px; width: 100%;
        }
        .btn-cart:hover { background: #1e293b; transform: scale(1.03); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }

        /* Toast Message thành công */
        .toast-msg {
            position: fixed; bottom: 40px; left: 50%; transform: translateX(-50%);
            background: #1e293b; color: white; padding: 15px 35px;
            border-radius: 50px; z-index: 10000; display: none;
            box-shadow: 0 15px 30px rgba(0,0,0,0.3); font-weight: 600;
        }
        /* --- PHÂN TRANG (PAGING STYLE - GIỚI HẠN 5 MỤC) --- */
        .pagination-wrapper { display: flex; justify-content: center; gap: 10px; margin-top: 50px; align-items: center; }
        .page-node { text-decoration: none; padding: 10px 18px; border-radius: 12px; background: white; color: var(--text); font-weight: 700; transition: 0.3s; border: 1px solid #eee; min-width: 45px; text-align: center; }
        .page-node:hover { background: var(--primary-light); color: var(--primary); border-color: var(--primary); }
        .page-node.active { background: var(--primary); color: white; border-color: var(--primary); box-shadow: 0 8px 15px rgba(255, 64, 129, 0.2); }
        .page-nav { color: #cbd5e1; font-size: 1.2rem; transition: 0.3s; }
        .page-nav:hover { color: var(--primary); }

        .toast-msg { position: fixed; bottom: 40px; left: 50%; transform: translateX(-50%); background: #1e293b; color: white; padding: 15px 35px; border-radius: 50px; z-index: 10000; display: none; box-shadow: 0 15px 30px rgba(0,0,0,0.3); font-weight: 600; }
    </style>


    <script>
        function showToast() {
            var toast = document.getElementById("toastBox");
            toast.innerHTML = "<i class='fa-solid fa-circle-check' style='color:#4ade80; margin-right:10px;'></i> Sản phẩm đã nằm trong giỏ hàng!";
            toast.style.display = "block";
            setTimeout(function () { toast.style.display = "none"; }, 3500);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="toastBox" class="toast-msg"></div>

    <div class="home-wrapper">
        <%-- SECTION 1: CAROUSEL SÁCH HOT (XU HƯỚNG) --%>
        <div class="carousel-container mt-5">
            <h3 class="carousel-title">
                <i class="fa-solid fa-fire-flame-curved" style="color: #ff4081;"></i> XU HƯỚNG ĐỌC SÁCH
            </h3>

            <div id="hotBooksCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4500">
                <div class="carousel-inner">
                    <asp:Repeater ID="rptCarousel" runat="server" DataSourceID="SqlDataSourceCarousel" OnItemCommand="rptSach_ItemCommand">
                        <ItemTemplate>
                            <div class='carousel-item <%# Container.ItemIndex == 0 ? "active" : "" %>'>
                                <div class="col-book">
                                    <div class="book-card" onclick="window.location.href='chitiet.aspx?MaSach=<%# Eval("MaSach") %>'">
                                        <div class="card-img">
                                            <div class="tags-overlay">
                                                <%# RenderTags(Eval("Tags")) %>
                                            </div>
                                            <img src='<%# "../Images/" + (Eval("AnhBia") != DBNull.Value ? Eval("AnhBia") : "no-image.jpg") %>' alt="Hot Book" />
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="book-title"><%# Eval("TenSach") %></div>
                                            <span class="book-price"><%# string.Format("{0:#,##0} đ", Eval("Dongia")) %></span>
                                            <div class="view-count"><i class="fa-solid fa-eye"></i> <%# Eval("Soluotxem") %> lượt xem</div>
                                        </div>
                                        <asp:LinkButton ID="btnThemHot" runat="server" CssClass="btn-cart" 
                                            CommandName="ThemGioHang" CommandArgument='<%# Eval("MaSach") %>' 
                                            OnClientClick="event.stopPropagation();">MUA NGAY</asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#hotBooksCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#hotBooksCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <%-- SECTION 2: KHÁM PHÁ SÁCH MỚI CẬP NHẬT --%>
      <h2 class="hero-title">KHÁM PHÁ <span>SÁCH MỚI</span></h2>

        <asp:UpdatePanel ID="upHome" runat="server">
            <ContentTemplate>
                <div class="book-grid">
                    <asp:Repeater ID="rptSach" runat="server" OnItemCommand="rptSach_ItemCommand">
                        <ItemTemplate>
                            <div class="book-card" onclick="window.location.href='chitiet.aspx?MaSach=<%# Eval("MaSach") %>'">
                                <div class="card-img">
                                    <div class="tags-overlay"><%# RenderTags(Eval("Tags")) %></div>
                                    <img src='<%# "../Images/" + (Eval("AnhBia") != DBNull.Value ? Eval("AnhBia") : "no-image.jpg") %>' alt="New Book" />
                                </div>
                                <div class="card-body p-0">
                                    <div class="book-title"><%# Eval("TenSach") %></div>
                                    <span class="book-price"><%# string.Format("{0:#,##0} đ", Eval("Dongia")) %></span>
                                    <div class="view-count" style="color:#10b981; font-weight:600;"><i class="fa-regular fa-calendar-check"></i> <%# Eval("Ngaycapnhat", "{0:dd/MM/yyyy}") %></div>
                                </div>
                                <asp:LinkButton ID="btnThemgiohang" runat="server" CssClass="btn-cart" CommandName="ThemGioHang" CommandArgument='<%# Eval("MaSach") %>' OnClientClick="event.stopPropagation();"><i class="fa-solid fa-cart-shopping me-2"></i> THÊM GIỎ HÀNG</asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <%-- PHẦN PHÂN TRANG GIỚI HẠN 5 MỤC --%>
                <div class="pagination-wrapper">
                    <asp:HyperLink ID="lnkPrev" runat="server" CssClass="page-nav"><i class="fa-solid fa-caret-left"></i></asp:HyperLink>
                    <asp:Repeater ID="rptPaging" runat="server">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkPage" runat="server" 
                                NavigateUrl='<%# "trangchu.aspx?page=" + Eval("PageIndex") %>'
                                Text='<%# Eval("PageText") %>'
                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "page-node active" : "page-node" %>'>
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:HyperLink ID="lnkNext" runat="server" CssClass="page-nav"><i class="fa-solid fa-caret-right"></i></asp:HyperLink>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <%-- NGUỒN DỮ LIỆU TỪ SQL SERVER --%>
        <asp:SqlDataSource ID="SqlDataSourceCarousel" runat="server" 
            ConnectionString="<%$ ConnectionStrings:BookStoreDB %>"
            SelectCommand="SELECT TOP 10 * FROM Sach WHERE TrangThai=1 ORDER BY ISNULL(Soluotxem, 0) DESC">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSourceSach" runat="server" 
            ConnectionString="<%$ ConnectionStrings:BookStoreDB %>"
            SelectCommand="SELECT TOP 12 * FROM Sach WHERE TrangThai=1 ORDER BY Ngaycapnhat DESC">
        </asp:SqlDataSource>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Thuật toán hiển thị nhiều mục trên 1 slide cho Bootstrap 5 Carousel
        let items = document.querySelectorAll('#hotBooksCarousel .carousel-item');

        items.forEach((el) => {
            const minPerSlide = 4; // Số sách muốn hiện trên 1 hàng Desktop
            let next = el.nextElementSibling;
            for (var i = 1; i < minPerSlide; i++) {
                if (!next) {
                    // Nếu hết item thì quay lại item đầu tiên (vòng lặp vô tận)
                    next = items[0];
                }
                let cloneChild = next.cloneNode(true);
                el.appendChild(cloneChild.children[0]);
                next = next.nextElementSibling;
            }
        });
    </script>
</asp:Content>