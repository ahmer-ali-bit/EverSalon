import 'package:flutter/material.dart';

class AddNotesProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - notes field POST /api/bookings ke sath jayegi
  // max length typically 200–500 (yahan 200 design ke mutabiq)
  // ========================================================

  static const int maxCharacters = 200;

  final TextEditingController notesController = TextEditingController();

  String _notes = '';
  String get notes => _notes;

  int get characterCount => _notes.length;

  bool get isNearLimit => _notes.length >= (maxCharacters * 0.9); // 180+

  void onNotesChanged(String value) {
    if (value.length <= maxCharacters) {
      _notes = value;
    } else {
      // Hard cap at max
      _notes = value.substring(0, maxCharacters);
      notesController.value = TextEditingValue(
        text: _notes,
        selection: TextSelection.collapsed(offset: _notes.length),
      );
    }
    notifyListeners();
  }

  void clearNotes() {
    _notes = '';
    notesController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
