import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';

/// Info Banner component — thông báo quan trọng
class HomeInfoBanner extends StatelessWidget {
  const HomeInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(AppOpacity.bg12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              size: 24,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: AppSpacing.lg),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Không có thông báo khẩn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.actionTileTitle,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Bạn có thể kiểm tra lịch học và học phí ngay bên dưới.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.actionTileSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
