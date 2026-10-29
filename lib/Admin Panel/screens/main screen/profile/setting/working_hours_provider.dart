import 'package:ever_salon/Admin%20Panel/providers/profile/setting/working_hours_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminWorkingHoursScreen extends StatelessWidget {
  const AdminWorkingHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminWorkingHoursProvider(),
      child: const _AdminWorkingHoursContent(),
    );
  }
}

class _AdminWorkingHoursContent extends StatelessWidget {
  const _AdminWorkingHoursContent();

  static const List<String> _timeOptions = [
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
    '07:30 PM',
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
    '09:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminWorkingHoursProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                  Expanded(
                    child: Text(
                      context.tr('Working Hours'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: provider.applyMondayToWeekdays,
                    child: Text(
                      context.tr('Copy Mon'),
                      style: TextStyle(
                        fontSize: w * 0.032,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Text(
                context.tr(
                  'These hours control customer booking slots. Multi-hour services auto-block following slots.',
                ),
                style: TextStyle(
                  fontSize: w * 0.03,
                  color: AppColors.textSecondary(context),
                  height: 1.35,
                ),
              ),
            ),
            SizedBox(height: h * 0.015),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        w * 0.04,
                        0,
                        w * 0.04,
                        h * 0.02,
                      ),
                      itemCount: provider.days.length,
                      separatorBuilder: (_, _) => SizedBox(height: h * 0.015),
                      itemBuilder: (context, index) {
                        return _buildDayCard(context, w, h, provider, index);
                      },
                    ),
            ),

            // SAVE
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, h * 0.02),
              child: SizedBox(
                width: double.infinity,
                height: h * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.08),
                    ),
                  ),
                  onPressed: provider.isSaving
                      ? null
                      : () async {
                          final ok = await provider.saveHours();
                          if (ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tr('Working hours saved'),
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                  child: provider.isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          context.tr('Save Hours'),
                          style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(
    BuildContext context,
    double w,
    double h,
    AdminWorkingHoursProvider provider,
    int index,
  ) {
    final day = provider.days[index];
    final bool isOff = day['isOff'] == true;
    final bool hasBreak = day['hasBreak'] == true;

    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day name + Off toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  day['name'].toString(),
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
              Text(
                context.tr(isOff ? 'Off' : 'Open'),
                style: TextStyle(
                  fontSize: w * 0.03,
                  color: isOff ? AppColors.error : AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: !isOff,
                activeThumbColor: AppColors.primaryPink,
                onChanged: (v) => provider.toggleOff(index, !v),
              ),
            ],
          ),

          if (!isOff) ...[
            SizedBox(height: h * 0.01),
            Row(
              children: [
                Expanded(
                  child: _timeDropdown(
                    context,
                    w,
                    context.tr('Open'),
                    day['open'].toString(),
                    (t) => provider.setOpen(index, t),
                  ),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: _timeDropdown(
                    context,
                    w,
                    context.tr('Close'),
                    day['close'].toString(),
                    (t) => provider.setClose(index, t),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.012),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr('Lunch / Break'),
                    style: TextStyle(
                      fontSize: w * 0.033,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
                Switch(
                  value: hasBreak,
                  activeThumbColor: AppColors.primaryPink,
                  onChanged: (v) => provider.toggleBreak(index, v),
                ),
              ],
            ),
            if (hasBreak) ...[
              SizedBox(height: h * 0.008),
              Row(
                children: [
                  Expanded(
                    child: _timeDropdown(
                      context,
                      w,
                      context.tr('Break start'),
                      day['breakStart'].toString().isEmpty
                          ? '02:00 PM'
                          : day['breakStart'].toString(),
                      (t) => provider.setBreakStart(index, t),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: _timeDropdown(
                      context,
                      w,
                      context.tr('Break end'),
                      day['breakEnd'].toString().isEmpty
                          ? '03:00 PM'
                          : day['breakEnd'].toString(),
                      (t) => provider.setBreakEnd(index, t),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _timeDropdown(
    BuildContext context,
    double w,
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    String safeValue = value;
    if (!_timeOptions.contains(safeValue)) {
      safeValue = _timeOptions.contains('10:00 AM')
          ? '10:00 AM'
          : _timeOptions.first;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: w * 0.028, color: AppColors.textGrey),
        ),
        SizedBox(height: w * 0.015),
        Container(
          padding: EdgeInsets.symmetric(horizontal: w * 0.025),
          decoration: BoxDecoration(
            color: AppColors.inputBg(context),
            borderRadius: BorderRadius.circular(w * 0.025),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safeValue,
              isExpanded: true,
              dropdownColor: AppColors.cardBg(context),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary(context),
                size: w * 0.05,
              ),
              style: TextStyle(
                fontSize: w * 0.032,
                color: AppColors.textPrimary(context),
                fontWeight: FontWeight.w600,
              ),
              items: _timeOptions
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
