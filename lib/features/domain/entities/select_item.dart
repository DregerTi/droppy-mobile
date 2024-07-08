import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class SelectItemEntity extends Equatable {
  final IconData? icon;
  final String label;
  final int value;

  const SelectItemEntity({
    this.icon,
    required this.label,
    required this.value,
  });

  @override
  List<Object?> get props {
    return [
      icon,
      label,
      value,
    ];
  }
}