import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDisposed = false;
  List<Map<String, dynamic>> _packages = [];
  List<Map<String, dynamic>> get packages => _packages;

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET HOME DATA API
  // Endpoint: GET /api/home
  // Returns: user_name, banners, categories, featured_salons
  // ========================================================

  String userName = "Kiran";

  // Categories with image path & background color as per icon theme
  List<Map<String, dynamic>> categories = [
    {
      "name": "Hair",
      "image": "assets/images/hairs.png",
      "bgColor": Color(0xFFEDE7F6), // Soft Purple
    },
    {
      "name": "Makeup",
      "image": "assets/images/makeup.png",
      "bgColor": Color(0xFFFCE4EC), // Soft Pink
    },
    {
      "name": "Nails",
      "image": "assets/images/nails.png",
      "bgColor": Color(0xFFFFF0F5), // Light Pink
    },
    {
      "name": "Skin Care",
      "image": "assets/images/skin care.png",
      "bgColor": Color(0xFFF3E5F5), // Soft Lavender
    },
    {
      "name": "Spa",
      "image": "assets/images/spa.png",
      "bgColor": Color(0xFFF5EEE6), // Soft Beige
    },
    {
      "name": "Bridal",
      "image": "assets/images/bridal.png",
      "bgColor": Color(0xFFFFE4EC), // Soft Pink
    },
  ];

  // Featured Salons with image paths
  List<Map<String, dynamic>> featuredSalons = [
    {
      "id": 1,
      "name": "Glow Beauty Lounge",
      "rating": 4.8,
      "reviews": 256,
      "distance": "2.4 km",
      "image": "assets/images/glow beauty lounge.png",
      "isFavorite": false,
    },
    {
      "id": 2,
      "name": "The Glam Studio",
      "rating": 4.7,
      "reviews": 198,
      "distance": "3.1 km",
      "image": "assets/images/the glam studio.png",
      "isFavorite": true,
    },
  ];

  void fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    // Simulating API Call delay
    await Future.delayed(const Duration(seconds: 1));

    // Prevent notifyListeners after dispose (tab switch crash fix)
    if (_isDisposed) return;

    _isLoading = false;
    notifyListeners();

    // Add this variable in your HomeProvider class:

    // Inside fetchHomeData() add this:
    _packages = [
      {
        'id': '1',
        'name': 'Bridal Package',
        'price': 25000,
        'image': 'assets/images/bridal.png',
        'coverImage': 'assets/images/bridal copy.png',
        'salon': {
          'id': '1',
          'name': 'Glow Beauty Lounge',
        }, // Needed for booking flow
        'includes': [
          'HD Bridal Makeup',
          'Hair Styling',
          'Facial',
          'Nail Care',
          'Hair Spa',
        ],
      },
      {
        'id': '2',
        'name': 'Party Package',
        'price': 8500,
        'image': 'assets/images/makeup.png',
        'coverImage': 'assets/images/party.png',
        'salon': {'id': '1', 'name': 'Glow Beauty Lounge'},
        'includes': ['Party Makeup', 'Hair Styling', 'Nail Paint', 'Lashes'],
      },
    ];
  }

  void toggleFavorite(int index) {
    // ========================================================
    // TODO: BACKEND INTEGRATION - ADD/REMOVE FAVORITE API
    // Endpoint: POST /api/favorites/toggle
    // Payload: { salon_id: id }
    // ========================================================
    if (_isDisposed) return;
    featuredSalons[index]["isFavorite"] = !featuredSalons[index]["isFavorite"];
    notifyListeners();
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET HOME BANNERS / OFFERS API
  // Endpoint: GET /api/home/banners
  // Returns: list of banners with title, subtitle, button_text,
  //          image, discount_code, etc.
  // ========================================================

  // Current active banner (can be replaced by API list later)
  Map<String, dynamic> promoBanner = {
    "title": "Get 20% Off",
    "subtitle": "On Your First Booking",
    "buttonText": "Book Now",
    "image": "assets/images/home card.png",
    "discountCode": "FIRST20",
  };

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
