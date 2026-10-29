import 'package:flutter/material.dart';

class ServiceDetailsProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET SPECIFIC SERVICE DETAILS
  // Endpoint: GET /api/services/{serviceId}
  // Returns: duration, detailed description, included items
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _serviceData = {};
  Map<String, dynamic> get serviceData => _serviceData;

  void initServiceData(Map<String, dynamic> initialData) async {
    _serviceData = Map.from(initialData);
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    // ========================================================
    // TODO: BACKEND INTEGRATION - GET SPECIFIC SERVICE DETAILS
    // Endpoint: GET /api/services/{serviceId}
    // Returns: coverImage, duration, about, includes
    // ========================================================
    await Future.delayed(const Duration(milliseconds: 400));

    final name = (_serviceData['name'] ?? '').toString().toLowerCase();
    final id = _serviceData['id']?.toString() ?? '';

    // --------------------------------------------------------
    // COVER IMAGE MAPPING (har service ki apni real image)
    // Path: assets/images/
    // --------------------------------------------------------
    if (name.contains('haircut') || name.contains('styling') || id == '1') {
      _serviceData['coverImage'] = 'assets/images/haircut.png';
      _serviceData['duration'] = '45 mins';
      _serviceData['about'] =
          'Professional haircut and styling by expert stylists. Get the perfect look that suits your face shape and personality.';
      _serviceData['includes'] = [
        'Consultation',
        'Hair Wash',
        'Haircut',
        'Blow Dry / Styling',
      ];
    } else if (name.contains('hair color') ||
        name.contains('color') ||
        id == '2') {
      _serviceData['coverImage'] = 'assets/images/hair color copy.png';
      _serviceData['duration'] = '90 mins';
      _serviceData['about'] =
          'Premium hair coloring service using high-quality products. From highlights to full color — get vibrant, long-lasting results.';
      _serviceData['includes'] = [
        'Color Consultation',
        'Hair Wash',
        'Color Application',
        'Blow Dry',
      ];
    } else if (name.contains('facial') || name.contains('skin') || id == '3') {
      _serviceData['coverImage'] = 'assets/images/facial.png';
      _serviceData['duration'] = '60 mins';
      _serviceData['about'] =
          'Rejuvenating facial treatment that cleanses, exfoliates and nourishes your skin for a fresh glowing look.';
      _serviceData['includes'] = [
        'Cleansing',
        'Scrubbing',
        'Face Massage',
        'Face Mask',
        'Moisturizer',
      ];
    } else if (name.contains('makeup') || id == '4') {
      _serviceData['coverImage'] = 'assets/images/makeup copy.png';
      _serviceData['duration'] = '75 mins';
      _serviceData['about'] =
          'Professional makeup application for parties, events or everyday glam. We use premium branded products.';
      _serviceData['includes'] = [
        'Skin Prep',
        'Foundation & Concealer',
        'Eye Makeup',
        'Lip Makeup',
        'Setting Spray',
      ];
    } else if (name.contains('manicure') || id == '5') {
      _serviceData['coverImage'] = 'assets/images/manicure copy.png';
      _serviceData['duration'] = '40 mins';
      _serviceData['about'] =
          'Complete manicure service for clean, healthy and beautiful nails. Includes cuticle care and polish.';
      _serviceData['includes'] = [
        'Nail Shaping',
        'Cuticle Care',
        'Hand Massage',
        'Nail Polish',
      ];
    } else if (name.contains('pedicure') || id == '6') {
      _serviceData['coverImage'] = 'assets/images/pedicure copy.png';
      _serviceData['duration'] = '50 mins';
      _serviceData['about'] =
          'Relaxing pedicure treatment for soft feet and perfect toenails. Ideal for a complete foot care experience.';
      _serviceData['includes'] = [
        'Foot Soak',
        'Scrubbing',
        'Nail Care',
        'Foot Massage',
        'Nail Polish',
      ];
    } else if (name.contains('hair treatment') ||
        name.contains('hair spa') ||
        name.contains('treatment') ||
        id == '7') {
      _serviceData['coverImage'] = 'assets/images/hair spa treatment.png';
      _serviceData['duration'] = '60 mins';
      _serviceData['about'] =
          'A deep nourishing hair spa that repairs damaged hair, adds shine and makes hair soft and smooth.';
      _serviceData['includes'] = [
        'Hair Wash',
        'Scalp Massage',
        'Hair Spa',
        'Blow Dry',
      ];
    } else if (name.contains('spa') || name.contains('massage')) {
      _serviceData['coverImage'] = 'assets/images/spa.png';
      _serviceData['duration'] = '60 mins';
      _serviceData['about'] =
          'Relaxing spa and massage therapy to relieve stress and rejuvenate your body and mind.';
      _serviceData['includes'] = [
        'Body Massage',
        'Aromatherapy',
        'Steam',
        'Relaxation Time',
      ];
    } else if (name.contains('bridal')) {
      _serviceData['coverImage'] = 'assets/images/bridal.png';
      _serviceData['duration'] = '120 mins';
      _serviceData['about'] =
          'Complete bridal beauty package for your special day. Look stunning with our expert bridal artists.';
      _serviceData['includes'] = [
        'HD Bridal Makeup',
        'Hair Styling',
        'Facial',
        'Nail Care',
      ];
    } else if (name.contains('nail')) {
      _serviceData['coverImage'] = 'assets/images/nails.png';
      _serviceData['duration'] = '45 mins';
      _serviceData['about'] =
          'Professional nail art and care services for beautiful hands and feet.';
      _serviceData['includes'] = [
        'Nail Shaping',
        'Cuticle Care',
        'Nail Art',
        'Top Coat',
      ];
    } else if (name.contains('lash')) {
      _serviceData['coverImage'] = 'assets/images/lashes.png';
      _serviceData['duration'] = '50 mins';
      _serviceData['about'] =
          'Premium lash extension and lifting services for fuller, longer looking lashes.';
      _serviceData['includes'] = [
        'Lash Consultation',
        'Lash Application',
        'Styling',
        'Aftercare Tips',
      ];
    } else if (name.contains('brow')) {
      _serviceData['coverImage'] = 'assets/images/brows.png';
      _serviceData['duration'] = '30 mins';
      _serviceData['about'] =
          'Expert brow shaping, tinting and threading for perfectly defined eyebrows.';
      _serviceData['includes'] = [
        'Brow Mapping',
        'Threading / Waxing',
        'Tinting',
        'Styling',
      ];
    } else {
      // Default fallback
      _serviceData['coverImage'] = 'assets/images/hair spa treatment.png';
      _serviceData['duration'] = _serviceData['duration'] ?? '60 mins';
      _serviceData['about'] =
          _serviceData['about'] ??
          'Premium salon service delivered by our expert beauticians using high-quality products.';
      _serviceData['includes'] =
          _serviceData['includes'] ??
          ['Consultation', 'Primary Treatment', 'Finishing Touch'];
    }

    // Agar pehle se duration/about/includes aa chuke hain API se to unko override mat karo
    // (upar defaults only tab set hue jab null thay — already handled)

    _isLoading = false;
    notifyListeners();
  }

  void shareService() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - Share service link
    // ========================================================
    debugPrint('Sharing Service: ${_serviceData['name']}');
  }
}
