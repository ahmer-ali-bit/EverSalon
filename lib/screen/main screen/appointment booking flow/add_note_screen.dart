import 'package:ever_salon/provider/appointment%20booking%20flow/add_note_provider.dart';
import 'package:ever_salon/screen/main%20screen/appointment%20booking%20flow/apply_coupon_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';

class AddNotesScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const AddNotesScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddNotesProvider(),
      child: _AddNotesView(bookingData: bookingData),
    );
  }
}

class _AddNotesView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _AddNotesView({required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AddNotesProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================
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
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),

                  Center(
                    child: Text(
                      context.tr('add_notes'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.1),
                ],
              ),
            ),

            // =================================================
            // BODY
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),

                    // Label
                    Text(
                      context.tr('special_requests'),
                      style: TextStyle(
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),

                    SizedBox(height: h * 0.015),

                    // Notes Text Field
                    Container(
                      width: double.infinity,
                      height: h * 0.22,
                      decoration: BoxDecoration(
color: AppColors.inputBg(context),
        borderRadius: BorderRadius.circular(w * 0.035),
                        border: Border.all(
                          color: provider.isOverLimit
                              ? AppColors.error
                              : AppColors.divider(context),
                        ),
                      ),
                      child: TextField(
                        controller: provider.notesController,
                        onChanged: provider.onNotesChanged,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: TextStyle(
                          fontSize: w * 0.038,
                          color: AppColors.textPrimary(context),
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          hintText: context.tr('notes_hint'),
                          hintStyle: TextStyle(
                            fontSize: w * 0.036,
                            color: AppColors.textSecondary(context).withValues(alpha: 0.7),
                            height: 1.4,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(w * 0.04),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.01),

                    // Character counter
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${provider.characterCount}/${AddNotesProvider.maxCharacters}',
                        style: TextStyle(
                          fontSize: w * 0.032,
color: provider.isOverLimit
                               ? AppColors.error
                               : AppColors.textSecondary(context),
                          fontWeight: provider.characterCount > 180
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // Optional tip
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(w * 0.035),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primaryPink,
                            size: w * 0.05,
                          ),
                          SizedBox(width: w * 0.025),
                          Expanded(
                            child: Text(
                              context.tr('notes_optional'),
                              style: TextStyle(
                                fontSize: w * 0.033,
                                color: AppColors.textSecondary(context),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOTTOM FULL-WIDTH CONTINUE
            // =================================================
            _buildBottomBar(context, w, h, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    double w,
    double h,
    AddNotesProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.015, w * 0.04, h * 0.02),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: CustomButton(
          text: context.tr('continue'),
          width: double.infinity,
          onTap: () {
            final updatedBooking = {
              ...bookingData,
              'notes': provider.notes.trim(),
            };

            // TODO: Navigate to Apply Coupon
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ApplyCouponScreen(bookingData: updatedBooking),
              ),
            );

            debugPrint('S36 → S37 notes: "${provider.notes}"');
          },
        ),
      ),
    );
  }
}
