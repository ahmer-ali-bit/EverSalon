import 'package:ever_salon/provider/customer%20home%20providers/salon_search_provider.dart';
import 'package:ever_salon/screen/main%20screen/home/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';

class SalonSearchScreen extends StatelessWidget {
  const SalonSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalonSearchProvider(),
      child: const _SalonSearchView(),
    );
  }
}

class _SalonSearchView extends StatefulWidget {
  const _SalonSearchView();

  @override
  State<_SalonSearchView> createState() => _SalonSearchViewState();
}

class _SalonSearchViewState extends State<_SalonSearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus on search field when screen opens
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(
    BuildContext context,
    String query,
    SalonSearchProvider provider,
  ) {
    if (query.trim().isEmpty) return;

    provider.addRecentSearch(query.trim());
    FocusScope.of(context).unfocus();

    // Navigate to Search Results
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(searchQuery: query.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SalonSearchProvider>(context);
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
                    context.tr('search'),
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // --- SEARCH BAR ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBg(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider(context)),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: (val) => provider.updateQuery(val),
                  onSubmitted: (val) => _performSearch(context, val, provider),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: context.tr('search_artists'),
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: screenWidth * 0.035,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textSecondary(context),
                    ),
                    suffixIcon: provider.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: AppColors.textSecondary(context),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              provider.clearQuery();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // --- DYNAMIC CONTENT (Suggestions OR Recent/Popular) ---
            Expanded(
              child: provider.searchQuery.isNotEmpty
                  ? _buildLiveSuggestions(provider, screenWidth, screenHeight)
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- RECENT SEARCHES ---
                          if (provider.recentSearches.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.tr('recent_searches'),
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => provider.clearRecentSearches(),
                                  child: Text(
                                    context.tr('clear_all'),
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors
                                          .error, // Red color as per UI
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.recentSearches.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(
                                    Icons.search,
                                    color: AppColors.textSecondary(context),
                                  ),
                                  title: Text(
                                    provider.recentSearches[index],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.038,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  onTap: () {
                                    _searchController.text =
                                        provider.recentSearches[index];
                                    _performSearch(
                                      context,
                                      provider.recentSearches[index],
                                      provider,
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],

                          // --- POPULAR SEARCHES ---
                          Text(
                            context.tr('popular_searches'),
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Wrap(
                            spacing: screenWidth * 0.025,
                            runSpacing: screenHeight * 0.015,
                            children: provider.popularSearches.map((search) {
                              return GestureDetector(
                                onTap: () {
                                  _searchController.text = search;
                                  _performSearch(context, search, provider);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.012,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg(context),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.divider(context),
                                    ),
                                  ),
                                  child: Text(
                                    search,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: AppColors.textPrimary(context),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LIVE AUTOCOMPLETE SUGGESTIONS WIDGET ---
  Widget _buildLiveSuggestions(
    SalonSearchProvider provider,
    double screenWidth,
    double screenHeight,
  ) {
    if (provider.liveSuggestions.isEmpty) {
      return Center(
        child: Text(
          context.tr('no_matching'),
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: screenWidth * 0.04,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      itemCount: provider.liveSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = provider.liveSuggestions[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.trending_up, color: AppColors.primaryPink),
          title: Text(
            suggestion,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            _searchController.text = suggestion;
            _performSearch(context, suggestion, provider);
          },
        );
      },
    );
  }
}
