USE master
CREATE DATABASE Sales
-- ON
-- PRIMARY
-- (
-- NAME = tuan1_data,
-- FILENAME =&#39;T:\ThucHanhSQL\tuan1_data.mdf&#39;,
-- SIZE = 10MB,
-- MAXSIZE = 20MB,
-- FILEGROWTH = 20%
-- )
-- LOG ON
-- (
-- NAME = tuan1_log,
-- FILENAME = &#39;T:\ThucHanhSQL\tuan1_log.ldf&#39;,
-- SIZE = 10MB,
-- MAXSIZE = 20MB,
-- FILEGROWTH = 20%
-- )
USE Sales
-- 1. Kiểu dữ liệu tự định nghĩa
EXEC sp_addtype 'Mota','NVARCHAR(40)'
EXEC sp_addtype 'IDKH','CHAR(10)','NOT NULL'
EXEC sp_addtype 'DT','CHAR(12)'
-- 2. Tạo table
CREATE TABLE SanPham (
MaSP CHAR(6) NOT NULL,
TenSP VARCHAR(20),
NgayNhap Date,
DVT CHAR(10),
SoLuongTon INT,
DonGiaNhap money,
)
CREATE TABLE HoaDon (
MaHD CHAR(10) NOT NULL,
NgayLap Date,
NgayGiao Date,
MaKH IDKH,
DienGiai Mota,
)
CREATE TABLE KhachHang (
MaKH IDKH,
TenKH NVARCHAR(30),
DiaCHi NVARCHAR(40),
DienThoai DT,
)
CREATE TABLE ChiTietHD (
MaHD CHAR(10) NOT NULL,
MaSP CHAR(6) NOT NULL,
SoLuong INT
)

-- 3. Trong Table HoaDon, sửa cột DienGiai thành nvarchar(100).
ALTER TABLE HoaDon
ALTER COLUMN DienGiai NVARCHAR(100)
-- 4. Thêm vào bảng SanPham cột TyLeHoaHong float
ALTER TABLE SanPham
ADD TyLeHoaHong float
-- 5. Xóa cột NgayNhap trong bảng SanPham
ALTER TABLE SanPham
DROP COLUMN NgayNhap
-- 6.Tạo các ràng buộc khóa chính và khóa ngoại cho các bảng trên
ALTER TABLE SanPham
ADD CONSTRAINT PK_SanPham PRIMARY KEY (MaSP);

ALTER TABLE HoaDon
ADD CONSTRAINT PK_HoaDon PRIMARY KEY (MaHD);

ALTER TABLE KhachHang
ADD CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH);

ALTER TABLE HoaDon
ADD CONSTRAINT FK_HoaDon_KhachHang FOREIGN KEY (MaKH)
REFERENCES KhachHang (MaKH);

ALTER TABLE ChiTietHD
ADD CONSTRAINT FK_ChiTietHD_HoaDon FOREIGN KEY (MaHD)
REFERENCES HoaDon (MaHD);

ALTER TABLE ChiTietHD
ADD CONSTRAINT FK_ChiTietHD_SanPham FOREIGN KEY (MaSP)
REFERENCES SanPham (MaSP);

-- 7. Thêm vào bảng HoaDon các ràng buộc
-- Thêm các ràng buộc vào bảng HoaDon
ALTER TABLE HoaDon 
ADD CONSTRAINT chk_NgayGiao_NgayLap CHECK (NgayGiao >= NgayLap),
    CONSTRAINT chk_MaHD CHECK (MaHD LIKE '[a-zA-Z][a-zA-Z0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT df_NgayLap DEFAULT GETDATE() FOR NgayLap;
--8. Thêm vào bảng Sản phẩm các ràng buộc
ALTER TABLE SanPham ADD NgayNhap DATE DEFAULT GETDATE();
-- Thêm ràng buộc cho SoLuongTon
ALTER TABLE SanPham
ADD CONSTRAINT CK_SanPham_SoLuongTon CHECK (SoLuongTon >= 0 AND SoLuongTon <= 500);

-- Thêm ràng buộc cho DonGiaNhap
ALTER TABLE SanPham
ADD CONSTRAINT CK_SanPham_DonGiaNhap CHECK (DonGiaNhap > 0);

-- Thêm ràng buộc cho DVT
ALTER TABLE SanPham
ADD CONSTRAINT CK_SanPham_DVT CHECK (DVT IN ('KG', 'Thùng', 'Hộp', 'Cái'));

-- 9. Dùng lệnh T-SQL nhập dữ liệu vào 4 table trên, dữ liệu tùy ý, chú ý các ràng buộc của mỗi Table
USE Sales
-- Insert data into SanPham table
INSERT INTO SanPham (MaSP, TenSP, DVT, SoLuongTon, DonGiaNhap, TyLeHoaHong)
VALUES ('SP001', 'Sản phẩm 1', 'Thùng', 300, 500000, 0.1),
('SP002', 'Sản phẩm 2', 'Cái', 900, 20000, 0.05),
('SP003', 'Sản phẩm 3', 'Hộp', 20, 100000, 0.2),
('SP004', 'Sản phẩm 4', 'KG', 100, 15000, 0.15);
SELECT * FROM SanPham;

-- Insert data into HoaDon table
INSERT INTO HoaDon (MaHD, NgayLap, NgayGiao, MaKH, DienGiai)
VALUES ('HD001', '2022-01-01', '2022-01-02', 'KH001', N'Hóa đơn số 1'),
('HD002', '2022-02-01', '2022-02-03', 'KH002', N'Hóa đơn số 2'),
('HD003', '2022-03-01', '2022-03-04', 'KH003', N'Hóa đơn số 3'),
('HD004', '2022-04-01', '2022-04-05', 'KH004', N'Hóa đơn số 4');
SELECT * FROM HoaDon;

-- Insert data into KhachHang table
INSERT INTO KhachHang (MaKH, TenKH, DiaCHi, DienThoai)
VALUES ('KH001', N'Khách hàng 1', N'Địa chỉ 1', '0123456789'),
('KH002', N'Khách hàng 2', N'Địa chỉ 2', '0123456789'),
('KH003', N'Khách hàng 3', N'Địa chỉ 3', '0123456789'),
('KH004', N'Khách hàng 4', N'Địa chỉ 4', '0123456789');
SELECT * FROM KhachHang

-- Insert data into ChiTietHD table
INSERT INTO ChiTietHD (MaHD, MaSP, SoLuong)
VALUES ('HD001', 'SP001', 10),
('HD001', 'SP002', 20),
('HD002', 'SP002', 30),
('HD002', 'SP003', 5),
('HD003', 'SP001', 15),
('HD003', 'SP004', 25),
('HD004', 'SP003', 20),
('HD004', 'SP004', 10);
SELECT * FROM ChiTietHD
-- 10.Có thể xóa một hóa đơn bất kỳ trong bảng HoaDon. Tuy nhiên, việc xóa một hóa đơn sẽ ảnh hưởng đến dữ liệu trong bảng khác mà liên quan đến hóa đơn đó, ví dụ như bảng ChiTietHoaDon. Nếu một hóa đơn đã có các chi tiết hóa đơn liên kết với nó trong bảng ChiTietHoaDon, khi xóa hóa đơn đó sẽ xóa tất cả các bản ghi liên quan trong bảng ChiTietHoaDon.

-- Để xóa một hóa đơn trong bảng HoaDon mà không ảnh hưởng đến các bảng khác, ta có thể sử dụng câu lệnh DELETE. Cú pháp của câu lệnh DELETE như sau:
-- Có thể xóa một hóa đơn bất kỳ trong bảng HoaDon. Tuy nhiên, việc xóa một hóa đơn sẽ ảnh hưởng đến dữ liệu trong bảng khác mà liên quan đến hóa đơn đó, ví dụ như bảng ChiTietHoaDon. Nếu một hóa đơn đã có các chi tiết hóa đơn liên kết với nó trong bảng ChiTietHoaDon, khi xóa hóa đơn đó sẽ xóa tất cả các bản ghi liên quan trong bảng ChiTietHoaDon.
-- Để xóa một hóa đơn trong bảng HoaDon mà không ảnh hưởng đến các bảng khác, ta có thể sử dụng câu lệnh DELETE. Cú pháp của câu lệnh DELETE như sau:
DELETE FROM HoaDon
WHERE MaHD = 'HD001';
SELECT * FROM HoaDon;
-- 11.Nhập 2 bản ghi mới vào bảng ChiTietHD với MaHD = ‘HD999999999’ và MaHD=’1234567890’. Có nhập được không? Tại sao?
-- Không thể nhập được 2 bản ghi mới vào bảng ChiTietHD với MaHD lần lượt là 'HD999999999' và '1234567890' vì MaHD là khoá ngoại của bảng ChiTietHD tham chiếu đến khoá chính của bảng HoaDon, do đó các giá trị trong trường MaHD của bảng ChiTietHD phải tồn tại trong trường MaHD của bảng HoaDon. Vì vậy nếu không có hóa đơn nào có MaHD là 'HD999999999' hoặc '1234567890' thì không thể thêm được bản ghi mới vào bảng ChiTietHD với MaHD tương ứng.
-- 12.Đổi tên CSDL Sales thành BanHang
ALTER DATABASE Sales MODIFY NAME = BanHang;
-- 13.Tạo thư mục T:\QLBH, chép CSDL BanHang vào thư mục này, bạn có sao chép được không? Tại sao? Muốn sao chép được bạn phải làm gì? Sau khi sao chép bạn thực hiện Attach vào lại SQL.
/*	Để sao chép CSDL BanHang vào thư mục T:\QLBH, bạn có thể sử dụng lệnh Backup và Restore của SQL Server Management Studio.

	Trước hết, bạn cần thực hiện backup CSDL BanHang ra một file .bak. Bạn có thể thực hiện việc này bằng cách:
	Mở SQL Server Management Studio và kết nối tới SQL Server mà CSDL BanHang đang nằm
	Chọn CSDL BanHang và chuột phải vào CSDL đó, chọn Tasks -> Backup.
	Trong cửa sổ Backup Database, chọn đường dẫn tới thư mục chứa file backup và đặt tên cho file backup.
	Nhấn OK để bắt đần
	Copy file .bak vừa backup sang thư mục T:\QLBH.

	Sau khi copy file .bak sang thư mục T:\QLBH, bạn có thể sử dụng lệnh Restore để khôi phục CSDL BanHang từ file backup vào SQL Server. Bạn có thể thực hiện việc này bằng cách:

	Trong SQL Server Management Studio, chuột phải vào node Databases và chọn Restore Database.
	Trong cửa sổ Restore Database, chọn From device và chọn đường dẫn tới file backup .bak.
	Chọn tên cho CSDL mới trong phần To database và thiết lập các tùy chọn phục hồi khác (nếu cần
	Nhấn OK để bắt đầu khôi phục CSDL.
	Sau khi khôi phục CSDL, bạn có thể sử dụng lệnh Attach Database để đính kèm CSDL vào SQL Server. */
