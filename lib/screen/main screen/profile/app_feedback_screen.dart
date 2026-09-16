import 'package:ever_salon/provider/profile/app_feedback_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../widgets/custom_button.dart';

class AppFeedbackScreen extends StatelessWidget {
  const AppFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppFeedbackProvider(),
      child: const _AppFeedbackView(),
    );
  }
}

class _AppFeedbackView extends StatefulWidget {
  const _AppFeedbackView();

  @override
  State<_AppFeedbackView> createState() => _AppFeedbackViewState();
}

class _AppFeedbackViewState extends State<_AppFeedbackView> {
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AppFeedbackProvider>();

    // Adaptive Colors
    final bg = AppColors.scaffoldBg(context);
    final textPrim = AppColors.textPrimary(context);
    final textSec = AppColors.textSecondary(context);
    final iconBg = AppColors.iconCircleBg(context);
    final inputBg = AppColors.inputBg(context);
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
                    'Send Feedback',
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
                    SizedBox(height: h * 0.04),

                    // ─── ILLUSTRATION ───
                    Image.asset(
                      'assets/images/feedback.png',
                      width: w * 0.5,
                      height: w * 0.5,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.feedback_outlined,
                        size: w * 0.3,
                        color: AppColors.primaryPink.withValues(alpha: 0.5),
                      ),
                    ),

                    SizedBox(height: h * 0.04),

                    // ─── TITLE & SUBTITLE ───
                    Text(
                      'We value your feedback!',
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: textPrim,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Text(
                      'Help us improve your EverSalon experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: w * 0.035, color: textSec),
                    ),

                    SizedBox(height: h * 0.04),

                    // ─── STAR RATING ───
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isSelected = starIndex <= provider.rating;
                        return GestureDetector(
                          onTap: () => provider.setRating(starIndex),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.015,
                            ),
                            child: AnimatedScale(
                              scale: isSelected ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isSelected
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: isSelected
                                    ? AppColors.primaryPink
                                    : textSec.withValues(alpha: 0.5),
                                size: w * 0.1,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: h * 0.04),

                    // ─── TEXT AREA ───
                    TextField(
                      controller: _feedbackController,
                      maxLines: 6,
                      maxLength: 500,
                      style: TextStyle(color: textPrim, fontSize: w * 0.038),
                      decoration: InputDecoration(
                        hintText: 'Write your feedback here...',
                        hintStyle: TextStyle(
                          color: textSec,
                          fontSize: w * 0.035,
                        ),
                        filled: true,
                        fillColor: inputBg,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(w * 0.04),
                          borderSide: BorderSide(color: divColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(w * 0.04),
                          borderSide: const BorderSide(
                            color: AppColors.primaryPink,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(w * 0.04),
                      ),
                      buildCounter:
                          (
                            context, {
                            required currentLength,
                            required isFocused,
                            maxLength,
                          }) {
                            return Text(
                              '$currentLength/$maxLength',
                              style: TextStyle(
                                color: textSec,
                                fontSize: w * 0.03,
                              ),
                            );
                          },
                    ),

                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),

            // ─── SUBMIT BUTTON ───
            Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: CustomButton(
                text: 'Submit Feedback',
                isLoading: provider.isLoading,
                onTap: () async {
                  if (provider.rating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a rating first!'),
                      ),
                    );
                    return;
                  }

                  final success = await provider.submitFeedback(
                    _feedbackController.text.trim(),
                  );

                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your feedback!'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
