create database GameTheBai
-- 1. Bảng Định nghĩa Thẻ bài (Mẫu gốc)
CREATE TABLE ThuVienTheBai (
    TheID INT PRIMARY KEY IDENTITY(1,1),
    MaThe NVARCHAR(20) NOT NULL,        -- Ví dụ: ATK_BASIC
    TenThe NVARCHAR(100) NOT NULL,
    HaoTonMana INT DEFAULT 1,
    CongSatThuong INT DEFAULT 0,       -- Sát thương = ATK người chơi + CongSatThuong
    GiaTriGiap INT DEFAULT 0,
    GiamStress INT DEFAULT 0,          -- Số âm là giảm
    GiamKietSuc INT DEFAULT 0,         -- Số âm là giảm
    HoiMana INT DEFAULT 0,             -- Số dương là cộng thêm mana
    MoTa NVARCHAR(500),
    TenHinhAnh NVARCHAR(100)           -- Lưu tên file trong thư mục Images (vd: tram_kich.png)
);

-- 2. Bảng Quái vật và Boss
CREATE TABLE QuaiVat (
    QuaiID INT PRIMARY KEY IDENTITY(1,1),
    TenQuai NVARCHAR(100) NOT NULL,
    MauToiDa INT NOT NULL,
    TanCongGoc INT DEFAULT 0,
    LaBoss BIT DEFAULT 0,              -- 1 là Boss, 0 là quái thường
    TenHinhAnh NVARCHAR(100)
);

-- 3. Bảng Các Nút trên Bản đồ
CREATE TABLE NutBanDo (
    NutID INT PRIMARY KEY IDENTITY(1,1),
    Tang INT NOT NULL,                 -- Tầng 1, 2, 3...
    LoaiNut NVARCHAR(50),              -- 'TranDanh', 'SuKien', 'NghiNgo', 'Boss'
    ViTriX INT                         -- Vị trí ngang để vẽ giao diện (0, 1, 2...)
);

-- 4. Bảng Liên kết Đường đi (Dưới lên trên)
CREATE TABLE DuongNoiBanDo (
    NutTruocID INT FOREIGN KEY REFERENCES NutBanDo(NutID),
    NutSauID INT FOREIGN KEY REFERENCES NutBanDo(NutID),
    PRIMARY KEY (NutTruocID, NutSauID)
);

-- 5. Bảng Lượt chơi hiện tại (Run)
CREATE TABLE LuotChoi (
    RunID INT PRIMARY KEY IDENTITY(1,1),
    TenNguoiChoi NVARCHAR(100) DEFAULT N'Ngự Hồn Sư',
    MauToiDa INT DEFAULT 80,
    MauHienTai INT DEFAULT 80,
    AtkHienTai INT DEFAULT 5,
    StressHienTai INT DEFAULT 0,
    KietSucHienTai INT DEFAULT 0,
    ManaHienTai INT DEFAULT 3,
    TienVang INT DEFAULT 0,
    NutHienTaiID INT FOREIGN KEY REFERENCES NutBanDo(NutID),
    TrangThai NVARCHAR(20) DEFAULT 'Active' -- 'Active', 'Won', 'Dead'
);

-- 6. Bảng Hành trang Thẻ bài (Chứa 13 lá bài khởi đầu và bài nhặt được)
CREATE TABLE HanhTrangThe (
    HanhTrangID INT PRIMARY KEY IDENTITY(1,1), -- ID duy nhất cho từng lá bài vật lý
    RunID INT FOREIGN KEY REFERENCES LuotChoi(RunID),
    TheID INT FOREIGN KEY REFERENCES ThuVienTheBai(TheID)
);

-- NẠP THƯ VIỆN 5 LOẠI THẺ BÀI CƠ BẢN
INSERT INTO ThuVienTheBai (MaThe, TenThe, HaoTonMana, CongSatThuong, GiaTriGiap, GiamStress, GiamKietSuc, HoiMana, MoTa, TenHinhAnh) VALUES 
('ATK_01', N'Trảm Kích', 1, 1, 0, 0, 0, 0, N'Gây sát thương = ATK + 3.', 'tramkich.png'),
('DEF_01', N'Phòng Hộ', 1, 0, 0, 5, 0, 0, N'Nhận 5 Giáp.', 'kienthu.png'),
('SKL_STRESS', N'Tĩnh Tâm', 1, 0, 0, -2, 0, 0, N'Giảm 2 điểm Stress.', 'tinhtam.png'),
('SKL_EXHAUST', N'Thả Lỏng', 1, 0, 0, 0, -2, 0, N'Giảm 2 điểm Kiệt sức.', 'thalong.png'),
('SKL_MANA', N'Hồi Khí', 0, 0, 0, 0, 0, 1, N'Cộng ngay 1 Mana.', 'hoisuc.png');

-- NẠP QUÁI VẬT VÀ BOSS
INSERT INTO QuaiVat (TenQuai, MauToiDa, TanCongGoc, LaBoss, TenHinhAnh) VALUES 
(N'Xương Cận Chiến', 20, 6, 0, 'quaixuong-canchien.png'),
(N'Xương Xạ Chiến', 15, 4, 0, 'xuong_xa_chien.png'),
(N'Đại Tướng Xương Vương', 150, 12, 1, 'boss_xuong_vuong.png');

-- TẠO CẤU TRÚC BẢN ĐỒ (5 TẦNG, BOSS Ở ĐỈNH)
INSERT INTO NutBanDo (Tang, LoaiNut, ViTriX) VALUES 
(1, 'TranDanh', 1), (2, 'TranDanh', 0), (2, 'SuKien', 2), (3, 'NghiNgo', 1), (4, 'TranDanh', 1), (5, 'Boss', 1);

-- NỐI ĐƯỜNG CHO BẢN ĐỒ
INSERT INTO DuongNoiBanDo (NutTruocID, NutSauID) VALUES (1, 2), (1, 3), (2, 4), (3, 4), (4, 5), (5, 6);

-- KHỞI TẠO MỘT LƯỢT CHƠI MỚI (RUN)
INSERT INTO LuotChoi (TenNguoiChoi, NutHienTaiID) VALUES (N'Người Chơi 1', 1);

-- CẤP HÀNH TRANG KHỞI ĐẦU (13 LÁ BÀI CHO RUNID = 1)
-- 5 lá Trảm Kích (TheID = 1)
INSERT INTO HanhTrangThe (RunID, TheID) SELECT 1, 1 FROM (VALUES (1),(2),(3),(4),(5)) AS T(N);
-- 5 lá Kiên Thủ (TheID = 2)
INSERT INTO HanhTrangThe (RunID, TheID) SELECT 1, 2 FROM (VALUES (1),(2),(3),(4),(5)) AS T(N);
-- 1 lá Tĩnh Tâm (TheID = 3), 1 lá Thả Lỏng (TheID = 4), 1 lá Hồi Khí (TheID = 5)
INSERT INTO HanhTrangThe (RunID, TheID) VALUES (1, 3), (1, 4), (1, 5);
-- 1. Xóa dữ liệu cũ để làm mới
DELETE FROM DuongNoiBanDo;
DELETE FROM NutBanDo;
DBCC CHECKIDENT ('NutBanDo', RESEED, 0);

-- 2. Tạo các nút (Tang, LoaiNut, ViTriX)
-- Tầng 1 (Bắt đầu)
INSERT INTO NutBanDo VALUES (1, 'TranDanh', 0); -- NutID 1
-- Tầng 2 -> 14 (Hành trình)
INSERT INTO NutBanDo VALUES (2, 'SuKien', -1), (2, 'TranDanh', 1); -- 2, 3
INSERT INTO NutBanDo VALUES (3, 'TranDanh', 0); -- 4
INSERT INTO NutBanDo VALUES (4, 'NghiNgo', -1), (4, 'TranDanh', 1); -- 5, 6
INSERT INTO NutBanDo VALUES (5, 'TranDanh', 0); -- 7
INSERT INTO NutBanDo VALUES (6, 'SuKien', 1); -- 8
INSERT INTO NutBanDo VALUES (7, 'TranDanh', -1), (7, 'TranDanh', 1); -- 9, 10
INSERT INTO NutBanDo VALUES (8, 'NghiNgo', 0); -- 11
INSERT INTO NutBanDo VALUES (9, 'TranDanh', 0); -- 12
INSERT INTO NutBanDo VALUES (10, 'SuKien', -1), (10, 'TranDanh', 1); -- 13, 14
INSERT INTO NutBanDo VALUES (11, 'TranDanh', 0); -- 15
INSERT INTO NutBanDo VALUES (12, 'TranDanh', 1); -- 16
INSERT INTO NutBanDo VALUES (13, 'NghiNgo', -1), (13, 'SuKien', 1); -- 17, 18
INSERT INTO NutBanDo VALUES (14, 'TranDanh', 0); -- 19
-- Tầng 15 (BOSS)
INSERT INTO NutBanDo VALUES (15, 'Boss', 0); -- NutID 20

-- 3. Nối đường (Cố gắng đi lên tầng tiếp theo)
INSERT INTO DuongNoiBanDo VALUES (1, 2), (1, 3);
INSERT INTO DuongNoiBanDo VALUES (2, 4), (3, 4);
INSERT INTO DuongNoiBanDo VALUES (4, 5), (4, 6);
INSERT INTO DuongNoiBanDo VALUES (5, 7), (6, 7);
INSERT INTO DuongNoiBanDo VALUES (7, 8);
INSERT INTO DuongNoiBanDo VALUES (8, 9), (8, 10);
INSERT INTO DuongNoiBanDo VALUES (9, 11), (10, 11);
INSERT INTO DuongNoiBanDo VALUES (11, 12);
INSERT INTO DuongNoiBanDo VALUES (12, 13), (12, 14);
INSERT INTO DuongNoiBanDo VALUES (13, 15), (14, 15);
INSERT INTO DuongNoiBanDo VALUES (15, 16);
INSERT INTO DuongNoiBanDo VALUES (16, 17), (16, 18);
INSERT INTO DuongNoiBanDo VALUES (17, 19), (18, 19);
INSERT INTO DuongNoiBanDo VALUES (19, 20);

-- Cập nhật người chơi về vạch xuất phát
UPDATE LuotChoi SET NutHienTaiID = 1 WHERE RunID = 1;
-- 1. Làm sạch dữ liệu
DELETE FROM DuongNoiBanDo;
DELETE FROM NutBanDo;
DBCC CHECKIDENT ('NutBanDo', RESEED, 0);

-- 2. Tạo Nút cho 15 Tầng (ViTriX: -1.5, -0.5, 0.5, 1.5 để chia 4 làn)
-- Tầng 1 (Bắt đầu)
INSERT INTO NutBanDo VALUES (1, 'CombatLow', 0); -- NutID 1

-- Tầng 2-14: Phân nhánh (Mỗi tầng khoảng 3-4 nút)
-- Tầng 2
INSERT INTO NutBanDo VALUES (2, 'Event', -0.5), (2, 'CombatLow', 0.5); -- ID 2,3
-- Tầng 3
INSERT INTO NutBanDo VALUES (3, 'CombatLow', -1), (3, 'Shop', 0), (3, 'CombatLow', 1); -- ID 4,5,6
-- Tầng 4
INSERT INTO NutBanDo VALUES (4, 'CombatMid', -0.5), (4, 'Event', 0.5); -- ID 7,8
-- Tầng 5 (Ngã 4 chính)
INSERT INTO NutBanDo VALUES (5, 'CombatMid', -1.5), (5, 'Forge', -0.5), (5, 'Shop', 0.5), (5, 'CombatMid', 1.5); -- ID 9,10,11,12
-- ... (Các tầng tiếp theo tương tự, đan xen Forge và Shop)
INSERT INTO NutBanDo VALUES (6, 'Event', -1), (6, 'CombatMid', 0), (6, 'Event', 1); -- 13,14,15
INSERT INTO NutBanDo VALUES (7, 'CombatHigh', -0.5), (7, 'CombatHigh', 0.5); -- 16,17
INSERT INTO NutBanDo VALUES (8, 'Shop', -1), (8, 'Forge', 0), (8, 'Event', 1); -- 18,19,20
INSERT INTO NutBanDo VALUES (9, 'CombatHigh', 0); -- 21
INSERT INTO NutBanDo VALUES (10, 'Event', -0.5), (10, 'Shop', 0.5); -- 22,23
INSERT INTO NutBanDo VALUES (11, 'CombatHigh', -1), (11, 'CombatHigh', 1); -- 24,25
INSERT INTO NutBanDo VALUES (12, 'Forge', 0); -- 26
INSERT INTO NutBanDo VALUES (13, 'Shop', -0.5), (13, 'Event', 0.5); -- 27,28
INSERT INTO NutBanDo VALUES (14, 'Event', 0); -- 29

-- Tầng 15 (Boss Cuối)
INSERT INTO NutBanDo VALUES (15, 'Boss', 0); -- ID 30

-- 3. Nối đường (Ví dụ cơ bản, bạn có thể nối chéo để tạo mạng lưới)
INSERT INTO DuongNoiBanDo VALUES (1,2), (1,3);
INSERT INTO DuongNoiBanDo VALUES (2,4), (2,5), (3,5), (3,6);
INSERT INTO DuongNoiBanDo VALUES (4,7), (5,7), (5,8), (6,8);
INSERT INTO DuongNoiBanDo VALUES (7,9), (7,10), (8,11), (8,12);
INSERT INTO DuongNoiBanDo VALUES (9,13), (10,14), (11,14), (12,15);
INSERT INTO DuongNoiBanDo VALUES (13,16), (14,16), (14,17), (15,17);
INSERT INTO DuongNoiBanDo VALUES (16,18), (16,19), (17,19), (17,20);
INSERT INTO DuongNoiBanDo VALUES (18,21), (19,21), (20,21);
INSERT INTO DuongNoiBanDo VALUES (21,22), (21,23);
INSERT INTO DuongNoiBanDo VALUES (22,24), (23,25);
INSERT INTO DuongNoiBanDo VALUES (24,26), (25,26);
INSERT INTO DuongNoiBanDo VALUES (26,27), (26,28);
INSERT INTO DuongNoiBanDo VALUES (27,29), (28,29);
INSERT INTO DuongNoiBanDo VALUES (29,30);

UPDATE LuotChoi SET NutHienTaiID = 1 WHERE RunID = 1;