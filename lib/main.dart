import 'package:flutter/material.dart';

import 'screens/man_hinh_dang_nhap.dart';
import 'widgets/the_sach.dart';

void main() {
  runApp(const UngDungThuVien());
}

class UngDungThuVien extends StatelessWidget {
  const UngDungThuVien({super.key});

  @override
  Widget build(BuildContext context) {
    final vienNhap = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: mauVien),
    );
    return MaterialApp(
      title: 'Thư viện sách cá nhân',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: mauChinh,
          primary: mauChinh,
          error: mauLoi,
          surface: mauTrang,
        ),
        scaffoldBackgroundColor: mauNen,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: mauChu, fontSize: 16),
          bodyMedium: TextStyle(color: mauChu, fontSize: 14),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: mauChinh,
          foregroundColor: mauTrang,
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        cardTheme: CardThemeData(
          color: mauTrang,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: mauVien),
          ),
        ),
        inputDecorationTheme: InputDecorationThemeData(
          filled: true,
          fillColor: mauTrang,
          contentPadding: const EdgeInsets.all(16),
          border: vienNhap,
          enabledBorder: vienNhap,
          focusedBorder: vienNhap.copyWith(
            borderSide: const BorderSide(color: mauChinh, width: 2),
          ),
          errorMaxLines: 3,
          hintStyle: const TextStyle(color: mauChuPhu, fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: mauChinh,
            foregroundColor: mauTrang,
            elevation: 0,
            minimumSize: const Size(double.infinity, 52),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: mauTrang,
            foregroundColor: mauChinh,
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: mauChinh),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const ManHinhDangNhap(),
    );
  }
}
