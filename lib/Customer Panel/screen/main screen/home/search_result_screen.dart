import 'package:ever_salon/Customer%20Panel/provider/customer%20home%20providers/search_result_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/filters_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/salon_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchResultsProvider()..fetchResults(searchQuery),
      child: _SearchResultsView(initialQuery: searchQuery),
    );
  }
}

class _SearchResultsView extends StatefulWidget {
  final String initialQuery;
  const _SearchResultsView({required this.initialQuery});

  @override
  State<_SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<_SearchResultsView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchResultsProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    context.tr('search_results'),
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // --- SEARCH BAR + FILTER BUTTON ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider(context)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty) {
                            provider.fetchResults(val.trim());
                          }
                        },
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: context.tr('search_dots'),
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary(context),
                            fontSize: screenWidth * 0.035,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textSecondary(context),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: AppColors.textSecondary(context),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    provider.clearSearch();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                        ),
                        onChanged: (val) => setState(() {}),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FiltersScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: screenHeight * 0.065,
                      width: screenHeight * 0.065,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // --- RESULTS COUNT + SORT ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${provider.resultsCount} ${context.tr('results_found')}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: AppColors.textSecondary(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showSortBottomSheet(
                      context,
                      provider,
                      screenWidth,
                      screenHeight,
                    ),
                    child: Row(
                      children: [
                        Text(
                          context.tr('sort'),
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: AppColors.textPrimary(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textPrimary(context),
                          size: screenWidth * 0.05,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // --- RESULTS LIST ---
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: screenWidth * 0.2,
                            color: AppColors.textSecondary(context),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            context.tr('no_results'),
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemCount: provider.results.length,
                      itemBuilder: (context, index) {
                        final salon = provider.results[index];
                        return _buildSalonCard(
                          salon: salon,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          onFavoriteTap: () => provider.toggleFavorite(index),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SalonDetailsScreen(salonData: salon),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SORT BOTTOM SHEET ---
  void _showSortBottomSheet(
    BuildContext context,
    SearchResultsProvider provider,
    double screenWidth,
    double screenHeight,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: screenWidth * 0.12,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                context.tr('sort_by'),
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              ...provider.sortOptions.map((option) {
                final bool isSelected = provider.sortBy == option;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      color: isSelected
                          ? AppColors.primaryPink
                          : AppColors.textPrimary(context),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryPink,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          color: AppColors.textSecondary(context),
                        ),
                  onTap: () {
                    provider.updateSortBy(option);
                    Navigator.pop(context);
                  },
                );
              }),
              SizedBox(height: screenHeight * 0.01),
            ],
          ),
        );
      },
    );
  }

  // --- SALON CARD WIDGET ---
  Widget _buildSalonCard({
    required Map<String, dynamic> salon,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onFavoriteTap,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.018),
        padding: EdgeInsets.all(screenWidth * 0.025),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                salon['image'],
                height: screenWidth * 0.22,
                width: screenWidth * 0.22,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: screenWidth * 0.22,
                    width: screenWidth * 0.22,
                    color: AppColors.inputBg(context),
                    child: Icon(
                      Icons.storefront,
                      color: AppColors.textSecondary(context),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          salon['name'],
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          salon['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: salon['isFavorite']
                              ? AppColors.primaryPink
                              : AppColors.textSecondary(context),
                          size: screenWidth * 0.055,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.006),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        "${salon['rating']} (${salon['reviews']})",
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    salon['services'],
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      color: AppColors.textSecondary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.textSecondary(context),
                        size: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        salon['distance'],
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
