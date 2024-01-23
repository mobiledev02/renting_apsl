import 'package:flutter/material.dart';

import '../constants/img_font_color_string.dart';

class MenuItemModel {
  final String text;

  const MenuItemModel({
    required this.text,
  });
}

class MenuItems2 {
  static const List<MenuItemModel> firstItems = [all, available];

  List<String> menuItems = ["All", "Available"];

  static const all = MenuItemModel(text: 'All');
  static const available = MenuItemModel(text: 'Available');

  static Widget buildItem(MenuItemModel item, {required bool selected}) {
    return Text(
      item.text,
      style: TextStyle(
        color: selected ? custMaterialPrimaryColor : Colors.black,
      ),
    );
  }
}

class MenuItems {
  static const List<MenuItemModel> firstItems = [recommended, highest, lowest];

  List<String> menuItems = ["Recommended", "Price(Highest)", "Price(Lowest)"];

  static const recommended = MenuItemModel(text: 'Recommended');
  static const highest = MenuItemModel(text: 'Price(Highest)');
  static const lowest = MenuItemModel(text: 'Price(Lowest)');

  static Widget buildItem(MenuItemModel item, {required bool selected}) {
    return Text(
      item.text,
      style: TextStyle(
        color: selected ? custMaterialPrimaryColor : Colors.black,
      ),
    );
  }
}

class FilterItemsForReqestScreen {
  static const List<MenuItemModel> firstItems = [
    item,
    service,
  ];

  List<String> menuItems = ["Item", "Service"];

  static const item = MenuItemModel(text: 'Item');
  static const service = MenuItemModel(text: 'Service');

  static Widget buildItem(MenuItemModel item, {required bool selected}) {
    return Text(
      item.text,
      style: TextStyle(
        color: selected ? custMaterialPrimaryColor : Colors.black,
      ),
    );
  }
}
