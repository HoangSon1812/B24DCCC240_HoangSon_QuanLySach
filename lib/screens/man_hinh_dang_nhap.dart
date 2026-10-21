import 'package:flutter/material.dart';

import '../widgets/the_sach.dart';
import 'man_hinh_danh_sach.dart';

class ManHinhDangNhap extends StatefulWidget {
  const ManHinhDangNhap({super.key});

  @override
  State<ManHinhDangNhap> createState() => _ManHinhDangNhapState();
}

class _ManHinhDangNhapState extends State<ManHinhDangNhap> {
  final dieuKhienTenDangNhap = TextEditingController();
  final dieuKhienMatKhau = TextEditingController();
  String thongBaoLoi = '';

  // Kiểm tra tài khoản mẫu.
  void dangNhap() {
    final tenDangNhap = dieuKhienTenDangNhap.text.trim();
    final matKhau = dieuKhienMatKhau.text;
    if (tenDangNhap.isEmpty || matKhau.trim().isEmpty) {
      setState(
        () => thongBaoLoi = 'Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu',
      );
      return;
    }
    if (tenDangNhap != 'admin' || matKhau != '123456') {
      setState(() => thongBaoLoi = 'Sai tên đăng nhập hoặc mật khẩu');
      return;
    }
    FocusScope.of(context).unfocus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const ManHinhDanhSach()),
    );
  }

  @override
  void dispose() {
    dieuKhienTenDangNhap.dispose();
    dieuKhienMatKhau.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, kichThuoc) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: kichThuoc.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 36,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: CircleAvatar(
                            radius: 43,
                            backgroundColor: mauChinh,
                            child: Text(
                              'B',
                              style: TextStyle(
                                color: mauTrang,
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Thư viện sách',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Đăng nhập để tiếp tục',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: mauChuPhu, fontSize: 16),
                        ),
                        const SizedBox(height: 34),
                        const Text(
                          'Tên đăng nhập',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: dieuKhienTenDangNhap,
                          decoration: const InputDecoration(
                            hintText: 'Nhập tên đăng nhập',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Mật khẩu',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: dieuKhienMatKhau,
                          decoration: const InputDecoration(
                            hintText: 'Nhập mật khẩu',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => dangNhap(),
                        ),
                        if (thongBaoLoi.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            thongBaoLoi,
                            style: const TextStyle(color: mauLoi),
                          ),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: dangNhap,
                          child: const Text('Đăng nhập'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tài khoản mẫu: admin / 123456',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: mauChuPhu, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
