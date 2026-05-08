import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';
import 'package:aqedu/core/widgets/appBar/notification.dart';
import 'package:aqedu/core/widgets/appBar/scan.dart';
import 'package:aqedu/features/notification/screens/view_noti_student.dart';

/// AppBar component cho Home Student
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      titleSpacing: AppSpacing.lg,
      title: Text(
        'Trang chủ',
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.heroTitle.copyWith(
          fontSize: 20,
          letterSpacing: 0.2,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NotificationButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationView(),
                    ),
                  );
                },
              ),
              SizedBox(width: 4),
              QRScanButton(
                onPressed: () {
                  print("Đang mở chức năng quét QR...");
                },
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
