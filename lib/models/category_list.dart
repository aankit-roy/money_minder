
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class CategoryData {
  final int ? id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryData({this.id, required this.name, required this.icon, required this.color});

  CategoryData copyWith({
    int? id,
    String? name,
    IconData? icon,
    Color? color,
  }) {
    return CategoryData(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryData &&
              runtimeType == other.runtimeType &&
              name == other.name; // Compare by name

  @override
  int get hashCode => name.hashCode; // Generate hashCode based on name






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

    final IconData iconData =  IconData(
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