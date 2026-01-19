USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'BookStoreDB')
    DROP DATABASE BookStoreDB;
GO
CREATE DATABASE BookStoreDB;
GO
USE [BookStoreDB];
GO

-- 1. TẠO CẤU TRÚC BẢNG
CREATE TABLE [dbo].[Role](
    [MaRole] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenRole] [nvarchar](50) NOT NULL
);

CREATE TABLE [dbo].[PhanLoai](
    [MaLoai] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenLoai] [nvarchar](100) NOT NULL
);

CREATE TABLE [dbo].[ChuDe](
    [MaCD] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Tenchude] [nvarchar](100) NULL,
    [MaLoai] [int] NULL
);

CREATE TABLE [dbo].[NhaXuatBan](
    [MaNXB] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenNXB] [nvarchar](100) NULL,
    [Diachi] [nvarchar](150) NULL,
    [Dienthoai] [nvarchar](15) NULL
);

CREATE TABLE [dbo].[KhachHang](
    [MaKH] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [HoTenKH] [nvarchar](50) NULL,
    [Diachi] [nvarchar](150) NULL,
    [Dienthoai] [nvarchar](15) NULL,
    [TenDN] [nvarchar](15) NULL,
    [Matkhau] [nvarchar](15) NULL,
    [Ngaysinh] [datetime] NULL,
    [Email] [nvarchar](50) NULL,
    [MaRole] [int] NULL
);

CREATE TABLE [dbo].[Sach](
    [MaSach] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenSach] [nvarchar](100) NULL,
    [MaCD] [int] NULL,
    [MaNXB] [int] NULL,
    [Dongia] [decimal](10, 2) NULL,
    [Mota] [nvarchar](max) NULL,
    [AnhBia] [nvarchar](100) NULL,
    [Ngaycapnhat] [datetime] NULL,
    [Soluotxem] [int] NULL,
    [Tags] [nvarchar](max) NULL,
    [Soluongton] [int] DEFAULT 0,
    [TrangThai] [bit] DEFAULT 1
);

CREATE TABLE [dbo].[TacGia](
    [MaTG] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TenTG] [nvarchar](50) NULL,
    [Diachi] [nvarchar](150) NULL,
    [Dienthoai] [nvarchar](15) NULL
);

CREATE TABLE [dbo].[VietSach](
    [MaTG] [int] NOT NULL,
    [MaSach] [int] NOT NULL,
    [Vaitro] [nvarchar](100) NULL,
    CONSTRAINT [PK_VIETSACH] PRIMARY KEY ([MaTG], [MaSach])
);

CREATE TABLE [dbo].[DonDatHang](
    [SoDH] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaKH] [int] NULL,
    [NgayDH] [datetime] NULL,
    [Trigia] [decimal](10, 2) NULL,
    [Dagiao] [bit] NULL,
    [Ngaygiao] [datetime] NULL
);

CREATE TABLE [dbo].[CTDatHang](
    [MaSach] [int] NOT NULL,
    [SoDH] [int] NOT NULL,
    [Soluong] [int] NULL,
    [Dongia] [decimal](10, 2) NULL,
    [Thanhtien] [decimal](10, 2) NULL,
    CONSTRAINT [PK_CTDATHANG] PRIMARY KEY ([MaSach], [SoDH])
);

CREATE TABLE [dbo].[Comment](
    [MaBL] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaSach] [int] NOT NULL,
    [MaKH] [int] NOT NULL,
    [NoiDung] [nvarchar](max) NULL,
    [NgayBL] [datetime] DEFAULT GETDATE(),
    [DanhGia] [int] CHECK ([DanhGia] >= 1 AND [DanhGia] <= 5)
);
GO

-- 2. CHÈN DỮ LIỆU
SET IDENTITY_INSERT [dbo].[Role] ON;
INSERT INTO [dbo].[Role] ([MaRole], [TenRole]) VALUES (1, N'Người mua'), (2, N'Người bán');
SET IDENTITY_INSERT [dbo].[Role] OFF;

SET IDENTITY_INSERT [dbo].[PhanLoai] ON;
INSERT INTO [dbo].[PhanLoai] ([MaLoai], [TenLoai]) VALUES (1, N'KTGD (Kiến thức giáo dục)'), (2, N'TT (Truyện tranh)'), (3, N'TC (Tạp chí)');
SET IDENTITY_INSERT [dbo].[PhanLoai] OFF;

SET IDENTITY_INSERT [dbo].[ChuDe] ON;
INSERT INTO [dbo].[ChuDe] ([MaCD], [Tenchude], [MaLoai]) VALUES 
(38, N'Văn học', 1), (5, N'Tin học', 1), (6, N'Kinh tế', 1), (12, N'Khoa học cơ bản', 1), (20, N'Mỹ thuật', 1), (21, N'Nghệ thuật', 1), (22, N'Âm nhạc', 1), (27, N'Nghệ thuật sống', 1), (29, N'Giới tính & sinh lý', 1), (33, N'Du lịch', 1),
(1, N'Truyện Cổ Tích', 2), (2, N'Truyện Dân Gian', 2), (3, N'Truyền Thuyết Đô Thị', 2), (4, N'Truyện Kinh Dị Dân Gian', 2), (7, N'Manga', 2), (8, N'Tiểu Thuyết Trinh Thám', 2), (9, N'Tiểu Thuyết Huyền Huyễn', 2), (10, N'Truyện Tranh Huyền Huyễn', 2),
(11, N'Tạp Chí Lịch Sử', 3), (13, N'Tạp Chí Du Lịch', 3), (14, N'Báo Phóng Sự', 3), (15, N'Tạp Chí Công Nghệ', 3), (16, N'Tạp Chí Địa Lý', 3);
SET IDENTITY_INSERT [dbo].[ChuDe] OFF;

SET IDENTITY_INSERT [dbo].[NhaXuatBan] ON;
INSERT INTO [dbo].[NhaXuatBan] ([MaNXB], [TenNXB], [Diachi], [Dienthoai]) VALUES 
(1, N'Nhà xuất bản Trẻ', N'161 Lý Chính Thắng - Q3, Tp.HCM', N'08.9316212'),
(2, N'Nhà xuất bản Giáo Dục', N'15 Nguyễn Huệ - Q1, Tp.HCM', N'08.1232345'),
(3, N'Nhà xuất bản Kim đồng', N'55 Quang Trung, Hà Nội', N'04.944730'),
(4, N'Nhà xuất bản Đại học quốc gia', N'03 Công trường Quốc tế - Q3, Tp.HCM', N'087242181'),
(5, N'Nhà xuất bản Văn hóa nghệ thuật', N'HCM', NULL),
(6, N'Nhà xuất bản Thể dục Thể thao', N'48 Nguyễn Đình Chiểu - Q1, Tp.HCM (Chi nhánh)', N'08.8298378'),
(7, N'Nhà xuất bản Phụ nữ', N'16 Alexandre De Rhodes - Q1, Tp.HCM (Chi nhánh)', N'08.8294459'),
(8, N'Nhà xuất bản Phương đông', N'', N''),
(9, N'Nhà xuất bản Tổng hợp Tp.HCM', N'62 Nguyễn Thị Minh Khai - Q1, Tp.HCM', N'08.8225340'),
(11, N'Nhà xuất bản TTXVN', N'126 Nguyễn Thị Minh - Q3, Tp.HCM', N'0908256402');
SET IDENTITY_INSERT [dbo].[NhaXuatBan] OFF;

SET IDENTITY_INSERT [dbo].[KhachHang] ON;
INSERT INTO [dbo].[KhachHang] ([MaKH], [HoTenKH], [Diachi], [Dienthoai], [TenDN], [Matkhau], [Ngaysinh], [Email], [MaRole]) 
VALUES (2, N'Nguyễn Văn Thành', NULL, N'0908256455', N'nvthanh', N'123', '2000-01-01', N'lbthanh2000@gmail.com', 1);
SET IDENTITY_INSERT [dbo].[KhachHang] OFF;

SET IDENTITY_INSERT [dbo].[Sach] ON;
INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem]) VALUES 
(29, N'Giáo Trình Lý Thuyết Tài Chính - Tiền Tệ ', 6, 5, 23000.00, N'Cuốn sách này không đi vào chi tiết những chủ đề quản lý cổ điển đã được nhắc đến trong nhiều cuốn sách khác như tổ chức cuộc họp, cung cấp số liệu, quản lý thời gian. Mục đích của cuốn sách này là mang lại cho bạn ""nhiều hơn"", một giá trị gia tăng so với những gì bạn đã biết và đã áp dụng, và giúp bạn tối ưu hóa việc quản lý chuyên môn và quản lý nhân sự.', N'KT0006.jpg', '2021-09-20', 0),
(32, N'Adobe Photoshop 6.0 ', 5, 4, 21000.00, N'Cuốn sách Adobe Photoshop 6.0 và ImageReady 3.0 này sẽ giúp bạn tìm hiểu những tính năng tuyệt vời của phiên bản 6.0, nó cũng là con đường ngắn nhất cho những người mới sử dụng Photoshop lần đầu. Với bạn đọc đã sử dụng cuốn sách ""Adobe Photoshop 5.5 và ImageReady 2.0"" do MK.PUB biên soạn trước đây, cuốn sách này là một cách cập nhật nhanh chóng nhất.', N'TH005.jpg', '2021-09-20', 0),
(33, N'Lập Trình Mạng Trên Windows ', 5, 3, 16800.00, N'Chào mừng đến với ""Lập Trình Mạng Trên Windows (Ấn bản dành cho sinh viên)"". Quyển sách này sẽ hướng dẫn bạn sử dụng một cách hiệu quả bao gồm một số lượng lớn và đa dạng các hàm mạng sẵn có trong Windows 95, Windows 98, Windows NT 4, Windows CE, và Windows 2000/XP/. NET. Sách được chủ định viết dành cho những lập trình viên từ trung cấp đến cao cấp, tuy nhiên những lập trình viên mới bắt đầu tìm hiểu lập trình mạng cũng sẽ nhận thấy đây là một quyển sách không thể thiếu cho các bước xây dựng ứng dụng mạng sau này.', N'TH001.jpg', '2021-09-20', 0),
(9, N'Cấu Trúc Máy Vi Tính', 5, 1, 30000.00, N'Máy vi tính ngày càng giữ một vai trò quan trọng trong các lĩnh vực khoa học kỹ thuật và cuộc sống hàng ngày. Sự phát triển nhanh chóng của cả công nghệ phần cứng và phần mềm đã tạo nên các thế hệ máy mới cho phép thu nhập và xử lý dữ liệu ngày càng mạnh hơn. Tuy nhiên những cải tiến này vẫn dựa trên một số cơ sở ban đầu, chừng nào mà những nguyên tắc căn bản của máy tính vẫn chưa thay đổi. Vì vậy, việc mô tả một cách toàn diện tỉ mỉ cấu trúc của máy vi tính là điều khó khăn, nhất là phải đưa ra các thông tin vừa cơ bản, vừa cập nhật.', N'Cautrucmaytinh.jpg', '2021-09-20', 0),
(10, N'Chuyện Kể Về Những Nhà Khoa Học Trái Đất Và Thiên Văn Nổi Tiếng Thế Giới (Tái Bản Có Bổ Sung)', 12, 7, 25000.00, N'Cho tới nay, con người đã hiểu biết được khá nhiều về lục địa, về đại dương, về các vì sao trên bầu trời. Hơn thế nữa, con người đã bay lên và đổ bộ xuống Mặt Trăng để khám phá những bí mật ở đó...', N'caosuvietnam.jpg', '2021-09-20', 0),
(12, N'Marketing Du Lịch (Sách Hướng Dẫn Du Lịch Việt Nam)', 33, 5, 27000.00, N'Cuốn Marketing Du Lịch (Sách Hướng Dẫn Du Lịch Việt Nam) này được biên soạn nhằm đáp ứng nhu cầu nghiên cứu, làm tài liệu tham khảo để vận dụng Marketing vào các Công ty Du lịch, Khách sạn Nhà hàng, Doanh nghiệp Lữ hành, Đại lý dụ lịch, Tour du lịch… Nội dung cuốn sách bao gồm :', N'Marketingdulich.jpg', '2021-09-20', 0),
(30, N'Cán Bộ Quản Lý Trong Sản Xuất Công Nghiệp', 6, 4, 25000.00, N'Cuốn sách này gồm những nội dung chính sau:', N'KT0001.jpg', '2021-09-20', 0),
(31, N'Tin Học Văn Phòng - Microsoft Word 2000 ', 5, 3, 16800.00, N'Cuốn sách này gồm những nội dung chính sau:', N'TH004.jpg', '2021-09-20', 0),
(35, N'Căn Bản Về Photoshop CS Tinh Chỉnh Và Xử Lý Màu ', 5, 7, 25000.00, N'Căn Bản Về Photoshop CS Tinh Chỉnh Và Xử Lý Màu gồm 12 chương:', N'TH002.jpg', '2021-09-20', 0),
(13, N'Nghiệp Vụ Lễ Tân Khách Sạn', 33, 3, 24000.00, N'Kinh doanh khách sạn là kinh doanh dịch vụ đóng một vai trò quan trọng trong nền kinh tế quốc dân, đặc biệt là đối với những nước đang phát triển ngành du lịch.', N'Nghiepvuletan.jpg', '2021-09-20', 0),
(7, N'Cao Su Việt Nam Thực Trạng Và Giải Pháp Phát Triển', 6, 4, 18000.00, N'Cuốn sách Cao Su Việt Nam Thực Trạng Và Giải Pháp Phát Triển giới thiệu nội dung:', N'caosuvietnam.jpg', '2021-09-20', 0),
(8, N'Kiến Trúc Máy Tính', 5, 1, 30000.00, N'Giáo trình Kiến Trúc máy tính này trình bày các vấn đề chung nhất, các thành phần cơ bản nhất cấu thành nên Máy tính điện tử hiện đại.', N'Kientrucmaytinh.jpg', '2021-09-20', 0),
(16, N'Phạm Duy - Đưa Em Tìm Động Hoa Vàng (Tập 2)', 22, 1, 26000.00, N'Nội dung tập Nhạc của Tác giả Phạm Duy ""Đưa Em Tìm Động Hoa Vàng"" giới thiệu các ca khúc:', N'Phamduy.jpg', '2021-09-20', 0),
(15, N'Tìm Hiểu Văn Hóa Của Người Trung Quốc - Nhật Bản - Hàn Quốc', 33, 2, 40000.00, N'Nền văn hóa phương Đông chứa đựng những thành phần quan trọng mà nền văn hóa Tây phương còn thiếu. Đúng là vì có sự tồn tại của người khác, mới có thể nhìn rõ được diện mạo của mình, mới có thể biết được mình là ai. Nếu không nhìn thấy nền văn hóa của những khu vực khác, có lẽ sẽ khiến mình sa vào những cảnh ngộ nguy hiểm. ', N'Vanhoatrungquoc.jpg', '2021-09-20', 0),
(17, N'Hát Nữa Đi Em - 100 Ca Khúc Trữ Tình Được Yêu Thích Nhất ', 22, 3, 42000.00, N'Tập sách hát ""Hát Nữa Đi Em"" tuyển chọn 100 ca khúc trữ tình được yêu thích nhất như: Thuyền Hoa; Trở về cát bụi; Ăn năn; Bến tương tư; Cho vừa lòng em; Hai mươi năm tình đẹp mùa chôm chôm; ...', N'Hatnuadiem.jpg', '2021-09-20', 0),
(18, N'Huyền Thoại Mẹ (Tuyển Tập Các Ca Khúc Về Mẹ)', 22, 4, 24500.00, N'Tuyển Tập Các Ca Khúc Về Mẹ ""Huyền Thoại Mẹ"" sẽ giới thiệu đến các bạn những bài hát đầy cảm xúc thương yêu và hùng tráng về người mẹ huyền thoại, người mẹ của đời thường. Sách gồm 50 bài hát của nhiều tác giả đã từng quen thuộc với chúng ta như : Vĩnh An, Xuân Hồng, Phó Đức Phương, Hoàng Việt, Thuận Yến... ', N'Huyenthoaime.jpg', '2021-09-20', 0),
(19, N'Như Đã Dấu Yêu (80 Ca Khúc Được Yêu Thích)', 22, 5, 40000.00, N'Cuốn sách này giới thiệu cùng các bạn 80 ca khúc được yêu thích như: Áo lụa Hà đông; Biệt khúc; Đêm thấy ta là thác đổ; Đóa hoa vô thường; Đừng xa em đêm nay; Đường xa ướt mưa; Em hãy ngủ đi v.v...', N'Nhudadauyeu.jpg', '2021-09-20', 0),
(14, N'Alô Việt Nam - Cẩm Nang Dịch Vụ - Giải Trí Thành Phố Hồ Chí Minh (Tập 1)', 33, 5, 26500.00, N'Áp lực công việc và bao lo toan trong cuộc sống nhiều lúc làm bạn mệt mỏi và cảm thấy chán nản. Những ngày cuối tuần hay nghỉ phép được nghỉ ngơi cùng gia đình, bạn bè..., bạn cũng muốn đi đâu đó để giảm stress, chuẩn bị cho một tuần làm việc và học tập tiếp theo. Thế nhưng chơi gì, ở đâu luôn là câu hỏi làm bạn băn khoăn. Để giải quyết những khó khăn này. Cuốn sách ""Alô Việt Nam - Cẩm Nang Dịch Vu ﭠGiải Trí Thành Phố Hồ Chí Minh (Tập 1)"" cung cấp cho bạn những thông tin cần thiết như: địa chỉ, số điện thoại, các dịch vụ... của tất cả các điểm vui chơi giải trí trên địa bàn thành phố, giúp bạn dễ dàng lựa chọn được những dịch vụ tốt nhất, phù hợp nhất cho bạn và gia đình. Ngoài ra, còn cung cấp những thông tin chi tiết về các chương trình cần ở một chỗ mà vẫn có thể biết tất cả những hoạt động giải trí thành phố và tự chọn cho mình địc điểm phù hợp nhất để tận hưởng những giây phút nghỉ ngơi hiếm hoi với gia đình và bạn bè.', N'aloVietnam.jpg', '2021-09-20', 0),
(20, N'Tuyển Tập 101 Ca Khúc Việt Nam Quê Hương Tôi - Giai Điệu Tổ Quốc', 22, 11, 50000.00, N'Tuyển Tập 101 Ca Khúc Việt Nam Quê Hương Tôi - Giai Điệu Tổ Quốc là một tuyển tập được thực hiện nghiêm túc, chọn lọc hầu hết các ca khúc viết về quê hương, đất nước được nhiều thành phần, nhiều thế hệ yêu thích. ', N'101Cakhuc.jpg', '2021-09-20', 0),
(23, N'Tin Học Ứng Dụng: Thành Thạo Oracle 9i - Quản Trị Cơ Sở Dữ Liệu (Tập 1) ', 5, 4, 21000.00, N'Mục đích của bộ sách này giúp bạn trở nên thành thạo cơ sở dữ liệu (CSDL) Oracle9i, đề cập đến tất cả những kiến thức cần thiết từ mô hình dữ liệu, quản trị CSDL, sao lưu phục hồi, mạng và xử lý sự cố cũng như hiệu chỉnh hiệu suất thực thi..., với sự kết hợp lý thuyết và thực hành về điều mà Nhà quản trị CSDL Oracle9i cần biết để sử dụng CSDL Oracle9i một cách hiệu quả từ chính bộ sách này.', N'TH006.jpg', '2021-09-20', 0),
(22, N'Thủ Thuật Lập Trình Visual Basic 6 ', 5, 3, 18000.00, N'Mục Lục:', N'TH008.jpg', '2021-09-20', 0),
(24, N'Mạng Máy Tính Và Hệ Thống Bảo Mật ', 5, 3, 23000.00, N'Mạng Máy Tính Và Hệ Thống Bảo Mật gồm 7 chương:', N'KT0007.jpg', '2021-09-20', 0),
(27, N'Điều Chỉnh Một Số Chính Sách Kinh Tế Ở Trung Quốc (Giai Đoạn 1992 - 2010)', 6, 3, 21000.00, N'Cuốn sách này tập trung vào một số nội dung chính sau đây:', N'KT0004.jpg', '2021-09-20', 0),
(25, N'Tư Duy Chiến Lược (Quản Lý - Tại Sao? Thế Nào?', 6, 4, 18000.00, N'Khả năng hoạch định dài hạn đồng thời tối ưu hóa tình hình hoạt động ngắn hạn là một yêu cầu bắt buộc phải có đối với các nhà quản lý.Tư Duy Chiến Lược sẽ giúp bạn vạch ra con đường đến thành công đồng thời giúp hình thành các kỹ năng phân tích và hoạch định theo nhóm. Tất cả các lĩnh vực then chốt để hình thành và thực thi một chiến lược đều được trình bày cặn kẽ trong cuốn sách này, từ việc nghiên cứu và thu thập thông tin nền tảng, hình thành một chiến lược mới đến việc xem xét và ứng dụng chiến lược ấy. Cả thảy có 101 chỉ dẫn nhằm cung cấp cho các bạn những lời khuyên thực tiễn hơn, đồng thời bài tập tự đánh giá sẽ giúp bạn xác định xem mình là một nhà tư duy chiến lược hiệu quả đến mức nào. Khi bạn có nhiều tham vọng hơn về việc hoạch định cho tương lai, cẩm nang này sẽ là quyển sách tham khảo không thể thiếu, giúp suy nghĩ của bạn đi đúng hướng.', N'KT0003.jpg', '2021-09-20', 0),
(26, N'Quản Lý Dự Án (Quản Lý - Tại Sao? Thế Nào?) ', 6, 3, 61000.00, N'Để thành công trong môi trường kinh doanh cạnh tranh hiện nay, các giám đốc dự án phải đạt được kết quả trong phạm thời gian và ngân sách đưa ra. Biết cách áp dụng các quy trình, phương pháp và kỹ thuật chỉ dẫn trong cuốn Quản Lý Dự Án này, bạn sẽ tăng tối đa khả năng thực hiện công việc và đảm bảo đạt kết quả tối ưu khi thực hiện dự án.', N'KT0002.jpg', '2021-09-20', 0),
(28, N'Phong Cách Quản Lý Kinh Doanh Hiện Đại ', 6, 4, 61000.00, N'Cuốn sách này không đi vào chi tiết những chủ đề quản lý cổ điển đã được nhắc đến trong nhiều cuốn sách khác như tổ chức cuộc họp, cung cấp số liệu, quản lý thời gian. Mục đích của cuốn sách này là mang lại cho bạn ""nhiều hơn"", một giá trị gia tăng so với những gì bạn đã biết và đã áp dụng, và giúp bạn tối ưu hóa việc quản lý chuyên môn và quản lý nhân sự.', N'KT0005.jpg', '2021-09-20', 0),
(1, N'Con tôi đi học và kết bạn', 27, 2, 30000.00, N'Con tôi đi học và kết bạn hướng sự quan tâm nghiên cứu đến lứa tuổi từ 6 đến 12, là giai đoạn quan trọng thứ hai trong cuộc đời của trẻ. Đây cũng là lứa tuổi ham hiểu biết, khát khao tìm tòi cái mới, tựa như nhà thám hiểm dũng cảm một mình giong buồm hướng tới những bến bờ xa lạ. Và hơn hết, đây là giai đoạn khẳng định tính độc lập, ý thức về bản thân và thế giới mình đang sống.', N'con-toi-di-hoc.jpg', '2021-09-20', 0),
(2, N'Kỹ năng chăm sóc bé - khi con giận dỗi', 20, 3, 20000.00, N'Sách là những lời khuyên thiết thực cho những ai mới làm cha mẹ và đang phải đối phó với mọi tình huống rắc rối do trẻ mang lại.', N'khi-con-gian-doi.jpg', '2021-09-20', 0),
(3, N'Xua tan đi mọi rắc rối', 27, 3, 19000.00, N'Hãy để con thuyền cuộc đời lướt trôi nhẹ nhàng khi nó chỉ chuyên chở những thứ thật cần thiết: một tổ ấm đơn sơ, niềm vui sống thanh sạch; một vài người bạn đáng quý, một ai đó để yêu và ai đó yêu mình; một chú mèo và một chú chó, mấy cái tẩu hút thuốc, chút gì đó để nhấp môi..."". Đây là lời tựa của cuốn sách mà NXB Trẻ trân trọng giới thiệu cùng bạn đọc.', N'xuatan.jpg', '2021-09-20', 0),
(5, N'Tại sao đàn ông nói dối, đàn bà nói nhiều', 29, 7, 26000.00, N'Một người phụ nữ chỉ cần biết rõ một người đàn ông là có thể hiểu tất cả đàn ông; nhưng một người đàn ông biết tất cả phụ nữ vẫn không hiểu rõ một người phụ nữ ”. (Helen Rowland). Quả thật, giữa họ là cả một mối quan hệ đầy phức tạp khó mà hòa hợp…', N'Noidoi-noinhieu.jpg', '2021-09-20', 0),
(6, N'Để trở thành người phụ nữ mạnh mẽ', 21, 7, 24000.00, N'Đúng như tên gọi của quyển sách, tác giả đưa ra những kinh nghiệm, những bí quyết để giúp người phụ nữ thay đổi bản thân, và trở thành người phụ nữ quyền năng - làm chủ bản thân, thành công trong sự nghiệp, tình cảm, cuộc sống đầy đủ và trọn vẹn. Các chương trong cuốn sách tập trung vào ba mục tiêu chính, mà theo tác giả đó là điều phụ nữ cần đạt được, đó là tự do, tình yêu và cuộc sống. Từng bước làm cụ thể con đường nhanh và hiệu quả để đạt ba mục tiêu đó, được tác giả trình bày thật dễ hiểu, ngôn từ giản dị, có sự kết hợp những câu nói của những nhân vật nổi tiếng, càng làm cho cuốn sách thêm sinh động và hấp dẫn.', N'Phunumanhme.jpg', '2021-09-20', 0),
(4, N'Đàn ông cũng khóc', 29, 5, 185000.00, N'Mỗi người đều có cách lựa chọn cho mình một cuộc sống riêng, xem ra ai cũng có cái lý của mình. Nhưng nếu chỉ nghĩ đến mình thôi thì thật khó có hạnh phúc gia đình trọn vẹn. Bạn biết đấy, khi cuộc sống lứa đôi có vấn đề thì không chỉ có phụ nữ mới đau khổ mà đàn ông đôi khi cũng rơi lệ. Đàn ông khóc vì ở họ luôn tồn tại những mâu thuẫn mà nhiều khi chỉ có thể giải quyết bằng nước mắt. Còn đàn ông ghen... cũng cho đáng mặt đàn ông, nghĩa là không dại gì mà không ghen, nhưng ghen sao cho chính đáng chứ đừng ghen bậy, ghen ảo thì chẳng đáng được một tiếng ghen!Đàn ông rất dễ thương khi vào bếp vì đấy là cách họ chia sẻ những lo toan tất bật cùng người phụ nữ của mình. Những câu chuyện trong quyển sách này là những minh hoạ rất sinh động xoay quanh đời sống lứa đôi. Hy vọng được bạn đọc chia sẻ và rút ra những điều bổ ích cho mình vì ""Hôn nhân là mối quan hệ giữa người đàn ông và người đàn bà, mà sự độc lập của hai bên như nhau, sự phụ thuộc là ở cả hai phía, còn trách nhiệm là của cả hai người', N'Danongcungkhoc.gif', '2021-09-20', 0);
SET IDENTITY_INSERT [dbo].[Sach] OFF;
--chủ đề 2: mã loại 2: cd:1 ; truyện cổ tích
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(36, N'Truyện Cổ Tích Việt Nam: Tấm Cám', 1, 3, 15000.00, 
N'Tấm Cám là một trong những câu chuyện cổ tích đặc sắc nhất trong kho tàng văn học dân gian Việt Nam. Câu chuyện xoay quanh cuộc đời của cô Tấm hiền lành, xinh đẹp nhưng phải trải qua bao nỗi cay đắng, vất vả dưới bàn tay tàn độc của mẹ con Cám. Qua nhiều lần luân hồi từ chim vàng anh, cây xoan đào đến quả thị, cô Tấm cuối cùng cũng tìm lại được hạnh phúc bên cạnh nhà vua. Đây là bài ca về sự chiến thắng của cái thiện trước cái ác và triết lý nhân quả sâu sắc của dân tộc.', 
N'tamcam.jpg', GETDATE(), 0, N'Cổ tích, Truyện tranh, Tấm Cám', 20, 1),

(37, N'Truyện Cổ Tích Việt Nam: Sự Tích Trầu Cau', 1, 3, 12000.00, 
N'Câu chuyện kể về tình anh em gắn bó giữa hai anh em Tân và Lang, cùng nghĩa vợ chồng son sắt. Vì những hiểu lầm không đáng có, họ đã hóa thân thành cây cau, tảng đá vôi và dây trầu không quấn quýt bên nhau mãi mãi. Tục ăn trầu từ đó cũng ra đời, trở thành biểu tượng cho sự gắn kết, khởi đầu cho mọi câu chuyện giao tiếp và là một nét văn hóa độc đáo không thể thiếu trong đời sống tinh thần của người Việt Nam từ bao đời nay.', 
N'traucau.jpg', GETDATE(), 0, N'Cổ tích, Văn hóa, Trầu cau', 15, 1),

(38, N'Truyện Cổ Tích Việt Nam: Thạch Sanh', 1, 3, 18000.00, 
N'Thạch Sanh là hình tượng người anh hùng dân gian tiêu biểu với sức mạnh phi thường và tấm lòng nhân hậu. Từ một chàng trai nghèo khổ sống dưới gốc đa, Thạch Sanh đã dũng cảm diệt Chằn tinh, bắn đại bàng cứu công chúa, và dùng tiếng đàn thần kỳ để đẩy lùi quân giặc. Câu chuyện không chỉ ca ngợi lòng dũng cảm, chính trực mà còn phê phán sự gian trá, xảo quyệt của Lý Thông, đồng thời gửi gắm khát vọng về hòa bình và công lý của nhân dân lao động.', 
N'thachsanh.jpg', GETDATE(), 0, N'Anh hùng, Diệt quái, Thạch Sanh', 25, 1),

(39, N'Truyện Cổ Tích Việt Nam: Sơn Tinh - Thủy Tinh', 1, 3, 20000.00, 
N'Bối cảnh đời Hùng Vương thứ mười tám, khi vua muốn kén rể cho công chúa Mỵ Nương. Cuộc so tài giữa Sơn Tinh (Thần núi) và Thủy Tinh (Thần nước) với những phép thần thông biến hóa khôn lường đã tạo nên một thiên sử thi kỳ ảo. Thủy Tinh thua trận, dâng nước lũ trả thù hàng năm nhưng đều bị Sơn Tinh chặn đứng. Câu chuyện giải thích hiện tượng thiên nhiên lũ lụt định kỳ và ca ngợi tinh thần kiên cường chống chọi với thiên tai của người Việt cổ.', 
N'sontinhthuytinh.jpg', GETDATE(), 0, N'Thần thoại, Sử thi, Sơn Tinh', 30, 1),

(40, N'Truyện Cổ Tích Việt Nam: Cây Tre Trăm Đốt', 1, 3, 15000.00, 
N'Chàng Khoai hiền lành, khỏe mạnh làm thuê cho lão địa chủ với lời hứa gả con gái. Thế nhưng lão nhà giàu gian ác đã bày mưu bắt chàng phải tìm cho được cây tre có đủ trăm đốt để làm sính lễ. Nhờ sự giúp đỡ của Bụt và câu thần chú ""Khắc nhập, khắc xuất"", chàng Khoai đã dạy cho lão địa chủ một bài học thích đáng và cưới được người mình yêu. Câu chuyện mang đến tiếng cười sảng khoái và khẳng định chân lý: người hiền lành, chăm chỉ sẽ luôn được đền đáp xứng đáng.', 
N'caytre100dot.jpg', GETDATE(), 0, N'Hài hước, Công lý, Chàng Khoai', 20, 1);
SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd2:truyện nhân gian
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(41, N'Truyện Dân Gian: Sự Tích Dưa Hấu (Mai An Tiêm)', 2, 1, 18000.00, 
N'Câu chuyện về Mai An Tiêm là một bài học sâu sắc về ý chí tự lực cánh sinh và lòng kiên trì của con người. Bị đày ra đảo hoang vì một câu nói ngay thẳng, Mai An Tiêm đã không gục ngã trước nghịch cảnh. Nhờ công chăm sóc loài cây lạ do chim mang đến, ông đã tìm ra giống dưa quý có ruột đỏ, vị ngọt thanh. Qua hình ảnh Mai An Tiêm, truyện ca ngợi những con người lao động sáng tạo, không chịu khuất phục trước số phận và khẳng định giá trị của bàn tay và khối óc con người.', 
N'duahau.jpg', GETDATE(), 0, N'Dân gian, Mai An Tiêm, Ý chí', 35, 1),

(42, N'Truyện Dân Gian: Bánh Chưng Bánh Giày', 2, 2, 15000.00, 
N'Lấy bối cảnh đời Hùng Vương thứ sáu, câu chuyện kể về cuộc thi tài tìm người nối ngôi vị vua cha. Khác với các anh em dâng lên những sản vật sơn hào hải vị xa xỉ, chàng hoàng tử Lang Liêu hiền hậu đã dùng những hạt gạo nếp quý giá của đồng quê để làm nên hai loại bánh: Bánh Chưng tượng trưng cho Đất và Bánh Giày tượng trưng cho Trời. Câu chuyện giải thích nguồn gốc của món bánh truyền thống trong ngày Tết và đề cao nghề nông cùng lòng hiếu thảo của con cái đối với cha mẹ.', 
N'banhchung.jpg', GETDATE(), 0, N'Văn hóa, Tết, Lang Liêu', 40, 1),

(43, N'Truyện Dân Gian: Sự Tích Hồ Gươm', 2, 9, 22000.00, 
N'Một truyền thuyết oai hùng gắn liền với lịch sử giữ nước của dân tộc và vẻ đẹp của thủ đô Hà Nội. Câu chuyện kể về việc đức Long Quân cho Lê Lợi mượn thanh gươm thần để đánh đuổi giặc Minh xâm lược. Sau khi đất nước thanh bình, trong một lần dạo chơi trên hồ Tả Vọng, Rùa Vàng đã hiện lên đòi lại gươm thần. Truyện ca ngợi cuộc kháng chiến chính nghĩa của nhân dân ta và thể hiện khát vọng hòa bình, biểu tượng cho sức mạnh đoàn kết của toàn dân tộc.', 
N'hoguom.jpg', GETDATE(), 0, N'Lịch sử, Lê Lợi, Hồ Gươm', 15, 1),

(44, N'Truyện Dân Gian: Thánh Gióng', 2, 3, 25000.00, 
N'Thánh Gióng là biểu tượng rực rỡ của lòng yêu nước và sức mạnh quật khởi của nhân dân Việt Nam. Hình ảnh chú bé ba tuổi không biết nói biết cười, bỗng chốc vươn vai thành tráng sĩ, cưỡi ngựa sắt, mặc giáp sắt, cầm roi sắt xông trận diệt giặc Ân đã trở thành huyền thoại bất tử. Câu chuyện không chỉ mang màu sắc kỳ ảo mà còn khẳng định truyền thống chống giặc ngoại xâm có từ ngàn xưa, khi Tổ quốc cần, cả trẻ thơ cũng có thể trở thành anh hùng.', 
N'thanhgiong.jpg', GETDATE(), 0, N'Anh hùng, Chống giặc, Phù Đổng', 20, 1),

(45, N'Truyện Dân Gian: Sự Tích Con Rồng Cháu Tiên', 2, 4, 16000.00, 
N'Đây là câu chuyện cội nguồn thiêng liêng về nòi giống của người Việt Nam. Sự kết duyên giữa thần Lạc Long Quân dòng dõi Rồng và nàng tiên Âu Cơ đã sinh ra bọc trăm trứng, nở ra một trăm người con trai khỏe mạnh. Cuộc chia ly năm mươi người xuống biển, năm mươi người lên non để mở mang bờ cõi đã tạo nên sự gắn kết anh em đồng bào bền chặt. Truyện giải thích tên gọi ""Đồng bào"" và khơi dậy niềm tự hào dân tộc, tinh thần đoàn kết của người Việt qua hàng nghìn năm văn hiến.', 
N'conrongchautien.jpg', GETDATE(), 0, N'Cội nguồn, Lạc Long Quân, Âu Cơ', 50, 1);
SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
USE [BookStoreDB];
GO
--Chủ đề 3: Truyền Thuyết Đô Thị (MaCD = 3, MaLoai = 2)
SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(47, N'Chuyến Xe Buýt Số 44', 3, 7, 35000.00, 
N'Dựa trên một truyền thuyết đô thị nổi tiếng về chuyến xe buýt cuối cùng trong đêm chạy qua những cung đường ngoại ô vắng vẻ. Chuyện kể về một tài xế tận tâm và những hành khách kỳ lạ xuất hiện trên xe vào những khung giờ linh thiêng. Những tình tiết hư thực đan xen, những khuôn mặt không cảm xúc và những lời thì thầm bên tai khiến người đọc không khỏi rùng mình trước ranh giới mong manh giữa cõi người và cõi âm. Cuốn sách không chỉ là những màn hù dọa mà còn là lời cảnh báo về sự vô cảm của con người trong xã hội hiện đại thông qua một cốt truyện kinh dị đầy kịch tính với những nút thắt bất ngờ ở phút cuối.', 
N'xebuyt44.jfif', '2021-09-20', 0, N'Kinh dị, Xe buýt, Tâm linh', 12, 1),

(48, N'Chung Cư 727 Trần Hưng Đạo', 3, 9, 55000.00, 
N'Khám phá những lời đồn thổi kinh hoàng xung quanh một trong những tòa nhà được mệnh danh là ám ảnh nhất Sài Gòn. Với những chi tiết rùng rợn về "trấn yểm bùa chú" bằng mạng người và những bóng ma không đầu được cư dân đồn đại qua nhiều thập kỷ, cuốn sách tái hiện một không gian u uất, cổ kính và đầy tử khí. Đây không chỉ là một câu chuyện kinh dị đơn thuần mà còn là sự kết hợp khéo léo giữa yếu tố tâm linh phong thủy dân gian và lịch sử đô thị đầy biến động, tạo nên một sức hút khó cưỡng cho những ai thích khám phá sự bí ẩn ẩn giấu sau những bức tường rêu phong.', 
N'chungcu727.jfif', '2021-09-20', 0, N'Sài Gòn, Tâm linh, Chung cư', 8, 1),

(49, N'Bóng Người Trong Gương', 3, 11, 40000.00, 
N'Gương luôn là vật phẩm chứa đựng nhiều yếu tố ma mị và kiêng kỵ trong văn hóa phương Đông lẫn phương Tây. Cuốn sách này khai thác nỗi sợ nguyên thủy về một thực thể khác tồn tại song song phía sau tấm gương phản chiếu. Những câu chuyện về việc nhìn thấy một gương mặt lạ đang mỉm cười với mình trong gương lúc nửa đêm, hay cái bóng vẫn đứng im khi chủ nhân đã rời đi sẽ khiến bạn phải cân nhắc kỹ trước khi soi gương vào ban đêm. Truyện đánh mạnh vào yếu tố tâm lý, những ảo giác sợ hãi và sự ám ảnh về một thế giới gương đầy nguy hiểm đang chờ chực xâm nhập vào đời thực.', 
N'guong.jpg', '2021-09-20', 0, N'Kinh dị, Tâm lý, Ám ảnh', 20, 1),

(50, N'Hầm Thủ Thiêm - Những Lời Đồn Thổi', 3, 5, 42000.00, 
N'Hầm Thủ Thiêm không chỉ là công trình giao thông hiện đại biểu tượng của thành phố mà còn là nơi thêu dệt nên nhiều câu chuyện kỳ bí từ lúc khởi công cho đến khi hoàn thành. Cuốn sách thu thập những lời kể lạnh sống lưng của các tài xế đêm về những bóng người đi bộ ngược chiều giữa làn xe chạy hay những ánh đèn lạ thường xuất hiện rồi biến mất trong chớp mắt dưới lòng sông Sài Gòn. Một góc nhìn khác đầy ma mị và u tối về một công trình kiến trúc hiện đại dưới ánh đèn vàng hiu hắt, nơi những âm thanh vọng lại từ vách hầm có thể khiến những người gan dạ nhất cũng phải chùn bước.', 
N'hamthuthiem.jpg', '2021-09-20', 0, N'Đô thị, Hiện đại, Bí ẩn', 15, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
USE [BookStoreDB];
GO
--Chủ đề 4: Truyện Kinh Dị Dân Gian
SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(51, N'Linh Miêu Và Quỷ Nhập Tràng', 4, 3, 50000.00, 
N'Cuốn sách khai thác một trong những nỗi sợ kinh điển nhất trong đám tang của người Việt: hiện tượng Quỷ nhập tràng. Chuyện kể về một gia đình giàu có không may có người thân qua đời đúng vào đêm trăng máu. Một con mèo đen (Linh miêu) với đôi mắt rực lửa đã nhảy qua linh cữu, khiến cái xác bật dậy và bắt đầu những chuỗi ngày ám ảnh kinh hoàng cho cả vùng quê. Truyện lồng ghép khéo léo các phong tục kiêng kỵ trong tang lễ và những yếu tố tâm linh kỳ bí, mang lại cảm giác nghẹt thở và lạnh sống lưng cho người đọc qua từng trang giấy.', 
N'linhmieu.jpg', '2021-09-20', 0, N'Kinh dị, Tâm linh, Dân gian', 15, 1),

(52, N'Oán Hồn Ma Da', 4, 7, 38000.00, 
N'Ma Da luôn là nỗi ám ảnh đối với những đứa trẻ vùng sông nước miền Tây. Cuốn truyện kể về những linh hồn chết đuối không thể siêu thoát, luôn ẩn nấp dưới làn nước đục ngầu để chờ đợi cơ hội "thế chỗ" một ai đó. Bối cảnh diễn ra tại một vùng quê nghèo ven sông, nơi những bí mật về các vụ mất tích bí ẩn của dân làng dần được hé lộ qua những dấu chân bùn lạnh lẽo dẫn vào tận trong nhà. Truyện tập trung vào không khí u uất, lạnh lẽo và những hủ tục thờ cúng để xoa dịu các linh hồn oán than dưới đáy nước.', 
N'mada.jpg', '2021-09-20', 0, N'Kinh dị, Sông nước, Truyền thuyết', 12, 1),

(53, N'Truyền Thuyết Cây Đa Đầu Làng', 4, 5, 42000.00, 
N'"Thần cây đa, ma cây gạo" - câu nói dân gian này là nguồn cảm hứng cho những câu chuyện rùng rợn về thực thể trú ngụ trong những gốc đa cổ thụ trăm tuổi ở các làng quê Bắc Bộ. Chuyện kể về một ngôi làng bị ám bởi những linh hồn không nhà cửa, thường xuyên hiện hình trên cành đa vào những đêm sương mù dày đặc để trêu chọc người qua đường. Những người vô tình mạo phạm hoặc tiểu bậy vào gốc cây đều phải gánh chịu những lời nguyền thảm khốc. Một tác phẩm đậm chất liêu trai chí dị với những mô tả chi tiết về sự ma mị của thiên nhiên.', 
N'cayda.jpg', '2021-09-20', 0, N'Kinh dị, Tâm linh, Cây đa', 20, 1),

(54, N'Bí Mật Hầm Vàng Trấn Yểm', 4, 9, 65000.00, 
N'Khai thác chủ đề về các kho báu được trấn yểm bằng mạng người của các dòng họ quyền quý thời phong kiến. Cuốn sách dẫn dắt người đọc vào hành trình của một nhóm kẻ săn vàng vô tình đánh thức những "thần giữ của" đầy thù hận đã bị chôn sống hàng trăm năm trước. Những cái bẫy chết người, những lời nguyền bằng máu và sự truy đuổi của những thực thể không thuộc về cõi người sẽ khiến bạn không thể rời mắt. Đây là tư liệu tuyệt vời về các nghi lễ trấn yểm cổ xưa và lòng tham vô đáy của con người.', 
N'hamvang.jpg', '2021-09-20', 0, N'Kinh dị, Trấn yểm, Kho báu', 8, 1),

(55, N'Lời Nguyền Trong Ngôi Chùa Hoang', 4, 11, 48000.00, 
N'Một nhóm bạn trẻ đi phượt và vô tình trú chân tại một ngôi chùa hoang phế nằm sâu trong rừng thẳm vào một đêm mưa bão. Tại đây, họ bắt đầu nghe thấy những tiếng tụng kinh gõ mõ vang lên từ đại điện trống không và nhìn thấy những bóng người ẩn hiện sau những bức tượng Phật bong tróc rêu phong. Lời nguyền về một tội ác trong quá khứ dần lộ diện, buộc nhóm bạn phải tìm cách hóa giải nếu muốn thoát khỏi ngôi chùa trước khi trời sáng. Truyện kết hợp yếu tố tâm linh Phật giáo và những màn rượt đuổi nghẹt thở.', 
N'chuahoang.jpg', '2021-09-20', 0, N'Kinh dị, Tâm linh, Ngôi chùa', 15, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd9
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(56, N'Gintama (Linh Hồn Bạc)', 7, 3, 25000.00, 
N'Được mệnh danh là ông hoàng của dòng manga hài bựa, Gintama lấy bối cảnh thành phố Edo thời kỳ bị người ngoài hành tinh (Amanto) xâm lược. Câu chuyện xoay quanh tiệm làm thuê vạn năng Yorozuya của anh chàng samurai lười biếng Sakata Gintoki. Truyện nổi tiếng với những pha tấu hài cực mạnh, phá vỡ bức tường thứ tư, nhái lại các bộ manga khác một cách lầy lội nhưng vẫn cài cắm những thông điệp cảm động về lòng nhân đạo và tinh thần võ sĩ đạo. Một cuốn sách mà bạn sẽ không bao giờ biết được chương sau tác giả sẽ "vứt liêm sỉ" đi đâu.', 
N'gintama.jpg', '2021-09-20', 0, N'Manga, Hài bựa, Gintama', 50, 1),

(57, N'Grand Blue (Góc Nghỉ Ngơi)', 7, 1, 28000.00, 
N'Nếu bạn nghĩ đây là một bộ truyện về môn lặn biển thơ mộng thì bạn đã bị lừa! Grand Blue kể về Kitahara Iori khi bắt đầu cuộc đời sinh viên tại vùng biển Izu. Thay vì lặn dưới nước, cậu lại bị cuốn vào những trận "nhậu nhẹt" xuyên màn đêm của câu lạc bộ lặn Peek-a-Boo. Truyện gây ấn tượng mạnh bởi những biểu cảm khuôn mặt (face-palm) cực kỳ lầy lội, những tình huống dở khóc dở cười của đám sinh viên quậy phá. Đây là định nghĩa chuẩn mực cho việc "đi lặn là phụ, uống bia là chính".', 
N'grandblue.jpg', '2021-09-20', 0, N'Manga, Hài hước, Sinh viên', 40, 1),

(58, N'One-Punch Man (Thánh Phồng Tôm)', 7, 3, 30000.00, 
N'Saitama là một anh hùng "cho vui" với sức mạnh vô địch: đấm phát chết luôn bất cứ kẻ thù nào. Chính vì quá mạnh nên anh chàng luôn rơi vào trạng thái hụt hẫng vì không tìm được đối thủ xứng tầm. Sự tương phản giữa gương mặt "tỉnh bơ" như quả trứng luộc của Saitama với những trận chiến hoành tráng, cháy nổ xung quanh chính là điểm tạo nên tiếng cười đặc sắc. Một bộ manga hài hước, châm biếm sâu sắc về hình tượng siêu anh hùng truyền thống.', 
N'onepunchman.jpg', '2021-09-20', 0, N'Manga, Hành động, Hài hước', 60, 1),

(59, N'Sakamoto Desu ga? (Tôi là Sakamoto, có ý kiến gì không?)', 7, 5, 35000.00, 
N'Sakamoto không phải là một học sinh bình thường, cậu ta là người "cool" nhất, "ngầu" nhất và hoàn hảo nhất hành tinh. Bất kể kẻ xấu có bày mưu hãm hại thế nào, Sakamoto đều hóa giải một cách phong cách đến mức lố bịch. Từ việc ngồi trên không trung khi bị rút ghế đến việc dùng đũa gắp ong bắp cày, mọi hành động của Sakamoto đều khiến người xem phải thốt lên: "Thế mà cũng làm được sao?". Bộ truyện là đỉnh cao của sự hài hước dựa trên những tình huống hư cấu quá đà.', 
N'sakamoto.jpg', '2021-09-20', 0, N'Manga, Hài bựa, Cool ngầu', 30, 1),

(60, N'Great Teacher Onizuka (GTO)', 7, 9, 32000.00, 
N'Onizuka Eikichi - một cựu bang chủ băng đảng mô tô khét tiếng bỗng dưng muốn trở thành "thầy giáo vĩ đại nhất Nhật Bản". Với phương pháp giáo dục không giống ai, từ việc đập tường để nối lại tình cảm gia đình học sinh đến việc đua xe để dạy về lòng dũng cảm, Onizuka đã thay đổi hoàn toàn những lớp học cá biệt. Truyện chứa đựng những tình tiết hài hước đỏ mặt, những pha quậy phá "vô tiền khoáng hậu" nhưng lại mang đầy hơi thở cuộc sống và đạo đức nghề giáo.', 
N'gto.jpg', '2021-09-20', 0, N'Manga, Học đường, Onizuka', 45, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd8
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(61, N'Sherlock Holmes: Toàn Tập', 8, 1, 150000.00, 
N'Sherlock Holmes là nhân vật thám tử lừng danh nhất mọi thời đại dưới ngòi bút của Sir Arthur Conan Doyle. Bộ sách toàn tập này tập hợp đầy đủ các vụ án từ những vụ giết người bí ẩn trong phòng kín đến những âm mưu chính trị quốc tế. Với khả năng quan sát tinh tường và suy luận logic sắc bén, Holmes cùng cộng sự đắc lực là bác sĩ Watson đã giải mã những bí ẩn mà cảnh sát Scotland Yard phải bó tay. Cuốn sách không chỉ là những câu chuyện phá án mà còn là một bức tranh sống động về xã hội Luân Đôn thời hậu văn minh Victoria.', 
N'sherlock_holmes.jpg', '2021-09-20', 0, N'Trinh thám, Kinh điển, Sherlock', 30, 1),

(62, N'Án Mạng Trên Chuyến Tàu Tốc Hành Phương Đông', 8, 3, 85000.00, 
N'Tác phẩm đỉnh cao của "Nữ hoàng trinh thám" Agatha Christie. Câu chuyện diễn ra trên chuyến tàu tốc hành sang trọng đang bị kẹt giữa bão tuyết. Một hành khách bị sát hại với mười hai nhát dao đầy mâu thuẫn. Thám tử Hercule Poirot phải chạy đua với thời gian để tìm ra kẻ thủ ác trong số mười hai hành khách - những người tưởng chừng không liên quan nhưng đều che giấu những bí mật đen tối. Kết cục bất ngờ và chấn động của cuốn sách đã đưa nó trở thành một trong những tác phẩm trinh thám xuất sắc nhất mọi thời đại.', 
N'agatha_christie.jpg', '2021-09-20', 0, N'Trinh thám, Agatha Christie, Bí ẩn', 25, 1),

(63, N'Sự Im Lặng Của Bầy Cừu', 8, 7, 95000.00, 
N'Cuốn tiểu thuyết trinh thám tâm lý rùng rợn của Thomas Harris. Chuyện kể về Clarice Starling, một học viên FBI trẻ tuổi, được giao nhiệm vụ thẩm vấn bác sĩ tâm thần Hannibal Lecter - kẻ giết người hàng loạt có sở thích ăn thịt người. Mục tiêu là để tìm ra manh mối về một kẻ sát nhân khác đang lẩn trốn. Sự tương tác cân não giữa Starling và Lecter, cùng những diễn biến tâm lý phức tạp đã tạo nên một bầu không khí nghẹt thở. Cuốn sách là sự kết hợp hoàn hảo giữa điều tra tội phạm và phân tích tâm lý học tội phạm chuyên sâu.', 
N'silence_lambs.jpg', '2021-09-20', 0, N'Trinh thám, Tâm lý, Kinh dị', 15, 1),

(64, N'Phía Sau Nghi Can X', 8, 9, 11000.00, 
N'Một kiệt tác trinh thám hiện đại của Higashino Keigo. Câu chuyện bắt đầu bằng một vụ ngộ sát, nhưng điều làm nên sự khác biệt là cách thức che giấu tội lỗi của một thiên tài toán học nhằm bảo vệ người phụ nữ anh thầm yêu. Cuộc đối đầu giữa thám tử vật lý học Yukawa và thiên tài toán học Ishigami không chỉ là cuộc đấu trí về bằng chứng mà còn là cuộc đấu tranh về tình cảm và đức tin. Cuốn sách lôi cuốn độc giả bởi sự logic tuyệt đối và cái kết đầy cảm động, lay động lòng người về một tình yêu hy sinh đến mù quáng.', 
N'nghicanx.jpg', '2021-09-20', 0, N'Trinh thám, Nhật Bản, Higashino Keigo', 40, 1),

(65, N'Biểu Tượng Thất Truyền', 8, 4, 125000.00, 
N'Tiếp nối hành trình của giáo sư biểu tượng học Robert Langdon, Dan Brown đưa độc giả vào một cuộc phiêu lưu nghẹt thở ngay trong lòng thủ đô Washington D.C. Cuốn sách xoay quanh những bí mật của Hội Tam Điểm và những kiến trúc biểu tượng chứa đựng tri thức cổ xưa. Langdon chỉ có vài giờ để giải các mật mã cổ xưa nhằm cứu người thầy của mình và ngăn chặn một âm mưu đe dọa an ninh quốc gia. Với nhịp điệu dồn dập, kiến thức uyên bác về lịch sử và khoa học, cuốn tiểu thuyết là một hành trình giải mã đầy mê hoặc.', 
N'the_lost_symbol.jpg', '2021-09-20', 0, N'Trinh thám, Biểu tượng, Dan Brown', 20, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO

--cd9
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(71, N'Tiếu Ngạo Giang Hồ', 9, 1, 145000.00, 
N'Tiếu Ngạo Giang Hồ là một trong những tác phẩm đặc sắc nhất của tôn sư võ hiệp Kim Dung. Truyện xoay quanh cuộc đời của chàng lãng tử Lệnh Hồ Xung - một đệ tử phái Hoa Sơn có tính cách phóng khoáng, yêu tự do và thích uống rượu. Tác phẩm không chỉ mô tả những trận chiến kiếm thuật đỉnh cao như Độc Cô Cửu Kiếm mà còn là một bản nhạc châm biếm sâu sắc về sự giả tạo của những kẻ nhân danh "chính nghĩa" nhưng mang đầy dã tâm quyền lực. Giữa vòng xoáy ân oán giang hồ, tình bạn giữa Lệnh Hồ Xung và khúc nhạc "Tiếu Ngạo Giang Hồ" chính là biểu tượng cho khát vọng tự tại, vượt lên trên mọi định kiến đạo đức hẹp hòi.', 
N'tieungao.jpg', '2021-09-20', 0, N'Kiếm hiệp, Kim Dung, Lệnh Hồ Xung', 30, 1),

(72, N'Anh Hùng Xạ Điêu', 9, 3, 130000.00, 
N'Bộ tiểu thuyết mở đầu cho Xạ Điêu Tam Bộ Khúc lừng lẫy. Chuyện kể về hành trình trưởng thành của Quách Tĩnh - một chàng trai có phần khù khờ nhưng trung hậu, trượng nghĩa. Từ vùng thảo nguyên Mông Cổ đến Trung Nguyên đầy biến động, Quách Tĩnh đã gặp gỡ và yêu nàng Hoàng Dung thông minh tuyệt đỉnh. Truyện lồng ghép khéo léo giữa tình yêu đôi lứa với vận mệnh quốc gia dân tộc, giới thiệu những bộ võ công đã đi vào huyền thoại như Giáng Long Thập Bát Chưởng và Cửu Âm Chân Kinh. Đây là bài ca về lòng yêu nước và đạo nghĩa của người quân tử giữa thời loạn lạc.', 
N'anhhungxadieu.jpg', '2021-09-20', 0, N'Kiếm hiệp, Kim Dung, Quách Tĩnh', 40, 1),

(73, N'Thần Điêu Hiệp Lữ', 9, 7, 155000.00, 
N'Tiếp nối Anh Hùng Xạ Điêu, đây là bản tình ca bi tráng và cảm động nhất của Kim Dung. Câu chuyện xoay quanh mối tình đầy trắc trở, vượt qua mọi rào cản lễ giáo phong kiến giữa Dương Quá và sư phụ mình là Tiểu Long Nữ. Với bối cảnh cuộc chiến chống quân Mông Cổ, truyện khắc họa sâu sắc tâm lý của một "Tây Độc" trẻ tuổi đầy nổi loạn và một cô gái thanh khiết như sương mai. Hình ảnh con Thần Điêu khổng lồ và thanh Huyền Thiết Trọng Kiếm đã tạo nên một dấu ấn khó phai, khẳng định triết lý "Hỏi thế gian tình là gì mà khiến người ta thề nguyền sống chết".', 
N'thandieu.jpg', '2021-09-20', 0, N'Kiếm hiệp, Tình yêu, Dương Quá', 25, 1),

(74, N'Thiên Long Bát Bộ', 9, 9, 180000.00, 
N'Được coi là tác phẩm đồ sộ và xuất sắc nhất về mặt triết lý của Kim Dung. Thiên Long Bát Bộ dẫn dắt độc giả theo chân ba anh em kết nghĩa: Tiêu Phong - bang chủ cái bang hào hiệp nhưng mang thân thế bi kịch; Đoàn Dự - hoàng tử nước Đại Lý si tình và may mắn; Hư Trúc - chú tiểu hiền lành vô tình nhận được nội công thâm hậu. Truyện khai thác sâu sắc về nghiệp báo, số phận con người giữa những cuộc tranh đoạt quyền lực của các quốc gia Tống, Liêu, Đại Lý, Thổ Phồn. Những tuyệt học như Lục Mạch Thần Kiếm hay Bắc Minh Thần Công càng làm tăng thêm vẻ kỳ ảo cho một thiên sử thi võ hiệp đầy bi kịch và nhân văn.', 
N'thienlongbatbo.jpg', '2021-09-20', 0, N'Kiếm hiệp, Kim Dung, Tiêu Phong', 20, 1),

(75, N'Ỷ Thiên Đồ Long Ký', 9, 5, 150000.00, 
N'Hồi kết của Xạ Điêu Tam Bộ Khúc, xoay quanh lời đồn về hai báu vật: "Võ lâm chí tôn, Bảo đao Đồ Long, Hiệu lệnh thiên hạ, Mạc cảm bất tòng. Ỷ Thiên bất xuất, thùy dữ tranh phong?". Nhân vật chính Trương Vô Kỵ vô tình học được Cửu Dương Thần Công và Càn Khôn Đại Na Di, trở thành giáo chủ Minh Giáo đứng ra hòa giải ân oán giữa các môn phái và chống lại quân Nguyên. Tác phẩm gây ấn tượng bởi những tình tiết lắt léo về tình cảm giữa Trương Vô Kỵ và các cô gái, đặc biệt là quận chúa Triệu Mẫn, cùng những âm mưu thâm độc ẩn sau những danh môn chính phái.', 
N'ythien.jpg', '2021-09-20', 0, N'Kiếm hiệp, Đồ Long Đao, Trương Vô Kỵ', 35, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd10
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(86, N'Harry Potter Và Hòn Đá Phù Thủy', 9, 1, 125000.00, 
N'Harry Potter và Hòn đá Phù thủy là tập đầu tiên trong bộ truyện lừng lẫy của văn sĩ J.K. Rowling. Câu chuyện bắt đầu khi Harry, một cậu bé mồ côi 11 tuổi, phát hiện ra mình là một phù thủy và được mời vào học tại Trường Pháp thuật và Ma thuật Hogwarts. Tại đây, Harry bắt đầu khám phá thế giới phép thuật kỳ ảo, kết bạn với Ron và Hermione, đồng thời đối mặt với những bí ẩn xung quanh cái chết của cha mẹ mình và sự trở lại của chúa tể hắc ám Voldemort. Cuốn sách đã tạo nên một cuộc cách mạng văn hóa đọc trên toàn cầu những năm 2000, mở ra một thế giới phù thủy đầy mê hoặc với những chiếc đũa phép, chổi bay và những trận đấu Quidditch nghẹt thở.', 
N'harry_potter_1.jpg', '2021-09-20', 0, N'Fantasy, Phù thủy, Harry Potter', 100, 1),

(87, N'Eragon - Cậu Bé Cưỡi Rồng (Di Sản Thừa Kế)', 9, 3, 98000.00, 
N'Tác phẩm của Christopher Paolini kể về Eragon, một cậu bé nông dân nghèo khổ tình cờ tìm thấy một viên đá xanh biếc trên núi. Viên đá thực chất là một quả trứng rồng, và từ đó nở ra cô rồng Saphira xinh đẹp. Với tư cách là một Kỵ sĩ Rồng cuối cùng, Eragon bị cuốn vào một cuộc hành trình đầy nguy hiểm qua lục địa Alagaësia để chống lại vị vua tàn bạo Galbatorix. Cuốn sách thu hút độc giả những năm 2005-2010 bởi sự kết hợp giữa ngôn ngữ cổ xưa, phép thuật và những cuộc chiến rồng hoành tráng, đại diện cho dòng Fantasy cổ điển phương Tây vô cùng ăn khách thời bấy giờ.', 
N'eragon.jpg', '2021-09-20', 0, N'Fantasy, Rồng, Kỵ sĩ', 45, 1),

(88, N'Percy Jackson: Kẻ Cắp Tia Chớp', 9, 2, 85000.00, 
N'Rick Riordan đã mang các vị thần Hy Lạp cổ đại vào thế giới hiện đại thông qua nhân vật Percy Jackson - một cậu bé bị chứng khó đọc và tăng động, người bỗng chốc phát hiện ra mình là con trai của thần biển Poseidon. Percy bị cáo buộc ăn cắp tia chớp của thần Zeus và phải cùng những người bạn á thần khác lên đường giải oan. Bộ truyện rất được ưa chuộng giai đoạn cuối những năm 2000 nhờ cách lồng ghép khéo léo giữa thần thoại Hy Lạp và nhịp sống hiện đại của New York, tạo nên một cuộc phiêu lưu vừa kỳ ảo vừa gần gũi với giới trẻ.', 
N'percy_jackson.jpg', '2021-09-20', 0, N'Fantasy, Thần thoại, Percy Jackson', 60, 1),

(89, N'Tây Du Ký (Trọn Bộ 2 Tập)', 9, 2, 165000.00, 
N'Tây Du Ký của Ngô Thừa Ân là một trong "Tứ đại danh tác" của văn học Trung Hoa và là tượng đài bất hủ của dòng văn học kỳ ảo phương Đông. Câu chuyện kể về hành trình đi sang Tây Trúc thỉnh kinh đầy gian nan của bốn thầy trò Đường Tam Tạng. Tâm điểm của tác phẩm là Tôn Ngộ Không - một Thạch Hầu thông minh, bản lĩnh, sở hữu 72 phép biến hóa và gậy Như Ý, người đã từng đại náo Thiên cung trước khi bị khuất phục dưới chân núi Ngũ Hành. Trên đường đi, thầy trò họ đã phải vượt qua 81 kiếp nạn, đối đầu với vô số yêu ma quỷ quái đại diện cho những thói hư tật xấu của con người. Tác phẩm không chỉ là một cuộc phiêu lưu giả tưởng đầy lôi cuốn mà còn chứa đựng những triết lý sâu sắc của Phật giáo, Đạo giáo và Nho giáo, phản ánh khát vọng tự do và công lý của nhân dân.', 
N'tayduky.jpg', '2021-09-20', 0, N'Huyền huyễn, Thần thoại, Tôn Ngộ Không', 55, 1),

(90, N'Chúa Tể Những Chiếc Nhẫn: Đoàn Hộ Nhẫn', 9, 1, 185000.00, 
N'Chúa tể những chiếc nhẫn (The Lord of the Rings) của J.R.R. Tolkien được coi là "cha đẻ" của mọi tác phẩm Fantasy hiện đại. "Đoàn Hộ Nhẫn" là phần mở đầu cho hành trình vĩ đại của anh chàng Hobbit Frodo Baggins, người mang trọng trách tiêu hủy Chiếc Nhẫn Chủ để ngăn chặn sự trỗi dậy của bạo chúa Sauron. Thế giới Trung Địa (Middle-earth) được xây dựng đồ sộ với ngôn ngữ riêng, lịch sử riêng và các chủng tộc đa dạng. Bản dịch tiếng Việt trong những năm 2000 đã thực sự làm bùng nổ trí tưởng tượng của độc giả Việt Nam về một sử thi kỳ ảo hoành tráng nhất mọi thời đại.', 
N'lotr_doan_ho_nhan.jpg', '2021-09-20', 0, N'Fantasy, Trung Địa, Hobbit', 30, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd11
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(91, N'Tạp Chí Xưa & Nay: Sài Gòn - 300 Năm Hình Thành Và Phát Triển', 11, 9, 35000.00, 
N'Tạp chí Xưa & Nay số đặc biệt này là một tư liệu quý giá dành cho những ai muốn tìm hiểu về lịch sử hình thành và phát triển của vùng đất Gia Định - Sài Gòn từ những ngày đầu khai phá cho đến nay. Ấn phẩm tập hợp nhiều bài viết của các sử gia hàng đầu, phân tích về sự chuyển biến địa lý, văn hóa và xã hội của hòn ngọc Viễn Đông qua các thời kỳ. Với những bức ảnh tư liệu quý hiếm về cảnh quan và con người Sài Gòn xưa, tạp chí mang đến một cái nhìn sống động và hoài niệm về một thành phố năng động nhưng vẫn giữ được những nét di sản đặc trưng.', 
N'xuanay_saigon.jpg', '2021-09-20', 0, N'Tạp chí, Lịch sử, Sài Gòn', 50, 1),

(92, N'Tạp Chí Nghiên Cứu Lịch Sử: Giai Đoạn 1954 - 1975', 11, 11, 45000.00, 
N'Số chuyên đề đặc biệt tập trung vào giai đoạn 21 năm kháng chiến chống Mỹ cứu nước, từ sau Hiệp định Giơ-ne-vơ 1954 đến đại thắng mùa Xuân 1975. Tạp chí đi sâu vào phân tích các chính sách chiến lược, bối cảnh chính trị quốc tế và các phong trào đấu tranh của nhân dân hai miền Nam - Bắc. Các bài nghiên cứu dựa trên các nguồn sử liệu chính thống, các cuộc phỏng vấn nhân chứng lịch sử và tài liệu giải mật từ các bên liên quan. Đây là nguồn tài liệu không thể thiếu cho các nhà nghiên cứu, sinh viên và những người yêu thích tìm hiểu về một thời kỳ hào hùng nhưng cũng đầy gian khổ của dân tộc.', 
N'nghiencuu_lichsu.jpg', '2021-09-20', 0, N'Tạp chí, Lịch sử, 1954-1975', 40, 1),

(93, N'Tạp Chí Di Sản Văn Hóa: Phố Cổ Hội An - Nơi Giao Thoa Văn Hóa', 11, 5, 32000.00, 
N'Ấn phẩm đặc biệt về di sản văn hóa thế giới Phố cổ Hội An. Tạp chí giới thiệu chi tiết về lịch sử của thương cảng sầm uất nhất khu vực Đông Nam Á từ thế kỷ 16, nơi chứng kiến sự giao thoa văn hóa giữa Việt Nam, Nhật Bản và Trung Hoa. Độc giả sẽ được tìm hiểu về các kiến trúc cổ đặc trưng như Chùa Cầu, các hội quán và nhà cổ trăm tuổi còn được bảo tồn nguyên vẹn. Bên cạnh đó, tạp chí còn khai thác các giá trị văn hóa phi vật thể như ẩm thực, lễ hội và lối sống của người dân địa phương, góp phần tôn vinh giá trị của một di sản trường tồn với thời gian.', 
N'disan_hoian.jpg', '2021-09-20', 0, N'Tạp chí, Di sản, Hội An', 35, 1),

(94, N'Tạp Chí Lịch Sử Quân Sự: Những Chiến Dịch Lừng Lẫy Của Quân Đội Nhân Dân', 11, 6, 40000.00, 
N'Tạp chí Lịch sử Quân sự số này tái hiện lại những trang sử vẻ vang nhất của Quân đội Nhân dân Việt Nam qua các chiến dịch quân sự trọng yếu. Từ chiến thắng Điện Biên Phủ "lừng lẫy năm châu, chấn động địa cầu" đến chiến dịch Hồ Chí Minh lịch sử, ấn phẩm cung cấp những phân tích sâu sắc về nghệ thuật quân sự, cách bày binh bố trận và tinh thần dũng cảm của các chiến sĩ. Ngoài ra, tạp chí còn giới thiệu chân dung các vị tướng lĩnh tài ba và những vũ khí thô sơ nhưng đầy uy lực đã góp phần làm nên những kỳ tích trong lịch sử giữ nước.', 
N'lichsu_quansu.jpg', '2021-09-20', 0, N'Tạp chí, Quân sự, Lịch sử', 30, 1),

(95, N'Tạp Chí Khảo Cổ Học: Phát Hiện Mới Về Văn Hóa Đông Sơn', 11, 4, 55000.00, 
N'Ấn phẩm cập nhật những kết quả khảo cổ học mới nhất về nền văn hóa Đông Sơn rực rỡ. Tạp chí đưa độc giả đến với những di chỉ mới được khai quật, giải mã ý nghĩa của các hoa văn tinh xảo trên trống đồng và các công cụ bằng đồng của người Việt cổ. Các nhà khoa học phân tích về trình độ kỹ thuật đúc đồng đỉnh cao và đời sống sinh hoạt của cư dân thời kỳ đầu dựng nước. Đây là cầu nối giúp độc giả tiếp cận với những bằng chứng vật chất cụ thể về một nền văn minh lúa nước lâu đời và rực rỡ của dân tộc Việt Nam.', 
N'khaoco_dongson.jpg', '2021-09-20', 0, N'Tạp chí, Khảo cổ, Đông Sơn', 20, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd13
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(96, N'Tạp Chí Du Lịch Việt Nam: Hành Trình Di Sản Miền Trung', 13, 1, 35000.00, 
N'Số đặc biệt này dẫn dắt độc giả đi qua "Con đường Di sản miền Trung" đầy mê hoặc. Từ vẻ đẹp trầm mặc, cổ kính của Cố đô Huế với những lăng tẩm uy nghi, đến sự năng động của thành phố đáng sống Đà Nẵng và nét lung linh, huyền ảo của Phố cổ Hội An khi lên đèn. Tạp chí cung cấp những gợi ý chi tiết về lịch trình tham quan, các địa điểm check-in không thể bỏ qua và đặc biệt là chuyên mục ẩm thực miền Trung với những món ăn gây thương nhớ như bún bò Huế, mì Quảng hay cơm gà Hội An. Đây là cẩm nang hoàn hảo cho những ai đang lên kế hoạch khám phá dải đất miền Trung đầy nắng và gió.', 
N'dulich_mientrung.jpg', '2021-09-20', 0, N'Tạp chí, Du lịch, Miền Trung', 45, 1),

(97, N'Tạp Chí Wanderlust: Khám Phá Những Kỳ Quan Thiên Nhiên Thế Giới', 13, 3, 55000.00, 
N'Ấn phẩm quốc tế dành cho những tâm hồn đam mê xê dịch và khát khao chinh phục thiên nhiên. Tạp chí giới thiệu những kỳ quan thiên nhiên vĩ đại nhất thế giới từ hẻm núi Grand Canyon kỳ vĩ, thác nước Iguazu hùng vỹ đến vẻ đẹp huyền ảo của cực quang tại Bắc Âu. Mỗi trang báo là một tác phẩm nghệ thuật với hình ảnh chất lượng cao, đi kèm là những câu chuyện kể về hành trình khám phá đầy thử thách của các nhiếp ảnh gia và phóng viên du lịch chuyên nghiệp. Tạp chí cũng đề cao tinh thần du lịch bền vững, bảo vệ môi trường và tôn trọng văn hóa bản địa tại mỗi nơi đặt chân đến.', 
N'wanderlust_world.jpg', '2021-09-20', 0, N'Tạp chí, Thiên nhiên, Thế giới', 30, 1),

(98, N'Tạp Chí Travel+Leisure: Nghỉ Dưỡng Sang Trọng Tại Các Đảo Thiên Đường', 13, 5, 48000.00, 
N'Travel+Leisure số này tập trung vào phân khúc nghỉ dưỡng cao cấp tại những hòn đảo đẹp nhất hành tinh như Maldives, Bali, Santorini hay Phú Quốc. Tạp chí đánh giá chi tiết về các resort 5 sao, các dịch vụ spa thư giãn và trải nghiệm ẩm thực tinh tế bên bờ biển. Độc giả sẽ được chiêm ngưỡng những thiết kế kiến trúc độc đáo hòa quyện với thiên nhiên và tìm hiểu về những dịch vụ cá nhân hóa đỉnh cao. Đây là nguồn cảm hứng cho những chuyến đi nghỉ dưỡng xa hoa, giúp bạn tận hưởng những giây phút thư thái tuyệt đối sau những ngày làm việc căng thẳng.', 
N'travel_leisure_island.jpg', '2021-09-20', 0, N'Tạp chí, Nghỉ dưỡng, Resort', 25, 1),

(99, N'Tạp Chí National Geographic Traveler: Những Vùng Đất Hoang Sơ', 13, 11, 52000.00, 
N'Dành cho những người yêu thích phiêu lưu mạo hiểm và muốn tìm về với vẻ đẹp nguyên thủy của Trái Đất. Tạp chí đưa bạn đến với những vùng đất xa xôi, hẻo lánh chưa có nhiều dấu chân du khách như vùng thảo nguyên Mông Cổ bao la, những bộ lạc bí ẩn tại Amazon hay vẻ đẹp lạnh giá của vùng Nam Cực. Ấn phẩm không chỉ mô tả cảnh quan mà còn đi sâu vào tìm hiểu đời sống, phong tục tập quán độc đáo của cư dân địa phương. Với góc nhìn nhân văn và sự tôn trọng tuyệt đối với thiên nhiên, National Geographic Traveler mang đến những bài viết có giá trị giáo dục và truyền cảm hứng mạnh mẽ.', 
N'natgeo_traveler.jpg', '2021-09-20', 0, N'Tạp chí, Phiêu lưu, Hoang sơ', 20, 1),

(100, N'Tạp Chí Heritage: Nét Đẹp Văn Hóa Phố Phường Hà Nội', 13, 9, 38000.00, 
N'Số chuyên đề đặc biệt về Hà Nội - thành phố vì hòa bình với nét đẹp hòa quyện giữa truyền thống và hiện đại. Tạp chí khai thác những góc khuất bình dị nhưng đầy quyến rũ của 36 phố phường, từ những quán cà phê đường tàu, những gánh hàng rong buổi sớm đến tiếng chuông chùa Trấn Quốc vang vọng bên Hồ Tây. Độc giả sẽ được tìm hiểu về các làng nghề thủ công truyền thống quanh Hà Nội và nghệ thuật thưởng thức ẩm thực tinh tế của người Tràng An. Hình ảnh trong tạp chí mang màu sắc hoài niệm, lãng mạn, tái hiện một Hà Nội dịu dàng nhưng cũng rất đỗi sống động trong mắt du khách thập phương.', 
N'heritage_hanoi.jpg', '2021-09-20', 0, N'Tạp chí, Hà Nội, Văn hóa', 60, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd14
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(101, N'Phóng Sự Điều Tra: Những Góc Khuất Của Thế Giới Ngầm', 14, 11, 42000.00, 
N'Ấn phẩm phóng sự điều tra đặc biệt đi sâu vào những mảng tối của xã hội hiện đại. Tập hợp các bài viết của những phóng viên dũng cảm, cuốn sách phanh phui các đường dây tội phạm xuyên quốc gia, những mánh khóe lừa đảo tinh vi và các tổ chức hoạt động bí mật trong thế giới ngầm. Với tư liệu thực tế và những hình ảnh thâm nhập hiện trường đầy kịch tính, ấn phẩm mang đến cái nhìn trực diện về cuộc đấu tranh gian khổ của lực lượng chức năng nhằm giữ gìn trật tự an ninh xã hội. Đây là tư liệu tham khảo quý giá cho những ai quan tâm đến tội phạm học và an ninh đời sống.', 
N'phongsu_thegioingam.jpg', '2021-09-20', 0, N'Phóng sự, Điều tra, Tội phạm', 30, 1),

(102, N'Ký Sự Ven Đường: Những Mảnh Đời Mưu Sinh Nơi Đô Thị', 14, 9, 35000.00, 
N'Cuốn ký sự đầy tính nhân văn về những kiếp người nhỏ bé giữa lòng thành phố náo nhiệt. Tác giả đã dành nhiều năm lang thang qua từng con hẻm, góc phố để ghi lại câu chuyện của những người bán hàng rong, những đứa trẻ đánh giày, và những cụ già không nơi nương tựa. Mỗi bài viết là một lát cắt cuộc đời, chứa đựng những nỗi niềm, ước mơ và nghị lực phi thường của con người trước nghịch cảnh. Ấn phẩm giúp độc giả sống chậm lại, biết lắng nghe và chia sẻ nhiều hơn với những mảnh đời bất hạnh xung quanh mình, khẳng định tình người vẫn luôn tỏa sáng trong sự xô bồ của đô thị.', 
N'kysu_muusinh.jpg', '2021-09-20', 0, N'Ký sự, Đô thị, Nhân văn', 45, 1),

(103, N'Báo Phóng Sự Xã Hội: Mặt Trái Của Công Nghệ Số', 14, 4, 38000.00, 
N'Trong thời đại bùng nổ của Internet và mạng xã hội, ấn phẩm này đặt ra những câu hỏi nhức nhối về tác động tiêu cực của công nghệ đối với tâm lý và hành vi con người. Các phóng viên đã thực hiện nhiều cuộc khảo sát về nạn bắt nạt qua mạng, sự lệch lạc trong nhận thức của giới trẻ do ảnh hưởng từ các "idol" ảo, và vấn đề quyền riêng tư bị xâm phạm. Cuốn sách là lời cảnh tỉnh về sự lệ thuộc quá mức vào thế giới ảo, giúp người đọc có cái nhìn tỉnh táo hơn để bảo vệ bản thân và gia đình trước những cạm bẫy trực tuyến đầy rẫy rủi ro.', 
N'phongsu_congnghe.jpg', '2021-09-20', 0, N'Phóng sự, Công nghệ, Xã hội', 50, 1),

(104, N'Hành Trình Công Lý: Giải Mã Những Vụ Án Chấn Động', 14, 6, 48000.00, 
N'Tập hợp những bài phóng sự điều tra về các vụ đại án kinh tế và hình sự từng gây xôn xao dư luận. Ấn phẩm dẫn dắt người đọc đi sâu vào quá trình phá án lắt léo, những cuộc đấu trí cân não giữa điều tra viên và những kẻ phạm tội sừng sỏ. Qua đó, cuốn sách không chỉ tôn vinh sự nghiêm minh của pháp luật mà còn phân tích những lỗ hổng trong quản lý và kẽ hở pháp lý mà bọn tội phạm thường lợi dụng. Đây là nguồn tài liệu hữu ích giúp nâng cao nhận thức pháp luật và tinh thần cảnh giác cho cộng đồng.', 
N'hanhtrinh_congly.jpg', '2021-09-20', 0, N'Điều tra, Pháp luật, Vụ án', 25, 1),

(105, N'Đời Thợ: Những Câu Chuyện Chưa Kể Phía Sau Ánh Đèn Công Xưởng', 14, 1, 32000.00, 
N'Một bản báo cáo thực tế đầy xúc động về đời sống của công nhân tại các khu công nghiệp lớn. Ấn phẩm khai thác những góc khuất về điều kiện làm việc, những giờ tăng ca mệt mỏi và nỗi lo cơm áo gạo tiền đè nặng lên vai người lao động. Bên cạnh những khó khăn, cuốn sách cũng ghi lại những khoảnh khắc ấm áp của tình đồng nghiệp, sự tương thân tương ái trong các xóm trọ nghèo. Đây là cái nhìn chân thực và đa chiều về giai cấp công nhân - những người đang âm thầm đóng góp vào sự phát triển kinh tế nhưng thường bị lãng quên trong những bản báo cáo hào nhoáng.', 
N'doitho_phongsu.jpg', '2021-09-20', 0, N'Phóng sự, Công nhân, Lao động', 40, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd15
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(106, N'Tạp Chí Thế Giới Vi Tính (PC World VN) - Số Đặc Biệt: Kỷ Nguyên AI', 15, 3, 45000.00, 
N'Số đặc biệt của PC World Việt Nam tập trung vào sự bùng nổ của trí tuệ nhân tạo (AI) trong năm 2024-2025. Tạp chí phân tích sâu về các mô hình ngôn ngữ lớn (LLM), ứng dụng của Generative AI trong thiết kế và lập trình, cũng như tác động của AI đến thị trường lao động toàn cầu. Chuyên mục "Trải nghiệm" mang đến những đánh giá chi tiết về các công cụ AI hỗ trợ code như GitHub Copilot và các giải pháp chatbot thông minh cho doanh nghiệp. Đây là ấn phẩm không thể thiếu cho những ai muốn nắm bắt xu hướng công nghệ đang thay đổi thế giới từng ngày.', 
N'pcworld_ai.jpg', GETDATE(), 0, N'Công nghệ, AI, Trí tuệ nhân tạo', 50, 1),

(107, N'Tạp Chí Lập Trình: Làm Chủ Full-stack Với Next.js & React', 15, 4, 55000.00, 
N'Ấn phẩm chuyên sâu dành cho cộng đồng developer, tập trung vào hệ sinh thái JavaScript hiện đại. Tạp chí hướng dẫn xây dựng các ứng dụng web hiệu năng cao bằng Next.js 14, quản lý state với Redux Toolkit và tối ưu hóa SEO cho các ứng dụng Single Page Application. Bên cạnh đó, chuyên mục "Back-end Corner" cũng chia sẻ các kiến thức về Node.js, thiết kế RESTful API chuẩn mực và cách triển khai hệ thống lên các nền tảng Cloud như AWS hay Vercel. Các bài viết được trình bày dưới dạng tutorial thực tế, kèm theo mã nguồn mẫu giúp lập trình viên dễ dàng áp dụng vào dự án thực tế.', 
N'tapchi_laptrinh.jpg', GETDATE(), 0, N'Lập trình, React, Next.js, Full-stack', 40, 1),

(108, N'Tạp Chí Chip: Phần Cứng Và Hiệu Năng Gaming Tối Thượng', 15, 11, 60000.00, 
N'Dành riêng cho những tín đồ đam mê phần cứng (Hardware) và giới game thủ. Tạp chí Chip số này thực hiện các bài benchmark khốc liệt để so sánh hiệu năng giữa các dòng CPU và GPU mới nhất từ Intel, AMD và NVIDIA. Chuyên mục "Build PC" gợi ý các cấu hình tối ưu cho từng phân khúc từ làm việc chuyên nghiệp đến chơi game 4K. Ngoài ra, tạp chí cũng cập nhật những xu hướng mới nhất về tản nhiệt nước, thiết bị ngoại vi gaming và công nghệ màn hình OLED tần số quét cao, mang đến cái nhìn toàn cảnh về thế giới phần cứng máy tính hiện đại.', 
N'chip_hardware.jpg', GETDATE(), 0, N'Công nghệ, Phần cứng, Gaming', 35, 1),

(109, N'Tạp Chí An Toàn Thông Tin: Phòng Chống Tấn Công Mạng 4.0', 15, 6, 52000.00, 
N'Trong bối cảnh các mối đe dọa an ninh mạng ngày càng tinh vi, tạp chí An Toàn Thông Tin cung cấp những phân tích chuyên sâu về các lỗ hổng bảo mật zero-day, phương thức tấn công Ransomware và các biện pháp phòng thủ chủ động. Ấn phẩm giới thiệu các tiêu chuẩn bảo mật quốc tế, kỹ thuật kiểm thử xâm nhập (Penetration Testing) và cách xây dựng hệ thống giám sát an ninh mạng (SOC) cho doanh nghiệp. Đây là nguồn tài liệu hữu ích cho các chuyên gia bảo mật, quản trị hệ thống và những ai quan tâm đến việc bảo vệ dữ liệu cá nhân trên không gian mạng.', 
N'security_tech.jpg', GETDATE(), 0, N'Công nghệ, Bảo mật, An ninh mạng', 30, 1),

(110, N'Tạp Chí Khoa Học & Công Nghệ: Tương Lai Của Xe Điện Và Năng Lượng Sạch', 15, 5, 48000.00, 
N'Số chuyên đề về chuyển đổi xanh và những đột phá trong công nghệ năng lượng. Tạp chí giới thiệu các thế hệ pin xe điện mới với mật độ năng lượng cao, hệ thống tự lái cấp độ 5 và mạng lưới trạm sạc thông minh. Các bài viết cũng phân tích về vai trò của năng lượng hydro, điện gió và điện mặt trời trong việc hình thành các thành phố thông minh bền vững. Ấn phẩm mang đến cái nhìn lạc quan về việc ứng dụng công nghệ để giải quyết các thách thức về biến đổi khí hậu, hướng tới một tương lai xanh và sạch hơn cho nhân loại.', 
N'science_tech_future.jpg', GETDATE(), 0, N'Khoa học, Xe điện, Năng lượng xanh', 45, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
--cd16
USE [BookStoreDB];
GO

SET IDENTITY_INSERT [dbo].[Sach] ON;

INSERT INTO [dbo].[Sach] ([MaSach], [TenSach], [MaCD], [MaNXB], [Dongia], [Mota], [AnhBia], [Ngaycapnhat], [Soluotxem], [Tags], [Soluongton], [TrangThai]) VALUES 
(111, N'National Geographic - Bản tiếng Việt: Kỳ Quan Thiên Nhiên Và Động Vật Hoang Dã', 16, 1, 65000.00, 
N'National Geographic là tạp chí địa lý danh tiếng nhất thế giới, nay đã có phiên bản tiếng Việt với chất lượng hình ảnh và nội dung đạt chuẩn quốc tế. Số này đưa độc giả vào hành trình khám phá những vùng đất xa xôi nhất, từ những rặng san hô rực rỡ dưới đáy đại dương đến những đỉnh núi cao phủ tuyết trắng xóa. Tạp chí không chỉ mô tả vẻ đẹp thiên nhiên mà còn cung cấp những kiến thức khoa học sâu sắc về tập tính của các loài động vật hoang dã quý hiếm đang đứng trước nguy cơ tuyệt chủng. Mỗi trang báo là một cửa sổ mở ra thế giới hoang dã đầy sống động và đầy mê hoặc.', 
N'natgeo_vn.jpg', GETDATE(), 0, N'Địa lý, Thiên nhiên, Động vật', 50, 1),

(112, N'Tạp Chí Địa Lý Nhân Văn: Sự Dịch Chuyển Dân Cư Và Đô Thị Hóa Toàn Cầu', 16, 9, 42000.00, 
N'Ấn phẩm tập trung khai thác mối quan hệ giữa con người và không gian sống trong thế kỷ 21. Tạp chí phân tích các làn sóng di cư lớn, sự hình thành của các siêu đô thị và những thách thức về hạ tầng, môi trường mà nhân loại phải đối mặt. Qua các biểu đồ dữ liệu chi tiết và các bài viết phân tích từ chuyên gia địa lý nhân văn, độc giả sẽ hiểu rõ hơn về cách thức xã hội vận hành, sự giao thoa văn hóa giữa các cộng đồng và xu hướng phát triển của các đô thị thông minh trong tương lai. Đây là tài liệu tham khảo quý giá cho những nhà hoạch định chính sách và sinh viên ngành địa lý.', 
N'dialy_nhanvan.jpg', GETDATE(), 0, N'Địa lý, Xã hội, Đô thị', 35, 1),

(113, N'Geographic Discovery: Giải Mã Những Vùng Đất Bí Ẩn Trên Trái Đất', 16, 4, 48000.00, 
N'Geographic Discovery số này dẫn dắt những tâm hồn ưa mạo hiểm đến với các địa điểm kỳ bí vẫn còn là dấu hỏi lớn với giới khoa học. Từ bí mật của "Tam giác quỷ" Bermuda, những rãnh vực sâu thẳm dưới lòng biển Thái Bình Dương đến những vùng đất có địa hình kỳ lạ như hành tinh khác trên sa mạc Sahara. Tạp chí sử dụng các hình ảnh vệ tinh độ phân giải cao và các bản đồ địa hình 3D để giải thích các hiện tượng địa chất đặc biệt, mang đến cái nhìn khoa học nhưng không kém phần lôi cuốn về những điều chưa thể giải đáp trên hành tinh xanh.', 
N'geo_discovery.jpg', GETDATE(), 0, N'Địa lý, Khám phá, Bí ẩn', 30, 1),

(114, N'Tạp Chí Tài Nguyên Và Môi Trường: Biến Đổi Khí Hậu Và Tương Lai Xanh', 16, 11, 38000.00, 
N'Số chuyên đề đặc biệt về vấn đề cấp bách nhất hiện nay: Biến đổi khí hậu toàn cầu. Tạp chí cung cấp các dữ liệu mới nhất về sự nóng lên của Trái Đất, hiện trạng băng tan tại hai cực và những tác động trực tiếp của thiên tai đến đời sống kinh tế - xã hội. Bên cạnh đó, ấn phẩm cũng giới thiệu các giải pháp công nghệ xanh, các mô hình bảo tồn tài nguyên nước và nỗ lực của các quốc gia trong việc thực hiện cam kết giảm phát thải. Đây là tiếng chuông cảnh tỉnh và cũng là nguồn cảm hứng cho những hành động bảo vệ môi trường bền vững.', 
N'moitruong_xanh.jpg', GETDATE(), 0, N'Địa lý, Môi trường, Khí hậu', 45, 1),

(115, N'Khám Phá Thế Giới: Những Nền Văn Minh Bị Lãng Quên Dưới Lòng Đất', 16, 2, 55000.00, 
N'Tạp chí Khám Phá Thế Giới đưa độc giả vào một cuộc khảo sát địa lý và khảo cổ học đầy thú vị về những thành phố và nền văn minh cổ xưa đã bị vùi lấp dưới lòng đất hoặc sâu trong rừng thẳm qua hàng nghìn năm. Từ hệ thống hang động nhân tạo vĩ đại tại Thổ Nhĩ Kỳ đến những dấu tích còn sót lại của các thành phố Maya bị rừng già che phủ. Sự kết hợp giữa kiến thức địa chất và lịch sử giúp chúng ta hình dung lại cách thức con người thời xưa đã thích nghi và chế ngự thiên nhiên khắc nghiệt để xây dựng nên những kỳ quan trường tồn với thời gian.', 
N'khampha_thegioi.jpg', GETDATE(), 0, N'Địa lý, Lịch sử, Khám phá', 25, 1);

SET IDENTITY_INSERT [dbo].[Sach] OFF;
GO
UPDATE [dbo].[Sach] SET [Soluongton] = 10, [TrangThai] = 1;
GO

-- 3. THIẾT LẬP KHÓA NGOẠI (FOREIGN KEYS)
ALTER TABLE [dbo].[ChuDe] ADD CONSTRAINT [FK_ChuDe_PhanLoai] FOREIGN KEY([MaLoai]) REFERENCES [dbo].[PhanLoai] ([MaLoai]);
ALTER TABLE [dbo].[KhachHang] ADD CONSTRAINT [FK_KhachHang_Role] FOREIGN KEY([MaRole]) REFERENCES [dbo].[Role] ([MaRole]);
ALTER TABLE [dbo].[Comment] ADD CONSTRAINT [FK_Comment_Sach] FOREIGN KEY([MaSach]) REFERENCES [dbo].[Sach] ([MaSach]);
ALTER TABLE [dbo].[Comment] ADD CONSTRAINT [FK_Comment_KhachHang] FOREIGN KEY([MaKH]) REFERENCES [dbo].[KhachHang] ([MaKH]);
ALTER TABLE [dbo].[CTDatHang] ADD CONSTRAINT [FK_CTDATHAN_DONHANG] FOREIGN KEY([SoDH]) REFERENCES [dbo].[DonDatHang] ([SoDH]);
ALTER TABLE [dbo].[CTDatHang] ADD CONSTRAINT [FK_CTDATHAN_SACH] FOREIGN KEY([MaSach]) REFERENCES [dbo].[Sach] ([MaSach]);
ALTER TABLE [dbo].[DonDatHang] ADD CONSTRAINT [FK_DONDATHA_KHACHHAN] FOREIGN KEY([MaKH]) REFERENCES [dbo].[KhachHang] ([MaKH]);
ALTER TABLE [dbo].[Sach] ADD CONSTRAINT [FK_SACH_CHUDE] FOREIGN KEY([MaCD]) REFERENCES [dbo].[ChuDe] ([MaCD]);
ALTER TABLE [dbo].[Sach] ADD CONSTRAINT [FK_SACH_NXB] FOREIGN KEY([MaNXB]) REFERENCES [dbo].[NhaXuatBan] ([MaNXB]);
ALTER TABLE [dbo].[VietSach] ADD CONSTRAINT [FK_VIETSACH_TACGIA] FOREIGN KEY([MaTG]) REFERENCES [dbo].[TacGia] ([MaTG]);
ALTER TABLE [dbo].[VietSach] ADD CONSTRAINT [FK_VIETSACH_SACH] FOREIGN KEY([MaSach]) REFERENCES [dbo].[Sach] ([MaSach]);
GO

--tags
USE [BookStoreDB];
GO

-- THỰC HIỆN CẬP NHẬT DỮ LIỆU TAGS CHO BẢNG SACH
-- Dựa trên logic: MaLoai 1 (#kienthuc), MaLoai 2 (#giaitri), MaLoai 3 (#khampha)
-- Các sub-tag được suy luận từ tên Chủ Đề (Tenchude)

UPDATE S
SET S.Tags = 
    CASE 
        -- NHÓM 1: KIẾN THỨC GIÁO DỤC (MaLoai = 1) -> Gốc là #kienthuc
        WHEN P.MaLoai = 1 THEN 
            N'#kienthuc, ' + 
            CASE 
                WHEN C.Tenchude LIKE N'%Tin học%' THEN N'#congnghe, #laptrinh, #it'
                WHEN C.Tenchude LIKE N'%Kinh tế%' THEN N'#kinhdoanh, #taichinh, #quanly'
                WHEN C.Tenchude LIKE N'%Văn học%' THEN N'#vanhoc, #ngonngu'
                WHEN C.Tenchude LIKE N'%Khoa học%' THEN N'#khoahoc, #khampha_vutru'
                WHEN C.Tenchude LIKE N'%Nghệ thuật%' OR C.Tenchude LIKE N'%Âm nhạc%' OR C.Tenchude LIKE N'%Mỹ thuật%' THEN N'#nghethuat, #sangtao, #chill'
                WHEN C.Tenchude LIKE N'%Nghệ thuật sống%' THEN N'#kynang, #phattrienbanthan'
                WHEN C.Tenchude LIKE N'%Du lịch%' THEN N'#travelexplore, #vungmien'
                WHEN C.Tenchude LIKE N'%Giới tính%' THEN N'#tamly, #suckhoe'
                ELSE N'#giaoduc, #hocphat'
            END

        -- NHÓM 2: TRUYỆN TRANH / GIẢI TRÍ (MaLoai = 2) -> Gốc là #giaitri
        WHEN P.MaLoai = 2 THEN 
            N'#giaitri, ' + 
            CASE 
                WHEN C.Tenchude LIKE N'%Cổ Tích%' OR C.Tenchude LIKE N'%Dân Gian%' THEN N'#folklore, #vietnam, #tuoitho'
                WHEN C.Tenchude LIKE N'%Truyền Thuyết Đô Thị%' OR C.Tenchude LIKE N'%Kinh Dị%' THEN N'#horror, #mystery, #scary'
                WHEN C.Tenchude LIKE N'%Manga%' THEN N'#otaku, #japan, #comics'
                WHEN C.Tenchude LIKE N'%Trinh Thám%' THEN N'#logic, #detective, #hacknao'
                WHEN C.Tenchude LIKE N'%Huyền Huyễn%' THEN N'#fantasy, #kyao, #vothuat'
                ELSE N'#reading, #relax'
            END

        -- NHÓM 3: TẠP CHÍ (MaLoai = 3) -> Gốc là #khampha
        WHEN P.MaLoai = 3 THEN 
            N'#khampha, ' + 
            CASE 
                WHEN C.Tenchude LIKE N'%Lịch Sử%' THEN N'#history, #tu lieu'
                WHEN C.Tenchude LIKE N'%Du Lịch%' THEN N'#travel, #lifestyle'
                WHEN C.Tenchude LIKE N'%Công Nghệ%' THEN N'#hightech, #news'
                WHEN C.Tenchude LIKE N'%Địa Lý%' THEN N'#geography, #thegioi'
                WHEN C.Tenchude LIKE N'%Phóng Sự%' THEN N'#social, #thuctrang'
                ELSE N'#magazine, #tintuc'
            END
        ELSE S.Tags
    END
FROM [dbo].[Sach] S
INNER JOIN [dbo].[ChuDe] C ON S.MaCD = C.MaCD
INNER JOIN [dbo].[PhanLoai] P ON C.MaLoai = P.MaLoai;
GO

-- KIỂM TRA LẠI KẾT QUẢ CẬP NHẬT
SELECT S.MaSach, S.TenSach, P.TenLoai, C.Tenchude, S.Tags
FROM [dbo].[Sach] S
JOIN [dbo].[ChuDe] C ON S.MaCD = C.MaCD
JOIN [dbo].[PhanLoai] P ON C.MaLoai = P.MaLoai
ORDER BY P.MaLoai;
GO
ALTER TABLE KhachHang ADD IsOnline BIT DEFAULT 0;
ALTER TABLE KhachHang ADD LastSeen DATETIME;