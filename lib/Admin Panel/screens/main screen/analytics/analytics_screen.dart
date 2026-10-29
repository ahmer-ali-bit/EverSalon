import 'package:ever_salon/Admin%20Panel/providers/analytics/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminAnalyticsProvider(),
      child: const _AdminAnalyticsContent(),
    );
  }
}

class _AdminAnalyticsContent extends StatelessWidget {
  const _AdminAnalyticsContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminAnalyticsProvider>();

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
                    context.tr('Analytics'),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Date Dropdown ---
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.04,
                                vertical: h * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.inputBg(context),
                                borderRadius: BorderRadius.circular(w * 0.08),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: provider.selectedDateRange,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                  ),
                                  style: TextStyle(
                                    color: AppColors.textPrimary(context),
                                    fontSize: w * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  items: provider.dateRanges
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: provider.updateDateRange,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.03),

                          // --- Revenue Overview ---
                          Text(
                            context.tr('Revenue Overview'),
                            style: TextStyle(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Text(
                            provider.totalRevenue,
                            style: TextStyle(
                              fontSize: w * 0.07,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.005),
                          Text(
                            provider.revenueTrend,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),

                          SizedBox(height: h * 0.04),

                          // --- Custom Line Chart ---
                          SizedBox(
                            height: h * 0.2,
                            width: double.infinity,
                            child: CustomPaint(
                              painter: LineChartPainter(
                                data: provider.revenueData,
                                lineColor: AppColors.primaryPink,
                                fillColor: AppColors.primaryPink.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                          ),

                          // Chart Labels
                          Padding(
                            padding: EdgeInsets.only(top: h * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "May 1",
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: w * 0.03,
                                  ),
                                ),
                                Text(
                                  "May 5",
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: w * 0.03,
                                  ),
                                ),
                                Text(
                                  "May 10",
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: w * 0.03,
                                  ),
                                ),
                                Text(
                                  "May 15",
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: w * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.05),

                          // --- Popular Services ---
                          Text(
                            context.tr('Popular Services'),
                            style: TextStyle(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // Bar Charts
                          ...provider.popularServices.map((service) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: h * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        service['name'],
                                        style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                      Text(
                                        "+ ${service['count']}",
                                        style: TextStyle(
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: h * 0.01),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: w * 0.015,
                                            width: constraints.maxWidth,
                                            decoration: BoxDecoration(
                                              color: AppColors.inputBg(context),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    w * 0.01,
                                                  ),
                                            ),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 800,
                                            ),
                                            curve: Curves.easeOut,
                                            height: w * 0.015,
                                            width:
                                                constraints.maxWidth *
                                                service['percentage'],
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryPink,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    w * 0.01,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),

                          SizedBox(height: h * 0.04), // Bottom padding
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Custom Line Chart Painter ---
class LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;

  LineChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxVal = data.reduce((a, b) => a > b ? a : b);
    final double minVal = data.reduce((a, b) => a < b ? a : b);
    final double range = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    final path = Path();
    final fillPath = Path();

    final double stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      // Normalize y so it fits within the height, with some padding top/bottom
      final double normalizedY = (data[i] - minVal) / range;
      final double y =
          size.height -
          (normalizedY * (size.height * 0.8)) -
          (size.height * 0.1);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw points
      final paintDot = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 3.5, paintDot);

      final paintDotInner = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 1.5, paintDotInner);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw Fill
    final paintFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          fillColor.withValues(alpha: 0.5),
          fillColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, paintFill);

    // Draw Line
    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
