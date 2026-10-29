import 'package:ever_salon/Admin%20Panel/providers/manage%20booking/manual_booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_textfield.dart';

class AdminManualBookingScreen extends StatelessWidget {
  const AdminManualBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminManualBookingProvider()..fetchRequiredData(),
      child: const _AdminManualBookingContent(),
    );
  }
}

class _AdminManualBookingContent extends StatelessWidget {
  const _AdminManualBookingContent();

  // ✅ Helper to format any price safely to integer string
  String _formatPrice(dynamic val) {
    final p = AdminManualBookingProvider.parsePrice(val);
    return p.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminManualBookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
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
                  SizedBox(width: w * 0.04),
                  Text(
                    context.tr('Walk-in New Booking'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. CUSTOMER
                          _buildSectionTitle(
                            context,
                            '1. Select Customer / Register Walk-In',
                            w,
                          ),
                          _buildCustomerSelection(context, provider, w, h),
                          SizedBox(height: h * 0.025),

                          // 2. SERVICES OR PACKAGES (MODE TOGGLE)
                          _buildSectionTitle(
                            context,
                            '2. Choose Services or Package',
                            w,
                          ),
                          _buildModeToggle(context, provider, w, h),
                          SizedBox(height: h * 0.015),

                          if (provider.selectionMode == 'services')
                            _buildServicesSection(context, provider, w, h)
                          else
                            _buildPackagesSection(context, provider, w, h),

                          SizedBox(height: h * 0.025),

                          // 3. STAFF
                          _buildSectionTitle(
                            context,
                            '3. Assign Stylist Staff',
                            w,
                          ),
                          _buildStaffSelector(context, provider, w, h),
                          SizedBox(height: h * 0.025),

                          // 4. SCHEDULE
                          _buildSectionTitle(
                            context,
                            '4. Scheduling Parameters',
                            w,
                          ),
                          _buildSchedulingPanel(context, provider, w, h),
                          SizedBox(height: h * 0.025),

                          // 5. PAYMENT
                          _buildSectionTitle(
                            context,
                            '5. Register Invoicing & Pay Method',
                            w,
                          ),
                          _buildPaymentMethodSelector(context, provider, w, h),
                          SizedBox(height: h * 0.03),

                          // 6. INVOICE SUMMARY
                          _buildBookingTotalInvoiceCard(
                            context,
                            provider,
                            w,
                            h,
                          ),
                          SizedBox(height: h * 0.03),

                          // CONFIRM BUTTON
                          CustomButton(
                            text: context.tr('Create Instant Walk-In Booking'),
                            isLoading: provider.isCreatingBooking,
                            isEnabled: provider.canSubmit,
                            onTap: () async {
                              final createdBooking = await provider
                                  .submitManualBooking();
                              if (createdBooking != null && context.mounted) {
                                Navigator.pop(context, createdBooking);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${context.tr("Booking Created successfully")}! ID: ${createdBooking["id"]}',
                                    ),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: h * 0.05),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.025, left: 4),
      child: Text(
        context.tr(title),
        style: TextStyle(
          fontSize: w * 0.038,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }

  Widget _buildModeToggle(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    return Container(
      padding: EdgeInsets.all(w * 0.01),
      decoration: BoxDecoration(
        color: AppColors.inputBg(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => provider.switchSelectionMode('services'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: h * 0.014),
                decoration: BoxDecoration(
                  color: provider.selectionMode == 'services'
                      ? AppColors.primaryPink
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.spa_outlined,
                      color: provider.selectionMode == 'services'
                          ? Colors.white
                          : AppColors.textGrey,
                      size: w * 0.045,
                    ),
                    SizedBox(width: w * 0.02),
                    Text(
                      context.tr('Individual Services'),
                      style: TextStyle(
                        color: provider.selectionMode == 'services'
                            ? Colors.white
                            : AppColors.textSecondary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.033,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => provider.switchSelectionMode('package'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: h * 0.014),
                decoration: BoxDecoration(
                  color: provider.selectionMode == 'package'
                      ? AppColors.primaryPink
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.card_giftcard_outlined,
                      color: provider.selectionMode == 'package'
                          ? Colors.white
                          : AppColors.textGrey,
                      size: w * 0.045,
                    ),
                    SizedBox(width: w * 0.02),
                    Text(
                      context.tr('Package Combo'),
                      style: TextStyle(
                        color: provider.selectionMode == 'package'
                            ? Colors.white
                            : AppColors.textSecondary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.033,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.selectedServices.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.all(w * 0.03),
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryPink.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.primaryPink,
                      size: 16,
                    ),
                    SizedBox(width: w * 0.02),
                    Text(
                      '${context.tr("Selected")} (${provider.selectedServices.length})',
                      style: const TextStyle(
                        color: AppColors.primaryPink,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.01),
                ...provider.selectedServices.map(
                  (service) => _buildSelectedServiceRow(
                    context,
                    provider,
                    service,
                    w,
                    h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.015),
        ],

        GestureDetector(
          onTap: () => _openAddCustomServiceSheet(context, provider, w, h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: h * 0.014),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryPurple.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primaryPurple,
                  size: 18,
                ),
                SizedBox(width: w * 0.02),
                Text(
                  context.tr('Add Custom Service'),
                  style: const TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: h * 0.015),

        Container(
          padding: EdgeInsets.all(w * 0.03),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: w * 0.02, bottom: h * 0.005),
                child: Text(
                  context.tr('Service Catalog'),
                  style: TextStyle(
                    fontSize: w * 0.032,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
              ...provider.servicesList.map((service) {
                final isSelected = provider.selectedServices.any(
                  (element) =>
                      element['id']?.toString() == service['id']?.toString(),
                );
                return CheckboxListTile(
                  activeColor: AppColors.primaryPink,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  value: isSelected,
                  onChanged: (_) => provider.toggleServiceSelection(service),
                  title: Text(
                    service['name'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.033,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  subtitle: Text(
                    '${service["duration"]} · Rs. ${_formatPrice(service["price"])}',
                    style: TextStyle(
                      fontSize: w * 0.028,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedServiceRow(
    BuildContext context,
    AdminManualBookingProvider provider,
    Map<String, dynamic> service,
    double w,
    double h,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.006),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        service['name'] ?? '',
                        style: TextStyle(
                          fontSize: w * 0.032,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (service['isCustom'] == true) ...[
                      SizedBox(width: w * 0.015),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CUSTOM',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  service['duration']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: w * 0.026,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _openEditPriceSheet(context, provider, service, w, h),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.025,
                vertical: h * 0.006,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryPink,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Text(
                    'Rs. ${_formatPrice(service['price'])}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.03,
                    ),
                  ),
                  SizedBox(width: w * 0.01),
                  const Icon(Icons.edit, color: Colors.white, size: 12),
                ],
              ),
            ),
          ),
          SizedBox(width: w * 0.02),
          GestureDetector(
            onTap: () =>
                provider.removeService(service['id']?.toString() ?? ''),
            child: const Icon(Icons.close, color: AppColors.error, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesSection(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    if (provider.packagesList.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(w * 0.06),
          child: Text(
            context.tr('No active packages found.'),
            style: TextStyle(color: AppColors.textGrey, fontSize: w * 0.035),
          ),
        ),
      );
    }

    return Column(
      children: provider.packagesList.map((pkg) {
        final isSelected =
            provider.selectedPackage?['id']?.toString() ==
            pkg['id']?.toString();
        final rawIncludes = pkg['includes'] ?? pkg['services'] ?? [];
        final List<dynamic> includes = rawIncludes is List ? rawIncludes : [];

        return GestureDetector(
          onTap: () => provider.selectPackage(isSelected ? null : pkg),
          child: Container(
            margin: EdgeInsets.only(bottom: h * 0.012),
            padding: EdgeInsets.all(w * 0.035),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryPink.withValues(alpha: 0.08)
                  : AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryPink
                    : AppColors.divider(context),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(w * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: AppColors.primaryPink,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pkg['name']?.toString() ?? '',
                            style: TextStyle(
                              fontSize: w * 0.036,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          Text(
                            pkg['duration']?.toString() ?? '',
                            style: TextStyle(
                              fontSize: w * 0.028,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. ${_formatPrice(pkg["price"])}',
                          style: const TextStyle(
                            color: AppColors.primaryPink,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPink,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'SELECTED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (includes.isNotEmpty) ...[
                  SizedBox(height: h * 0.01),
                  Wrap(
                    spacing: w * 0.015,
                    runSpacing: 4,
                    children: includes.map<Widget>((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg(context),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.toString(),
                          style: TextStyle(
                            fontSize: w * 0.025,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomerSelection(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    return Container(
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Map<String, dynamic>>(
                      isExpanded: true,
                      hint: Text(
                        context.tr('Select Existing Client'),
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: w * 0.033,
                        ),
                      ),
                      value: provider.selectedCustomer,
                      items: provider.customersList.map((cust) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: cust,
                          child: Text(
                            '${cust["name"]} (${cust["phone"]})',
                            style: TextStyle(
                              color: AppColors.textPrimary(context),
                              fontSize: w * 0.033,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) provider.selectCustomer(val);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: w * 0.03),
              GestureDetector(
                onTap: () =>
                    _openAddWalkInCustomerSheet(context, provider, w, h),
                child: Container(
                  padding: EdgeInsets.all(w * 0.03),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
          if (provider.selectedCustomer != null) ...[
            SizedBox(height: h * 0.015),
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 16,
                ),
                SizedBox(width: w * 0.02),
                Expanded(
                  child: Text(
                    '${context.tr("Linked Client")}: ${provider.selectedCustomer!["name"]}',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStaffSelector(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    return SizedBox(
      height: h * 0.09,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: provider.staffList.length,
        itemBuilder: (context, index) {
          final staff = provider.staffList[index];
          final isSelected =
              provider.selectedStaff?['id']?.toString() ==
              staff['id']?.toString();

          return GestureDetector(
            onTap: () => provider.selectStaff(staff),
            child: Container(
              margin: EdgeInsets.only(right: w * 0.03),
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: w * 0.02,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryPink.withValues(alpha: 0.1)
                    : AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryPink
                      : AppColors.divider(context),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: w * 0.045,
                    backgroundColor: AppColors.inputBg(context),
                    child: Icon(
                      Icons.person,
                      color: AppColors.textGrey,
                      size: w * 0.04,
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff['name'] ?? '',
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.032,
                        ),
                      ),
                      Text(
                        staff['role'] ?? '',
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: w * 0.025,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSchedulingPanel(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  provider.selectedDate == null
                      ? context.tr('Choose Appointment Date')
                      : '${context.tr("Date")}: ${provider.selectedDate!.day}-${provider.selectedDate!.month}-${provider.selectedDate!.year}',
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.033,
                  ),
                ),
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primaryPink,
                ),
                label: Text(
                  context.tr('Calendar'),
                  style: const TextStyle(
                    color: AppColors.primaryPink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  final chosen = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primaryPink,
                            onPrimary: Colors.white,
                            onSurface: AppColors.primaryPurple,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (chosen != null) provider.selectDate(chosen);
                },
              ),
            ],
          ),
          if (provider.selectedDate != null &&
              provider.selectedStaff == null) ...[
            SizedBox(height: h * 0.01),
            Text(
              context.tr('Please select a staff member to view free slots.'),
              style: const TextStyle(color: Colors.orange, fontSize: 11),
            ),
          ],
          if (provider.selectedDate != null &&
              provider.selectedStaff != null) ...[
            SizedBox(height: h * 0.015),
            const Divider(),
            SizedBox(height: h * 0.015),
            Text(
              context.tr('Available Free Slots'),
              style: TextStyle(
                fontSize: w * 0.03,
                fontWeight: FontWeight.bold,
                color: AppColors.textGrey,
              ),
            ),
            SizedBox(height: h * 0.01),
            if (provider.availableSlots.isEmpty)
              Text(
                context.tr(
                  'No free slots found for this stylist selection today.',
                ),
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              )
            else
              Wrap(
                spacing: w * 0.02,
                runSpacing: h * 0.01,
                children: provider.availableSlots.map((slot) {
                  final isSelected = provider.selectedTimeSlot == slot;
                  return GestureDetector(
                    onTap: () => provider.selectTimeSlot(slot),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: w * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryPink
                            : AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        slot,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary(context),
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    return Row(
      children: ['Cash', 'Card'].map((method) {
        final active = provider.paymentMethod == method;
        return Expanded(
          child: GestureDetector(
            onTap: () => provider.selectPaymentMethod(method),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: w * 0.015),
              padding: EdgeInsets.symmetric(vertical: h * 0.015),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primaryPink.withValues(alpha: 0.1)
                    : AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: active
                      ? AppColors.primaryPink
                      : AppColors.divider(context),
                  width: active ? 1.5 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  context.tr(method),
                  style: TextStyle(
                    color: active
                        ? AppColors.primaryPink
                        : AppColors.textSecondary(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBookingTotalInvoiceCard(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('Subtotal'),
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: w * 0.035,
                ),
              ),
              Text(
                'Rs. ${provider.subtotal.toInt()}',
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.035,
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('Service Tax (10%)'),
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: w * 0.035,
                ),
              ),
              Text(
                'Rs. ${provider.serviceTax.toInt()}',
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.035,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('Total Payable'),
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.04,
                ),
              ),
              Text(
                'Rs. ${provider.totalAmount.toInt()}',
                style: const TextStyle(
                  color: AppColors.primaryPink,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openAddWalkInCustomerSheet(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.sheetBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.05)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: w * 0.04,
            right: w * 0.04,
            top: w * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('Register New Walk-In'),
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: h * 0.02),
              CustomTextField(
                hint: context.tr('Client Full Name'),
                prefixIcon: Icons.person_outline,
                controller: nameCtrl,
              ),
              SizedBox(height: h * 0.02),
              CustomTextField(
                hint: context.tr('Client Phone Number'),
                prefixIcon: Icons.phone_android_outlined,
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: h * 0.03),
              CustomButton(
                text: context.tr('Register Client'),
                onTap: () {
                  if (nameCtrl.text.trim().isEmpty ||
                      phoneCtrl.text.trim().isEmpty) {
                    return;
                  }
                  provider.registerWalkInCustomer(
                    nameCtrl.text.trim(),
                    phoneCtrl.text.trim(),
                  );
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: h * 0.04),
            ],
          ),
        );
      },
    );
  }

  void _openAddCustomServiceSheet(
    BuildContext context,
    AdminManualBookingProvider provider,
    double w,
    double h,
  ) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final durationCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.sheetBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.05)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: w * 0.04,
            right: w * 0.04,
            top: w * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('Add Custom Service'),
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: h * 0.005),
              Text(
                context.tr(
                  'Add a one-time custom service that is not in the catalog.',
                ),
                style: TextStyle(fontSize: w * 0.03, color: AppColors.textGrey),
              ),
              SizedBox(height: h * 0.02),
              CustomTextField(
                hint: context.tr('Service Name'),
                prefixIcon: Icons.spa_outlined,
                controller: nameCtrl,
              ),
              SizedBox(height: h * 0.015),
              CustomTextField(
                hint: context.tr('Price (Rs.)'),
                prefixIcon: Icons.currency_rupee,
                controller: priceCtrl,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: h * 0.015),
              CustomTextField(
                hint: context.tr('Duration (e.g., 30 mins)'),
                prefixIcon: Icons.timer_outlined,
                controller: durationCtrl,
              ),
              SizedBox(height: h * 0.025),
              CustomButton(
                text: context.tr('Add to Booking'),
                onTap: () {
                  final name = nameCtrl.text.trim();
                  final priceText = priceCtrl.text.trim();
                  final duration = durationCtrl.text.trim();

                  if (name.isEmpty || priceText.isEmpty) return;

                  final price = double.tryParse(priceText) ?? 0.0;
                  if (price <= 0) return;

                  provider.addCustomService(
                    name,
                    price,
                    duration.isEmpty ? '30 mins' : duration,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Custom service added to booking!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              SizedBox(height: h * 0.04),
            ],
          ),
        );
      },
    );
  }

  void _openEditPriceSheet(
    BuildContext context,
    AdminManualBookingProvider provider,
    Map<String, dynamic> service,
    double w,
    double h,
  ) {
    final priceCtrl = TextEditingController(
      text: _formatPrice(service['price']),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.sheetBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.05)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: w * 0.04,
            right: w * 0.04,
            top: w * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${context.tr("Edit Price")}: ${service["name"]}',
                      style: TextStyle(
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: h * 0.005),
              Text(
                '${context.tr("Current price")}: Rs. ${_formatPrice(service["price"])}',
                style: TextStyle(fontSize: w * 0.03, color: AppColors.textGrey),
              ),
              SizedBox(height: h * 0.02),
              CustomTextField(
                hint: context.tr('Enter Custom Price'),
                prefixIcon: Icons.currency_rupee,
                controller: priceCtrl,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: h * 0.025),
              CustomButton(
                text: context.tr('Update Price'),
                onTap: () {
                  final newPrice =
                      double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                  if (newPrice <= 0) return;
                  provider.updateServicePrice(
                    service['id']?.toString() ?? '',
                    newPrice,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Service price updated!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              SizedBox(height: h * 0.04),
            ],
          ),
        );
      },
    );
  }
}
