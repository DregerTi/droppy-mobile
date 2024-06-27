import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../config/theme/widgets/input.dart';

class DefaultFormField extends StatelessWidget {
  const DefaultFormField({
    Key? key,
    required this.name,
    this.errorText,
    this.initialValue,
    this.placeholder,
    this.hasLabel = false,
    this.focusNode,
    this.onTap,
    this.suffixIcon,
    required TextEditingController this.textEditingController,
  }) : super(key: key);

  final String name;
  final String? errorText;
  final String? initialValue;
  final String? placeholder;
  final bool hasLabel;
  final FocusNode? focusNode;
  final Function()? onTap;
  final TextEditingController? textEditingController;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      controller: textEditingController,
      focusNode: focusNode,
      initialValue: textEditingController == null ? initialValue : null,
      onTap: onTap,
      keyboardType: TextInputType.text,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      obscureText: true,
      decoration: inputDecoration(
        !hasLabel ? (placeholder ?? name) : '',
        errorText ?? '',
        suffixIcon,
      ),
    );
  }
}
