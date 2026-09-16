import 'package:ever_salon/provider/profile/share_app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShareAppProvider(),
      child: const _ShareAppView(),
    );
  }
}

class _ShareAppView extends StatelessWidget {
  const _ShareAppView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<ShareAppProvider>();

    // Adaptive Colors
    final bg = AppColors.scaffoldBg(context);
    final textPrim = AppColors.textPrimary(context);
    final textSec = AppColors.textSecondary(context);
    final iconBg = AppColors.iconCircleBg(context);
    final divColor = AppColors.divider(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── STRICT HEADER FORMAT ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.015,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: w * 0.1,
                      height: w * 0.1,
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: textPrim,
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Text(
                    'Share EverSalon',
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: textPrim,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // ─── BODY ───
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.03),

                    // ─── ILLUSTRATION ───
                    Image.asset(
                      'assets/images/share.png',
                      width: w * 0.65,
                      height: w * 0.48,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.group_add_outlined,
                        size: w * 0.35,
                        color: AppColors.primaryPink.withValues(alpha: 0.3),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // ─── TITLE & SUBTITLE ───
                    Text(
                      'Share the beauty!',
                      style: TextStyle(
                        fontSize: w * 0.055,
                        fontWeight: FontWeight.bold,
                        color: textPrim,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Text(
                        'Invite your friends and earn rewards together.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: w * 0.035,
                          color: textSec,
                          height: 1.4,
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.05),

                    // ─── SHARE BUTTONS ROW ───
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shareIconBtn(
                          w: w,
                          h: h,
                          context: context,
                          label: 'WhatsApp',
                          assetPath: 'assets/images/whatsapp.png',
                          onTap: () =>
                              provider.shareToPlatform('whatsapp', context),
                        ),
                        _shareIconBtn(
                          w: w,
                          h: h,
                          context: context,
                          label: 'Facebook',
                          assetPath: 'assets/images/facebook.png',
                          onTap: () =>
                              provider.shareToPlatform('facebook', context),
                        ),
                        _shareIconBtn(
                          w: w,
                          h: h,
                          context: context,
                          label: 'Instagram',
                          assetPath: 'assets/images/instagram.png',
                          onTap: () =>
                              provider.shareToPlatform('instagram', context),
                        ),
                        _shareIconBtn(
                          w: w,
                          h: h,
                          context: context,
                          label: 'More',
                          isNativeIcon: true,
                          iconData: Icons.more_horiz,
                          onTap: () =>
                              _showMoreShareSheet(context, provider, w, h),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.05),

                    // ─── COPY LINK BOX ───
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.04),
                        border: Border.all(color: divColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link_rounded,
                            color: AppColors.primaryPink,
                            size: w * 0.05,
                          ),
                          SizedBox(width: w * 0.025),
                          Expanded(
                            child: Text(
                              provider.shareUrl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textSec,
                                fontSize: w * 0.035,
                              ),
                            ),
                          ),
                          SizedBox(width: w * 0.02),
                          GestureDetector(
                            onTap: () => provider.copyToClipboard(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03,
                                vertical: h * 0.008,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPink.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(w * 0.02),
                              ),
                              child: Text(
                                'Copy',
                                style: TextStyle(
                                  color: AppColors.primaryPink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.032,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Custom Widget for Share Buttons
  Widget _shareIconBtn({
    required double w,
    required double h,
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    String? assetPath,
    bool isNativeIcon = false,
    IconData? iconData,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w * 0.15,
            height: w * 0.15,
            padding: EdgeInsets.all(w * 0.035),
            decoration: BoxDecoration(
              color: AppColors.cardBg(context),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.divider(context).withValues(alpha: 0.5),
              ),
              boxShadow: [
                if (!AppColors.isDark(context))
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: isNativeIcon
                ? Icon(
                    iconData,
                    size: w * 0.07,
                    color: AppColors.textPrimary(context),
                  )
                : Image.asset(
                    assetPath!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.link,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
          ),
          SizedBox(height: h * 0.01),
          Text(
            label,
            style: TextStyle(
              fontSize: w * 0.032,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  // ─── MORE OPTIONS BOTTOM SHEET ───
  void _showMoreShareSheet(
    BuildContext context,
    ShareAppProvider provider,
    double w,
    double h,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sheetBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.06)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(w * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sheet Handle Line
              Container(
                width: w * 0.12,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: h * 0.02),

              Text(
                'Share via',
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              SizedBox(height: h * 0.025),

              // Options
              _sheetTile(
                w: w,
                icon: Icons.copy_rounded,
                title: 'Copy Link',
                color: AppColors.primaryPink,
                onTap: () {
                  Navigator.pop(ctx);
                  provider.copyToClipboard(context);
                },
              ),
              _sheetTile(
                w: w,
                icon: Icons.message_outlined,
                title: 'Message / SMS',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(ctx);
                  provider.shareToPlatform('sms', context);
                },
              ),
              _sheetTile(
                w: w,
                icon: Icons.email_outlined,
                title: 'Email',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(ctx);
                  provider.shareToPlatform('email', context);
                },
              ),
              _sheetTile(
                w: w,
                icon: Icons.share_rounded,
                title: 'System Share Sheet',
                color: AppColors.primaryPurple,
                onTap: () {
                  Navigator.pop(ctx);
                  provider.openSystemShare();
                },
              ),

              SizedBox(height: h * 0.02),
            ],
          ),
        );
      },
    );
  }

  Widget _sheetTile({
    required double w,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(w * 0.025),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: w * 0.055),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: w * 0.038, fontWeight: FontWeight.w600),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: w * 0.035,
        color: Colors.grey,
      ),
    );
  }
}
