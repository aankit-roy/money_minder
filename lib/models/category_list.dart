
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class CategoryData {
  final int ? id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryData({this.id, required this.name, required this.icon, required this.color});





  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name': name,
      'icon': jsonEncode({
        'codePoint': icon.codePoint,
        'fontFamily': icon.fontFamily,
        'fontPackage': icon.fontPackage,
        'matchTextDirection': icon.matchTextDirection
      }),
      'color': color.value,
    };
  }

  // Convert a map to a CategoryData object
  factory CategoryData.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> iconDataMap = jsonDecode(map['icon']);
    IconData iconData = IconData(
      iconDataMap['codePoint'],
      fontFamily: iconDataMap['fontFamily'],
      fontPackage: iconDataMap['fontPackage'],
      matchTextDirection: iconDataMap['matchTextDirection'],
    );
    return CategoryData(
      id: map['id'],
      name: map['name'],
      icon: iconData,
      color: Color(map['color']),
    );
  }


}