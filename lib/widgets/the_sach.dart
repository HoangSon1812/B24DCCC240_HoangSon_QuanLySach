import 'package:flutter/material.dart';

import '../models/sach.dart';

const Color mauChinh = Color(0xFF00796B);
const Color mauNen = Color(0xFFF5F7F8);
const Color mauTrang = Colors.white;
const Color mauChu = Color(0xFF222222);
const Color mauChuPhu = Color(0xFF757575);
const Color mauVien = Color(0xFFD5DADD);
const Color mauLoi = Color(0xFFD32F2F);
const Color mauSao = Color(0xFFFFA000);

class TheSach extends StatelessWidget {
  final Sach sach;
  final VoidCallback khiNhan;

  const TheSach({super.key, required this.sach, required this.khiNhan});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: khiNhan,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sach.tenSach,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(sach.tacGia, style: const TextStyle(color: mauChuPhu)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sach.theLoai,
                      style: const TextStyle(color: mauChinh, fontSize: 12),
                    ),
                  ),
                  NhanTinhTrang(tinhTrang: sach.tinhTrang),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: DanhGiaSao(danhGia: sach.danhGia),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NhanTinhTrang extends StatelessWidget {
  final String tinhTrang;

  const NhanTinhTrang({super.key, required this.tinhTrang});

  @override
  Widget build(BuildContext context) {
    Color mauNhan = mauChuPhu;
    if (tinhTrang == 'Đang đọc') mauNhan = const Color(0xFFB86B00);
    if (tinhTrang == 'Đã đọc') mauNhan = const Color(0xFF2E7D32);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: mauNhan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(tinhTrang, style: TextStyle(color: mauNhan, fontSize: 12)),
    );
  }
}

class DanhGiaSao extends StatelessWidget {
  final double danhGia;
  final ValueChanged<double>? khiThayDoi;

  const DanhGiaSao({super.key, required this.danhGia, this.khiThayDoi});

  @override
  Widget build(BuildContext context) {
    final hangSao = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (viTri) {
        final soSao = viTri + 1;
        final bieuTuong = Icon(
          soSao <= danhGia ? Icons.star_rounded : Icons.star_border_rounded,
          color: mauSao,
          size: khiThayDoi == null ? 22 : 30,
        );
        if (khiThayDoi == null) return bieuTuong;
        return IconButton(
          tooltip: danhGia == soSao ? 'Bỏ đánh giá' : '$soSao sao',
          constraints: const BoxConstraints(minWidth: 40, minHeight: 48),
          padding: const EdgeInsets.all(4),
          onPressed: () => khiThayDoi!(danhGia == soSao ? 0 : soSao.toDouble()),
          icon: bieuTuong,
        );
      }),
    );
    if (khiThayDoi == null) {
      return Semantics(label: '${danhGia.toInt()} trên 5 sao', child: hangSao);
    }
    return Wrap(
      spacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        hangSao,
        Text(
          '${danhGia.toInt()} / 5 sao',
          style: const TextStyle(color: mauChuPhu),
        ),
      ],
    );
  }
}
