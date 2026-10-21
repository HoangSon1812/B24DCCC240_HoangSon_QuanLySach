import 'package:flutter/material.dart';

import '../data/du_lieu_sach.dart';
import '../models/sach.dart';
import '../widgets/the_sach.dart';

class ManHinhChiTietSach extends StatefulWidget {
  final Sach sach;

  const ManHinhChiTietSach({super.key, required this.sach});

  @override
  State<ManHinhChiTietSach> createState() => _ManHinhChiTietSachState();
}

class _ManHinhChiTietSachState extends State<ManHinhChiTietSach> {
  void danhDauDaDoc() {
    setState(() => widget.sach.tinhTrang = 'Đã đọc');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã đánh dấu sách là đã đọc')));
  }

  // Xác nhận và xóa theo mã sách.
  Future<void> xoaSach() async {
    final dongY = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa sách'),
        content: const Text('Bạn có chắc muốn xóa cuốn sách này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: mauLoi),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (!mounted || dongY != true) return;
    danhSachSach.removeWhere((sach) => sach.maSach == widget.sach.maSach);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final sach = widget.sach;
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sách')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sach.tenSach,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            sach.tacGia,
                            style: const TextStyle(
                              color: mauChuPhu,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Thể loại: ${sach.theLoai}',
                            style: const TextStyle(color: mauChuPhu),
                          ),
                          const SizedBox(height: 20),
                          NhanTinhTrang(tinhTrang: sach.tinhTrang),
                          const SizedBox(height: 24),
                          const Text(
                            'Đánh giá',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DanhGiaSao(
                            danhGia: sach.danhGia,
                            khiThayDoi: (giaTri) =>
                                setState(() => sach.danhGia = giaTri),
                          ),
                          const Text(
                            'Nhấn lại sao đang chọn để bỏ đánh giá.',
                            style: TextStyle(color: mauChuPhu, fontSize: 12),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Divider(height: 1, color: mauVien),
                          ),
                          const Text(
                            'Ghi chú',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            sach.ghiChu.isEmpty
                                ? 'Chưa có ghi chú'
                                : sach.ghiChu,
                            style: const TextStyle(
                              color: mauChuPhu,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: sach.tinhTrang == 'Đã đọc' ? null : danhDauDaDoc,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Đánh dấu đã đọc'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Quay lại'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: xoaSach,
                    style: ElevatedButton.styleFrom(backgroundColor: mauLoi),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Xóa sách'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
