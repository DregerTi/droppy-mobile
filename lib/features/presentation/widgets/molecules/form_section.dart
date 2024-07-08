import 'package:droppy/features/presentation/widgets/molecules/select.dart';
import 'package:flutter/material.dart';
import '../../../../../config/theme/widgets/text.dart';
import '../../../domain/entities/select_item.dart';
import 'app_bar_widget.dart';

class FormSection extends StatelessWidget {
  final String? title;
  final String? sectionTitle;
  final String? description;
  final List<SelectItemEntity>? selectItems;
  final SelectItemEntity? selectedItem;
  final Function? setSelectedItem;
  final Function leadingOnPressed;
  final Widget? form;
  final Icon? mainActionIcon;
  final Function? mainActionOnPressed;
  final String? error;

  const FormSection({
    Key? key,
    this.title,
    this.sectionTitle,
    this.description,
    this.selectItems,
    this.selectedItem,
    this.setSelectedItem,
    required this.leadingOnPressed,
    this.form,
    this.mainActionIcon,
    this.mainActionOnPressed,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
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
                      const SizedBox(height: 12),
                      if (error != null) Text(
                        error!,
                        style: textTheme.bodySmall!.copyWith(
                          color: Colors.red,
                        ),
                      ) else const SizedBox(height: 17),
                      const SizedBox(height: 12),
                      if(selectItems != null) Select(
                        isColumn: true,
                        selectItems: selectItems!,
                        selectedItem: selectedItem,
                        setSelectedItem: (value) {
                          setSelectedItem!(value);
                        },
                      ),
                      if(form != null) form!,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}