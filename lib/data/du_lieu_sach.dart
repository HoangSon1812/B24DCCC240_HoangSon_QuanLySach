import '../models/sach.dart';

// Dữ liệu chỉ khởi tạo một lần trong bộ nhớ.
List<Sach> danhSachSach = [
  Sach(
    maSach: '1',
    tenSach: 'Lập trình Android cơ bản',
    tacGia: 'Nguyễn Văn A',
    theLoai: 'Công nghệ',
    tinhTrang: 'Đang đọc',
    danhGia: 4,
    ghiChu: 'Sách dành cho người mới bắt đầu',
  ),
  Sach(
    maSach: '2',
    tenSach: 'Đắc nhân tâm',
    tacGia: 'Dale Carnegie',
    theLoai: 'Kỹ năng sống',
    tinhTrang: 'Đã đọc',
    danhGia: 5,
    ghiChu: '',
  ),
  Sach(
    maSach: '3',
    tenSach: 'Dế Mèn phiêu lưu ký',
    tacGia: 'Tô Hoài',
    theLoai: 'Văn học',
    tinhTrang: 'Chưa đọc',
    danhGia: 0,
    ghiChu: '',
  ),
];

int _maSachTiepTheo = 4;

String taoMaSach() {
  while (danhSachSach.any((sach) => sach.maSach == '$_maSachTiepTheo')) {
    _maSachTiepTheo++;
  }
  return '${_maSachTiepTheo++}';
}
