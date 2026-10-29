import 'package:ever_salon/Customer%20Panel/provider/customer%20home%20providers/categories_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/all_salons_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoriesProvider()..fetchCategories(),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatefulWidget {
  const _CategoriesView();

  @override
  State<_CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<_CategoriesView> {
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoriesProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04; // Standard padding

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER (Back button + Title + Search icon) ---
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
                  Expanded(
                    child: Text(
                      context.tr('categories'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showSearch = !_showSearch;
                        if (!_showSearch) {
                          _searchController.clear();
                          provider.updateSearch("");
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _showSearch ? Icons.close : Icons.search,
                        color: AppColors.textPrimary(context),
                        size: screenWidth * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- SEARCH FIELD (Toggleable) ---
            if (_showSearch)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider(context)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => provider.updateSearch(val),
                    decoration: InputDecoration(
                      hintText: context.tr('search_categories'),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ),
              ),

            SizedBox(height: screenHeight * 0.015),

            // --- CATEGORIES GRID ---
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.categories.isEmpty
                  ? Center(
                      child: Text(
                        context.tr('no_categories'),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(padding),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: screenHeight * 0.02,
                        crossAxisSpacing: screenWidth * 0.03,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        return _buildCategoryCard(
                          category: category,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          onTap: () {
                            // Navigate to All Salons (optionally pass category name later for filter)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllSalonsScreen(),
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

  // --- CATEGORY CARD WIDGET ---
  Widget _buildCategoryCard({
    required Map<String, dynamic> category,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: screenWidth * 0.22,
            width: screenWidth * 0.22,
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: category['bgColor'],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Image.asset(
              category['image'],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.category,
                  color: AppColors.primaryPink,
                  size: screenWidth * 0.08,
                );
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            category['name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.033,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
