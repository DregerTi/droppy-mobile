import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class SelectItemEntity extends Equatable {
  final IconData? icon;
  final String label;
  final int value;
  final String? picture;

  const SelectItemEntity({
    this.icon,
    required this.label,
    required this.value,
    this.picture,
  });

  @override
  List<Object?> get props {
    return [
      icon,
      label,
      value,
      picture,
    ];
  }
}