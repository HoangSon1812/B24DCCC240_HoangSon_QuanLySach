import 'package:flutter/material.dart';

import '../data/du_lieu_sach.dart';
import '../models/sach.dart';
import '../widgets/the_sach.dart';
import 'man_hinh_chi_tiet_sach.dart';
import 'man_hinh_them_sach.dart';

class ManHinhDanhSach extends StatefulWidget {
  const ManHinhDanhSach({super.key});

  @override
  State<ManHinhDanhSach> createState() => _ManHinhDanhSachState();
}

class _ManHinhDanhSachState extends State<ManHinhDanhSach> {
  Future<void> themSach() async {
    final daLuu = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (context) => const ManHinhThemSach()),
    );
    if (!mounted) return;
    if (daLuu == true) setState(() {});
  }

  Future<void> xemChiTiet(Sach sach) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => ManHinhChiTietSach(sach: sach),
      ),
    );
    if (!mounted) return;
    // Làm mới cả khi dùng nút Back của Android.
    setState(() {});
  }

  Widget taoChiSo(String nhan, int giaTri) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$giaTri',
            style: const TextStyle(
              color: mauTrang,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nhan,
            textAlign: TextAlign.center,
            style: const TextStyle(color: mauTrang, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tongSoSach = danhSachSach.length;
    final soSachDaDoc = danhSachSach
        .where((sach) => sach.tinhTrang == 'Đã đọc')
        .length;
    final soSachChuaDocXong = danhSachSach
        .where(
          (sach) =>
              sach.tinhTrang == 'Chưa đọc' || sach.tinhTrang == 'Đang đọc',
        )
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Thư viện của tôi')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: danhSachSach.isEmpty
                        ? 2
                        : danhSachSach.length + 1,
                    itemBuilder: (context, viTri) {
                      if (viTri == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: mauChinh,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Thống kê',
                                    style: TextStyle(
                                      color: mauTrang,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      taoChiSo('Tổng số sách', tongSoSach),
                                      taoChiSo('Đã đọc', soSachDaDoc),
                                      taoChiSo(
                                        'Chưa đọc xong',
                                        soSachChuaDocXong,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 26),
                            const Text(
                              'Danh sách sách',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }
                      if (danhSachSach.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Column(
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 54,
                                color: mauChuPhu,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Chưa có cuốn sách nào',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: mauChuPhu,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final sach = danhSachSach[viTri - 1];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TheSach(
                          key: ValueKey(sach.maSach),
                          sach: sach,
                          khiNhan: () => xemChiTiet(sach),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: ElevatedButton.icon(
                    onPressed: themSach,
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm sách'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
