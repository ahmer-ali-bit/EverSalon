import 'package:flutter/material.dart';

class SalonDetailsProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET SALON DETAILS API
  // Endpoint: GET /api/salons/{id}
  // Returns: full salon info with services, staff, reviews,
  //          gallery, packages, location, opening hours
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  bool _isAboutExpanded = false;
  bool get isAboutExpanded => _isAboutExpanded;

  Map<String, dynamic> _salonData = {};
  Map<String, dynamic> get salonData => _salonData;

  // Gallery preview images (first 4 for salon details screen)
  List<Map<String, dynamic>> _galleryPreview = [];
  List<Map<String, dynamic>> get galleryPreview => _galleryPreview;

  // Services preview list
  List<Map<String, dynamic>> _servicesPreview = [];
  List<Map<String, dynamic>> get servicesPreview => _servicesPreview;

  // Packages preview list
  List<Map<String, dynamic>> _packagesPreview = [];
  List<Map<String, dynamic>> get packagesPreview => _packagesPreview;

  // Beauticians preview list
  List<Map<String, dynamic>> _beauticiansPreview = [];
  List<Map<String, dynamic>> get beauticiansPreview => _beauticiansPreview;

  // Reviews preview list
  List<Map<String, dynamic>> _reviewsPreview = [];
  List<Map<String, dynamic>> get reviewsPreview => _reviewsPreview;

  void initializeSalonData(Map<String, dynamic> data) {
    _salonData = data;
    _loadMockData();
    notifyListeners();
  }

  void _loadMockData() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - All this mock data will be
    // replaced by API response from GET /api/salons/{id}
    // ========================================================

    // If salonData doesn't have full info, fill with defaults
    if (_salonData['name'] == null) {
      _salonData = {
        'id': '1',
        'name': 'Glow Beauty Lounge',
        'image': 'assets/salon details/salon_cover.png',
        'rating': 4.8,
        'reviewCount': 256,
        'type': 'Unisex Salon',
        'isOpen': true,
        'distance': '2.4 km',
        'address': 'Bahawalpur, Pakistan',
        'fullAddress': 'Yasrab Town, Near Shell Pump, Bahawalpur, Pakistan',
        'phone': '+92 300 1234567',
        'openTime': '10:00 AM',
        'closeTime': '9:00 PM',
        'openDays': 'Mon - Sun',
        'about':
            'Welcome to Glow Beauty Lounge, where beauty meets perfection. We offer premium services with professional care. Our experienced team of beauticians ensures you get the best treatment with high-quality products. We specialize in bridal makeup, hair styling, skin treatments, and much more.',
        'latitude': 29.3956,
        'longitude': 71.6836,
      };
    }

    // Gallery preview (first 4 images)
    _galleryPreview = [
      {
        'id': '1',
        'image': 'assets/images/elegance salon.png',
        'category': 'Interior',
      },
      {
        'id': '2',
        'image': 'assets/images/glow beauty lounge.png',
        'category': 'Interior',
      },
      {
        'id': '3',
        'image': 'assets/images/radiance studio.png',
        'category': 'Services',
      },
      {
        'id': '4',
        'image': 'assets/images/the glam studio.png',
        'category': 'Staff',
      },
    ];

    // Services preview
    _servicesPreview = [
      {
        'id': '1',
        'name': 'Haircut & Styling',
        'image': 'assets/images/hairs.png', // Image added
        'price': 1000,
        'color': 0xFFE8F5E9,
      },
      {
        'id': '2',
        'name': 'Hair Color',
        'image':
            'assets/images/hair color.png', // Image added
        'price': 2500,
        'color': 0xFFFCE4EC,
      },
      {
        'id': '3',
        'name': 'Facial',
        'image':
            'assets/images/skin care.png', // Image added
        'price': 2000,
        'color': 0xFFE3F2FD,
      },
      {
        'id': '4',
        'name': 'Makeup',
        'image': 'assets/images/makeup.png', // Image added
        'price': 3500,
        'color': 0xFFF3E5F5,
      },
    ];

    // Packages preview
    _packagesPreview = [
      {
        'id': '1',
        'name': 'Bridal Package',
        'image': 'assets/images/bridal copy.png',
        'price': 25000,
        'includes': [
          'Makeup',
          'Hair Styling',
          'Facial',
          'Nail Care',
          'Hair Spa',
        ],
      },
      {
        'id': '2',
        'name': 'Party Package',
        'image': 'assets/images/party.png',
        'price': 8500,
        'includes': ['Makeup', 'Hair Styling', 'Nail Paint'],
      },
    ];

    // Beauticians preview
    _beauticiansPreview = [
      {
        'id': '1',
        'name': 'Ayesha Khan',
        'image': 'assets/images/beautician.png',
        'role': 'Senior Stylist',
        'rating': 4.9,
        'reviewCount': 128,
        'isFavorite': false,
      },
      {
        'id': '2',
        'name': 'Sara Malik',
        'image': 'assets/images/beautician.png',
        'role': 'Makeup Artist',
        'rating': 4.8,
        'reviewCount': 96,
        'isFavorite': false,
      },
      {
        'id': '3',
        'name': 'Hina Butt',
        'image': 'assets/images/beautician.png',
        'role': 'Hair Color Expert',
        'rating': 4.7,
        'reviewCount': 84,
        'isFavorite': false,
      },
    ];

    // Reviews preview
    _reviewsPreview = [
      {
        'id': '1',
        'userName': 'Zainab Fatima',
        'userImage': 'assets/images/beautician.png',
        'rating': 5.0,
        'date': '2 days ago',
        'comment':
            'Amazing service and very professional staff. Highly recommended!',
        'images': [
          'assets/salon details/review_img_1.png',
          'assets/salon details/review_img_2.png',
        ],
      },
    ];
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();

    // ========================================================
    // TODO: BACKEND INTEGRATION - TOGGLE FAVORITE API
    // Endpoint: POST /api/favorites/toggle
    // Body: { "salonId": salonData['id'] }
    // ========================================================
  }

  void toggleAboutExpanded() {
    _isAboutExpanded = !_isAboutExpanded;
    notifyListeners();
  }

  Future<void> fetchSalonDetails(String salonId) async {
    _isLoading = true;
    notifyListeners();

    // ========================================================
    // TODO: BACKEND INTEGRATION - FETCH SALON DETAILS
    // Endpoint: GET /api/salons/$salonId
    // Replace mock data with API response
    // ========================================================

    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();
  }

  void callSalon() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - Launch phone dialer
    // Use url_launcher package:
    // launchUrl(Uri.parse('tel:${salonData['phone']}'));
    // ========================================================
    debugPrint('Calling salon: ${_salonData['phone']}');
  }

  void getDirections() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - Open maps for directions
    // Use url_launcher package:
    // launchUrl(Uri.parse('google.navigation:q=${lat},${lng}'));
    // ========================================================
    debugPrint('Getting directions to salon');
  }

  void shareSalon() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - Share salon link
    // Use share_plus package:
    // Share.share('Check out ${salonData['name']} on EverSalon!');
    // ========================================================
    debugPrint('Sharing salon: ${_salonData['name']}');
  }
}
