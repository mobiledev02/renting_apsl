import 'dart:async';

import 'package:flutter/material.dart';

///    Use case...
///
///    late final SearchedTextDetection _searchText;
///    final TextEditingController _searchController = TextEditingController();
///
///    _searchText = SearchedTextDetection(
///        searchQueryController: _searchController,
///        onSearchedText: (searchedText) {
///          print(searchedText);
///        },
///        onEmptyText: () {
///         print("Clean array when empty");
///       });
///

class SearchedTextDetection {
  final void Function(String) onSearchedText;
  final void Function() onEmptyText;
  final TextEditingController searchQueryController;


  SearchedTextDetection(
      {required this.onSearchedText,
      required this.searchQueryController,
      required this.onEmptyText,
  }) {
   

    initListner();
  }

  Timer? _debounce;
  int _debouncetime = 600;

  // Add listner to controller...
  void initListner() {
    searchQueryController.addListener(_onSearchChanged);
  }

  void disposeController() {
    searchQueryController.dispose();
  }

  /// Dispose off all listners and controller...
  void disposeListners() {
    searchQueryController.removeListener(_onSearchChanged);
    // searchQueryController.dispose();
  }

  // notifys the searched text...
  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      // Fires when user clears textfield...
      if (searchQueryController.text.isEmpty) {
        this.onEmptyText();
      } else {
        // Fires only when user search text and stops typing...
        this.onSearchedText(searchQueryController.text);
      }
    });
  }
}
