import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thu_vien_sach/data/du_lieu_sach.dart';
import 'package:thu_vien_sach/main.dart';
import 'package:thu_vien_sach/models/sach.dart';
import 'package:thu_vien_sach/screens/man_hinh_dang_nhap.dart';
import 'package:thu_vien_sach/screens/man_hinh_danh_sach.dart';
import 'package:thu_vien_sach/widgets/the_sach.dart';

Sach saoChepSach(Sach sach) => Sach(
  maSach: sach.maSach,
  tenSach: sach.tenSach,
  tacGia: sach.tacGia,
  theLoai: sach.theLoai,
  tinhTrang: sach.tinhTrang,
  danhGia: sach.danhGia,
  ghiChu: sach.ghiChu,
);

Future<void> nhan(WidgetTester boKiemTra, Finder viTri) async {
  await boKiemTra.ensureVisible(viTri);
  await boKiemTra.pumpAndSettle();
  if (boKiemTra.widget(viTri) is TheSach) {
    await boKiemTra.tapAt(boKiemTra.getTopLeft(viTri) + const Offset(24, 24));
  } else {
    await boKiemTra.tap(viTri);
  }
  await boKiemTra.pumpAndSettle();
}

Future<void> moUngDung(WidgetTester boKiemTra) async {
  boKiemTra.view.devicePixelRatio = 1;
  boKiemTra.view.physicalSize = const Size(390, 844);
  addTearDown(boKiemTra.view.resetDevicePixelRatio);
  addTearDown(boKiemTra.view.resetPhysicalSize);
  await boKiemTra.pumpWidget(const UngDungThuVien());
}

Future<void> dangNhap(WidgetTester boKiemTra) async {
  await boKiemTra.enterText(find.byType(TextField).at(0), 'admin');
  await boKiemTra.enterText(find.byType(TextField).at(1), '123456');
  await nhan(boKiemTra, find.text('Đăng nhập'));
}

void kiemTraThongKe(int tongSo, int daDoc, int chuaXong) {
  for (final chiSo in {
    'Tổng số sách': tongSo,
    'Đã đọc': daDoc,
    'Chưa đọc xong': chuaXong,
  }.entries) {
    final cot = find
        .ancestor(of: find.text(chiSo.key).first, matching: find.byType(Column))
        .first;
    expect(
      find.descendant(of: cot, matching: find.text('${chiSo.value}')),
      findsOneWidget,
    );
  }
}

void main() {
  final duLieuBanDau = danhSachSach.map(saoChepSach).toList();
  setUp(() => danhSachSach = duLieuBanDau.map(saoChepSach).toList());

  testWidgets('Đăng nhập kiểm tra trống, sai và thay thế màn hình', (
    boKiemTra,
  ) async {
    await moUngDung(boKiemTra);
    await nhan(boKiemTra, find.text('Đăng nhập'));
    expect(
      find.text('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu'),
      findsOneWidget,
    );
    await boKiemTra.enterText(find.byType(TextField).at(0), 'admin');
    await boKiemTra.enterText(find.byType(TextField).at(1), 'sai');
    await nhan(boKiemTra, find.text('Đăng nhập'));
    expect(find.text('Sai tên đăng nhập hoặc mật khẩu'), findsOneWidget);
    expect(find.byType(ManHinhDangNhap), findsOneWidget);
    await dangNhap(boKiemTra);
    expect(find.byType(ManHinhDangNhap), findsNothing);
    expect(
      Navigator.of(boKiemTra.element(find.byType(ManHinhDanhSach))).canPop(),
      isFalse,
    );
    kiemTraThongKe(3, 1, 2);
  });

  testWidgets('Form bắt buộc tên, tác giả; lưu được ghi chú trống và 0 sao', (
    boKiemTra,
  ) async {
    await moUngDung(boKiemTra);
    await dangNhap(boKiemTra);
    await nhan(boKiemTra, find.text('Thêm sách'));
    await nhan(boKiemTra, find.text('Lưu sách'));
    expect(find.text('Vui lòng nhập tên sách'), findsOneWidget);
    expect(find.text('Vui lòng nhập tác giả'), findsOneWidget);
    expect(danhSachSach.length, 3);
    await boKiemTra.ensureVisible(find.byType(TextFormField).at(0));
    await boKiemTra.enterText(find.byType(TextFormField).at(0), '   ');
    await boKiemTra.enterText(find.byType(TextFormField).at(1), '   ');
    await nhan(boKiemTra, find.text('Lưu sách'));
    expect(danhSachSach.length, 3);
    await boKiemTra.ensureVisible(find.byType(TextFormField).at(0));
    await boKiemTra.enterText(find.byType(TextFormField).at(0), '  Sách mới  ');
    await boKiemTra.enterText(
      find.byType(TextFormField).at(1),
      '  Tác giả mới  ',
    );
    await nhan(boKiemTra, find.text('Lưu sách'));
    final sach = danhSachSach.last;
    expect(sach.tenSach, 'Sách mới');
    expect(sach.tacGia, 'Tác giả mới');
    expect(sach.theLoai, 'Văn học');
    expect(sach.tinhTrang, 'Chưa đọc');
    expect(sach.danhGia, 0);
    expect(sach.ghiChu, isEmpty);
    kiemTraThongKe(4, 1, 3);
    await boKiemTra.scrollUntilVisible(find.text('Sách mới'), 200);
    expect(find.text('Sách mới'), findsOneWidget);
    expect(boKiemTra.takeException(), isNull);
  });

  testWidgets(
    'Thể loại, radio, sao và ghi chú được lưu; Back không thêm sách',
    (boKiemTra) async {
      await moUngDung(boKiemTra);
      await dangNhap(boKiemTra);
      await nhan(boKiemTra, find.text('Thêm sách'));
      await boKiemTra.enterText(
        find.byType(TextFormField).at(0),
        'Sách tùy chọn',
      );
      await boKiemTra.pageBack();
      await boKiemTra.pumpAndSettle();
      expect(danhSachSach.length, 3);
      await nhan(boKiemTra, find.text('Thêm sách'));
      await boKiemTra.enterText(
        find.byType(TextFormField).at(0),
        'Sách tùy chọn',
      );
      await boKiemTra.enterText(find.byType(TextFormField).at(1), 'Người viết');
      await nhan(boKiemTra, find.byType(DropdownButtonFormField<String>));
      await nhan(boKiemTra, find.text('Khoa học').last);
      await nhan(boKiemTra, find.text('Đang đọc'));
      await nhan(boKiemTra, find.byTooltip('3 sao'));
      expect(find.text('3 / 5 sao'), findsOneWidget);
      await boKiemTra.ensureVisible(find.byType(TextFormField).last);
      await boKiemTra.enterText(
        find.byType(TextFormField).last,
        'Dòng một\nDòng hai',
      );
      await nhan(boKiemTra, find.text('Lưu sách'));
      expect(danhSachSach.last.theLoai, 'Khoa học');
      expect(danhSachSach.last.tinhTrang, 'Đang đọc');
      expect(danhSachSach.last.danhGia, 3);
      expect(danhSachSach.last.ghiChu, 'Dòng một\nDòng hai');
      kiemTraThongKe(4, 1, 3);
    },
  );

  testWidgets(
    'Chi tiết sửa cùng đối tượng; sao 0–5 và đã đọc cập nhật sau Back',
    (boKiemTra) async {
      await moUngDung(boKiemTra);
      await dangNhap(boKiemTra);
      final sach = danhSachSach.first;
      await nhan(boKiemTra, find.byKey(ValueKey(sach.maSach)));
      for (int soSao = 1; soSao <= 5; soSao++) {
        await nhan(boKiemTra, find.byTooltip('$soSao sao'));
        expect(sach.danhGia, soSao);
        expect(find.text('$soSao / 5 sao'), findsOneWidget);
      }
      await nhan(boKiemTra, find.byTooltip('Bỏ đánh giá'));
      expect(sach.danhGia, 0);
      await nhan(boKiemTra, find.text('Đánh dấu đã đọc'));
      expect(sach.tinhTrang, 'Đã đọc');
      expect(find.text('Đã đánh dấu sách là đã đọc'), findsOneWidget);
      final nutDaDoc = boKiemTra.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Đánh dấu đã đọc'),
      );
      expect(nutDaDoc.onPressed, isNull);
      await boKiemTra.pageBack();
      await boKiemTra.pumpAndSettle();
      kiemTraThongKe(3, 2, 1);
      final theSach = boKiemTra.widget<TheSach>(
        find.byKey(ValueKey(sach.maSach)),
      );
      expect(identical(theSach.sach, sach), isTrue);
      final hangSao = boKiemTra.widget<DanhGiaSao>(
        find.descendant(
          of: find.byKey(ValueKey(sach.maSach)),
          matching: find.byType(DanhGiaSao),
        ),
      );
      expect(hangSao.danhGia, 0);
      expect(danhSachSach.length, 3);
    },
  );

  testWidgets(
    'Sách trùng tên có mã riêng; hủy xóa, xóa đúng sách và danh sách rỗng',
    (boKiemTra) async {
      await moUngDung(boKiemTra);
      await dangNhap(boKiemTra);
      await nhan(boKiemTra, find.text('Thêm sách'));
      await boKiemTra.enterText(
        find.byType(TextFormField).at(0),
        danhSachSach.first.tenSach,
      );
      await boKiemTra.enterText(
        find.byType(TextFormField).at(1),
        'Tác giả khác',
      );
      await nhan(boKiemTra, find.text('Lưu sách'));
      expect(danhSachSach.map((sach) => sach.maSach).toSet().length, 4);
      final maSachMoi = danhSachSach.last.maSach;
      await boKiemTra.scrollUntilVisible(find.byKey(ValueKey(maSachMoi)), 200);
      await nhan(boKiemTra, find.byKey(ValueKey(maSachMoi)));
      expect(find.text('Chưa có ghi chú'), findsOneWidget);
      await nhan(boKiemTra, find.text('Xóa sách').last);
      await nhan(boKiemTra, find.text('Hủy'));
      expect(danhSachSach.length, 4);
      await nhan(boKiemTra, find.text('Xóa sách').last);
      await nhan(boKiemTra, find.text('Xóa'));
      expect(danhSachSach.any((sach) => sach.maSach == maSachMoi), isFalse);
      expect(danhSachSach.first.maSach, '1');
      while (danhSachSach.isNotEmpty) {
        await boKiemTra.drag(find.byType(ListView), const Offset(0, 2000));
        await boKiemTra.pumpAndSettle();
        await nhan(boKiemTra, find.byKey(ValueKey(danhSachSach.first.maSach)));
        await nhan(boKiemTra, find.text('Xóa sách').last);
        await nhan(boKiemTra, find.text('Xóa'));
      }
      kiemTraThongKe(0, 0, 0);
      expect(find.text('Chưa có cuốn sách nào'), findsOneWidget);
      await nhan(boKiemTra, find.text('Thêm sách'));
      expect(find.text('Tên sách'), findsOneWidget);
      expect(boKiemTra.takeException(), isNull);
    },
  );

  testWidgets('Màn hình nhỏ, chữ lớn, bàn phím và nội dung dài không tràn', (
    boKiemTra,
  ) async {
    await moUngDung(boKiemTra);
    boKiemTra.view.physicalSize = const Size(320, 568);
    boKiemTra.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(boKiemTra.platformDispatcher.clearTextScaleFactorTestValue);
    boKiemTra.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(boKiemTra.view.resetViewInsets);
    await boKiemTra.pumpAndSettle();
    await dangNhap(boKiemTra);
    boKiemTra.view.resetViewInsets();
    await boKiemTra.pumpAndSettle();
    danhSachSach.first.tenSach = List.filled(12, 'Tên sách rất dài').join(' ');
    danhSachSach.first.ghiChu = List.filled(
      20,
      'Ghi chú nhiều dòng',
    ).join('\n');
    await nhan(boKiemTra, find.byKey(const ValueKey('1')));
    await nhan(boKiemTra, find.text('Quay lại'));
    await nhan(boKiemTra, find.text('Thêm sách'));
    boKiemTra.view.viewInsets = const FakeViewPadding(bottom: 260);
    await boKiemTra.pumpAndSettle();
    await boKiemTra.ensureVisible(find.byType(TextFormField).last);
    await boKiemTra.enterText(
      find.byType(TextFormField).last,
      'Ghi chú khi mở bàn phím',
    );
    await nhan(boKiemTra, find.text('Lưu sách'));
    expect(danhSachSach.length, 3);
    expect(boKiemTra.takeException(), isNull);
  });
}
