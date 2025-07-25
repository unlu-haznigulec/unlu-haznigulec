import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DropdownModel extends Equatable {
  final String name;
  final dynamic value;
  final Widget? icon;

  const DropdownModel({
    required this.name,
    this.value,
    this.icon,
  });

  factory DropdownModel.fromJson(Map<String, dynamic> json) {
    return DropdownModel(
      name: json['name'],
      value: json['value'],
    );
  }

  @override
  List<Object?> get props => [
        name,
        value,
        icon,
      ];
}
