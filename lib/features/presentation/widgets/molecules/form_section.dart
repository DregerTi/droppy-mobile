import 'package:flutter/material.dart';
import '../../../../../config/theme/widgets/text.dart';
import 'app_bar_widget.dart';

class FormSection extends StatelessWidget {
  final String? title;
  final String? sectionTitle;
  final String? description;
  final Function? setSelectedItem;
  final Function leadingOnPressed;
  final Widget? form;
  final Icon? mainActionIcon;
  final Function? mainActionOnPressed;

  const FormSection({
    Key? key,
    this.title,
    this.sectionTitle,
    this.description,
    this.setSelectedItem,
    required this.leadingOnPressed,
    this.form,
    this.mainActionIcon,
    this.mainActionOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          AppBarWidget(
            leadingIcon: const Icon(Icons.arrow_back),
            leadingOnPressed: () {
              leadingOnPressed();
            },
            title: sectionTitle,
            mainActionIcon: mainActionIcon,
            mainActionOnPressed: mainActionOnPressed,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null ) Text(
                      title!,
                      style: textTheme.headlineMedium,
                    ),
                    if (title != null ) const SizedBox(height: 10),
                    if (description != null ) Text(description!),
                    const SizedBox(height: 36),
                    if(form != null) form!,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}