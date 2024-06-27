import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class FormSectionItemEntity extends Equatable {
  final IconData icon;
  final String title;
  final String index;
  final String? onTapRoutePath;

  const FormSectionItemEntity({
    required this.icon,
    required this.title,
    required this.index,
    this.onTapRoutePath,
  });

  @override
  List<Object?> get props {
    return [
      icon,
      title,
      index,
      onTapRoutePath,
    ];
  }
}