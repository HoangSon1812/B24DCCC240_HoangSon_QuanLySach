# Thư viện sách cá nhân

Ứng dụng Flutter dành cho bài tập Android, gồm đúng 4 màn hình: đăng nhập, danh sách, thêm sách và chi tiết sách. Giao diện tiếng Việt, nền sáng và màu xanh ngọc `#00796B`.

Sinh viên: **Hoàng Sơn — B24DCCC240**, lớp **INT1449-20261-02**. Bài làm sử dụng Flutter/Dart theo phương án đã được giảng viên đồng ý.

Repository: [B24DCCC240_HoangSon_QuanLySach](https://github.com/HoangSon1812/B24DCCC240_HoangSon_QuanLySach).

## Báo cáo

[Bản Word](B24DCCC240_HoangSon_BaoCao.docx) · [Bản PDF](B24DCCC240_HoangSon_BaoCao.pdf)

Báo cáo có mô tả từng màn hình, đoạn mã Dart thực tế, 14 ảnh chụp trên máy ảo Android và kết quả kiểm thử. File báo cáo được đặt tên theo mẫu của đề bài.

## Chạy ứng dụng

Yêu cầu Flutter 3.47.5 / Dart 3.13.4 trở lên và Android SDK. Mở thư mục dự án trong Android Studio hoặc VS Code, sau đó chạy:

```powershell
flutter pub get
flutter emulators --launch Pixel_8
flutter devices
flutter run
```

Có thể bỏ bước mở máy ảo khi đã kết nối điện thoại Android có bật USB debugging. `Pixel_8` là tên máy ảo sẵn có trên máy hiện tại; dùng `flutter emulators` để xem tên máy ảo trên máy khác.

Tài khoản mẫu: **admin / 123456**.

## Chức năng

- Kiểm tra đăng nhập trống hoặc sai. Đăng nhập thành công thay thế màn hình bằng `Navigator.pushReplacement()`.
- Hiển thị 3 sách mẫu, tổng số sách, số sách đã đọc và số sách chưa đọc xong.
- Thêm sách: bắt buộc tên và tác giả; chọn thể loại, tình trạng, 0–5 sao và ghi chú tùy chọn.
- Xem chi tiết, đổi đánh giá, đánh dấu đã đọc và xóa có hộp thoại xác nhận.
- Nhấn lại sao đang được chọn để đưa đánh giá về 0.
- Thống kê và danh sách cập nhật khi trở về từ màn hình thêm hoặc chi tiết, kể cả dùng Back của Android.
- Hỗ trợ sách trùng tên bằng mã riêng, danh sách rỗng và cuộn khi mở bàn phím.

Dữ liệu chỉ nằm trong `List<Sach>` trong bộ nhớ. Tắt rồi mở lại ứng dụng hoặc hot restart sẽ khôi phục 3 sách mẫu. Không có database, API, backend hay package quản lý trạng thái.

## Cấu trúc mã nguồn

```text
lib/
  main.dart
  models/sach.dart
  data/du_lieu_sach.dart
  screens/man_hinh_dang_nhap.dart
  screens/man_hinh_danh_sach.dart
  screens/man_hinh_them_sach.dart
  screens/man_hinh_chi_tiet_sach.dart
  widgets/the_sach.dart
test/
  thu_vien_test.dart
```

`main.dart` cấu hình theme và màn hình đầu tiên. `Sach` chứa 7 thuộc tính theo đề bài. `du_lieu_sach.dart` khởi tạo dữ liệu một lần và tạo mã tăng dần, không trùng với các sách hiện có.

Màn hình danh sách chờ `await Navigator.push(...)`, kiểm tra `mounted`, rồi gọi `setState()` để đọc lại danh sách và tính lại thống kê. Màn hình thêm trả `true` sau khi lưu; Back không thêm dữ liệu. Màn hình chi tiết nhận chính đối tượng `Sach` trong danh sách, cập nhật trực tiếp và xóa bằng `maSach`.

`the_sach.dart` chứa thẻ sách, nhãn tình trạng, hàng sao dùng chung và các hằng màu. Các controller được tạo trong State và giải phóng bằng `dispose()`.

## Kiểm tra và tạo APK

```powershell
flutter analyze
flutter test
flutter build apk --debug
```

Bộ kiểm thử kiểm tra đăng nhập, kiểm tra form, trim dữ liệu, giá trị mặc định, các lựa chọn thể loại/tình trạng, đánh giá 0–5, cập nhật thống kê, Back, sách trùng tên, hủy xóa, xóa hết sách và màn hình nhỏ có chữ lớn/bàn phím.

APK debug nằm tại `build/app/outputs/flutter-apk/app-debug.apk`.

Đã kiểm tra trên Flutter 3.47.5: `flutter analyze` không có lỗi, 6 bài kiểm thử đều đạt và ứng dụng chạy bằng `flutter run` trên máy ảo Pixel 8 / Android 16 (API 36). Đã mở trực tiếp cả 4 màn hình trên máy ảo; ảnh chụp kiểm tra nằm trong `build/kiem_tra/`.

Tệp yêu cầu đính kèm không chứa ảnh mẫu. Bố cục được triển khai theo mô tả văn bản trong đề bài.
