import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminSalonGalleryProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;
  bool isUploading = false;

  /// Only salon premises photos
  final List<String> categories = ['All', 'Interior', 'Exterior'];
  String selectedCategory = 'All';

  List<Map<String, dynamic>> photos = [];

  AdminSalonGalleryProvider() {
    _fetchGallery();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchGallery() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND GET /api/admin/salon/gallery
    // Only interior/exterior salon photos
    await Future.delayed(const Duration(milliseconds: 400));

    photos = [
      {
        'id': 'G1',
        'path': 'assets/images/salons/interior1.png',
        'category': 'Interior',
        'isLocal': false,
      },
      {
        'id': 'G2',
        'path': 'assets/images/salons/interior2.png',
        'category': 'Interior',
        'isLocal': false,
      },
      {
        'id': 'G3',
        'path': 'assets/images/salons/exterior1.png',
        'category': 'Exterior',
        'isLocal': false,
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void setCategory(String cat) {
    selectedCategory = cat;
    _safeNotify();
  }

  List<Map<String, dynamic>> get filteredPhotos {
    if (selectedCategory == 'All') return photos;
    return photos.where((p) => p['category'] == selectedCategory).toList();
  }

  /// Add photo — category from current tab (All → Interior default)
  Future<void> addPhoto({String? forceCategory}) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x == null) return;

    isUploading = true;
    _safeNotify();

    // TODO: BACKEND POST /api/admin/salon/gallery (type: interior|exterior)
    await Future.delayed(const Duration(milliseconds: 600));

    final cat =
        forceCategory ??
        (selectedCategory == 'All' ? 'Interior' : selectedCategory);

    // Safety: only Interior or Exterior
    final safeCat = (cat == 'Exterior') ? 'Exterior' : 'Interior';

    photos.insert(0, {
      'id': 'G_${DateTime.now().millisecondsSinceEpoch}',
      'path': x.path,
      'category': safeCat,
      'isLocal': true,
    });

    isUploading = false;
    _safeNotify();
  }

  Future<void> deletePhoto(String id) async {
    // TODO: BACKEND DELETE /api/admin/salon/gallery/:id
    photos.removeWhere((p) => p['id'] == id);
    _safeNotify();
  }

  void changeCategory(String id, String newCat) {
    if (newCat != 'Interior' && newCat != 'Exterior') return;
    final i = photos.indexWhere((p) => p['id'] == id);
    if (i != -1) {
      photos[i]['category'] = newCat;
      _safeNotify();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
