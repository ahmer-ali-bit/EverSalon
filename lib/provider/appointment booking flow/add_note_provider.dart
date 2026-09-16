import 'package:flutter/material.dart';

class AddNotesProvider extends ChangeNotifier {
  // ========================================================
  // TODO: Notes booking ke sath POST /api/bookings me jayengi
  // Field: notes (string, max 200 chars)
  // ========================================================

  static const int maxCharacters = 200;

  final TextEditingController notesController = TextEditingController();

  String _notes = '';
  String get notes => _notes;

  int get characterCount => _notes.length;

  bool get isOverLimit => _notes.length > maxCharacters;

  void onNotesChanged(String value) {
    // Max limit enforce
    if (value.length <= maxCharacters) {
      _notes = value;
    } else {
      _notes = value.substring(0, maxCharacters);
      notesController.text = _notes;
      notesController.selection = TextSelection.fromPosition(
        TextPosition(offset: _notes.length),
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
