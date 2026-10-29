import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/appointment%20booking%20flow/add_note_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/appointment%20booking%20flow/apply_coupon_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    final scaffoldBg = AppColors.scaffoldBg(context);
    final textPrimary = AppColors.textPrimary(context);
    final textSecondary = AppColors.textSecondary(context);
    final inputBg = AppColors.inputBg(context);
    final primaryPink = AppColors.primaryPink;
    final borderColor = textPrimary.withValues(alpha: 0.12);

    return Scaffold(
      backgroundColor: scaffoldBg,
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
                        color: inputBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: textPrimary,
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
                        color: textPrimary,
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
                      context.tr('Any special requests'),
                      style: TextStyle(
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),

                    SizedBox(height: h * 0.015),

                    // Notes Text Area
                    Container(
                      width: double.infinity,
                      height: h * 0.22,
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(w * 0.035),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: provider.notesController,
                        onChanged: provider.onNotesChanged,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: TextStyle(
                          fontSize: w * 0.038,
                          color: textPrimary,
                          height: 1.4,
                        ),
                        decoration: InputDecoration(
                          hintText: context.tr('notes_hint'),
                          // e.g. "e.g. I have sensitive skin, prefer less heat on hair, etc."
                          hintStyle: TextStyle(
                            fontSize: w * 0.036,
                            color: textSecondary.withValues(alpha: 0.75),
                            height: 1.4,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(w * 0.04),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.01),

                    // Character counter 0/200
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${provider.characterCount}/${AddNotesProvider.maxCharacters}',
                        style: TextStyle(
                          fontSize: w * 0.032,
                          fontWeight: provider.isNearLimit
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: provider.isNearLimit
                              ? primaryPink
                              : textSecondary,
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // Optional: chhota flow badge (debug / clarity)
                    // Service vs Package — user ko dikhana zaroori nahi, lekin data safe hai
                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOTTOM CONTINUE (notes optional — hamesha enabled)
            // =================================================
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.015,
                w * 0.04,
                h * 0.02,
              ),
              decoration: BoxDecoration(
                color: scaffoldBg,
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
                  text: context.tr('Continue'),
                  width: double.infinity,
                  onTap: () {
                    // service + package dono flows ka pura map aage
                    final updatedBooking = {
                      ...bookingData,
                      'notes': provider.notes.trim(),
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ApplyCouponScreen(bookingData: updatedBooking),
                      ),
                    );

                    debugPrint(
                      'S36 → S37 | flowType=${updatedBooking['flowType']} | notes="${provider.notes}"',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
