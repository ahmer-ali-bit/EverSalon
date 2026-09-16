import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareAppProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  final String shareText =
      "Hey! Check out EverSalon, the ultimate beauty companion. Book your favorite salon services easily. Download now: https://eversalon.com/app";
  final String shareUrl = "https://eversalon.com/app";

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Copy Link to Clipboard
  Future<void> copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: shareUrl));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Direct Share to Social Apps
  Future<void> shareToPlatform(String platform, BuildContext context) async {
    isLoading = true;
    _safeNotify();

    try {
      Uri? uri;

      if (platform == 'whatsapp') {
        uri = Uri.parse(
          "whatsapp://send?text=${Uri.encodeComponent(shareText)}",
        );
      } else if (platform == 'facebook') {
        uri = Uri.parse(
          "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(shareUrl)}",
        );
      } else if (platform == 'instagram') {
        uri = Uri.parse("instagram://app");
      } else if (platform == 'sms') {
        uri = Uri.parse("sms:?body=${Uri.encodeComponent(shareText)}");
      } else if (platform == 'email') {
        uri = Uri.parse(
          "mailto:?subject=EverSalon App&body=${Uri.encodeComponent(shareText)}",
        );
      }

      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: Copy link if app not found
        await copyToClipboard(context);
      }
    } catch (e) {
      debugPrint('Share platform error: $e');
      await copyToClipboard(context);
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }

  /// System Share Sheet
  Future<void> openSystemShare() async {
    try {
      await Share.share(shareText, subject: 'Invite to EverSalon');
    } catch (e) {
      debugPrint('System share error: $e');
    }
  }
}
