import 'package:flutter/material.dart';

import '../data/du_lieu_sach.dart';
import '../models/sach.dart';
import '../widgets/the_sach.dart';

class ManHinhThemSach extends StatefulWidget {
  const ManHinhThemSach({super.key});

  @override
  State<ManHinhThemSach> createState() => _ManHinhThemSachState();
}

class _ManHinhThemSachState extends State<ManHinhThemSach> {
  final khoaBieuMau = GlobalKey<FormState>();
  final dieuKhienTenSach = TextEditingController();
  final dieuKhienTacGia = TextEditingController();
  final dieuKhienGhiChu = TextEditingController();
  String theLoai = 'Văn học';
  String tinhTrang = 'Chưa đọc';
  double danhGia = 0;

  // Kiểm tra và thêm sách mới.
  void luuSach() {
    if (!khoaBieuMau.currentState!.validate()) return;
    danhSachSach.add(
      Sach(
        maSach: taoMaSach(),
        tenSach: dieuKhienTenSach.text.trim(),
        tacGia: dieuKhienTacGia.text.trim(),
        theLoai: theLoai,
        tinhTrang: tinhTrang,
        danhGia: danhGia,
        ghiChu: dieuKhienGhiChu.text.trim(),
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    dieuKhienTenSach.dispose();
    dieuKhienTacGia.dispose();
    dieuKhienGhiChu.dispose();
    super.dispose();
  }

  Widget taoNhan(String noiDung) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      noiDung,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm sách')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: khoaBieuMau,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    taoNhan('Tên sách'),
                    TextFormField(
                      controller: dieuKhienTenSach,
                      decoration: const InputDecoration(
                        hintText: 'Ví dụ: Đắc nhân tâm',
                      ),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (giaTri) =>
                          giaTri == null || giaTri.trim().isEmpty
                          ? 'Vui lòng nhập tên sách'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    taoNhan('Tác giả'),
                    TextFormField(
                      controller: dieuKhienTacGia,
                      decoration: const InputDecoration(
                        hintText: 'Ví dụ: Dale Carnegie',
                      ),
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      validator: (giaTri) =>
                          giaTri == null || giaTri.trim().isEmpty
                          ? 'Vui lòng nhập tác giả'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    taoNhan('Thể loại'),
                    DropdownButtonFormField<String>(
                      initialValue: theLoai,
                      isExpanded: true,
                      items:
                          [
                                'Văn học',
                                'Khoa học',
                                'Công nghệ',
                                'Kỹ năng sống',
                                'Khác',
                              ]
                              .map(
                                (tenTheLoai) => DropdownMenuItem(
                                  value: tenTheLoai,
                                  child: Text(tenTheLoai),
                                ),
                              )
                              .toList(),
                      onChanged: (giaTri) {
                        if (giaTri != null) setState(() => theLoai = giaTri);
                      },
                    ),
                    const SizedBox(height: 20),
                    taoNhan('Tình trạng đọc'),
                    RadioGroup<String>(
                      groupValue: tinhTrang,
                      onChanged: (giaTri) {
                        if (giaTri != null) setState(() => tinhTrang = giaTri);
                      },
                      child: Column(
                        children: ['Chưa đọc', 'Đang đọc', 'Đã đọc']
                            .map(
                              (trangThai) => RadioListTile<String>(
                                value: trangThai,
                                title: Text(trangThai),
                                contentPadding: EdgeInsets.zero,
                                activeColor: mauChinh,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    taoNhan('Đánh giá'),
                    DanhGiaSao(
                      danhGia: danhGia,
                      khiThayDoi: (giaTri) => setState(() => danhGia = giaTri),
                    ),
                    const Text(
                      'Nhấn lại sao đang chọn để bỏ đánh giá.',
                      style: TextStyle(color: mauChuPhu, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    taoNhan('Ghi chú'),
                    TextFormField(
                      controller: dieuKhienGhiChu,
                      decoration: const InputDecoration(
                        hintText: 'Nhập ghi chú (nhiều dòng)...',
                      ),
                      minLines: 3,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: luuSach,
                      child: const Text('Lưu sách'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
