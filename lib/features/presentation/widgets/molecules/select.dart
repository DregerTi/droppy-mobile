import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../config/theme/widgets/button.dart';
import '../../../../../config/theme/widgets/text.dart';
import '../../../../config/theme/color.dart';
import '../../../domain/entities/select_item.dart';

class Select extends StatefulWidget {
  final List<SelectItemEntity> selectItems;
  final Function setSelectedItem;
  final SelectItemEntity? selectedItem;
  final bool? isColumn;

  const Select({
    Key? key,
    required this.selectItems,
    required this.setSelectedItem,
    this.selectedItem,
    this.isColumn = false,
  }) : super(key: key);

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {

  @override
  Widget build(BuildContext context) {
    if (widget.isColumn == false) {
      return _buildRow();
    } else {
      return _buildColumn();
    }
  }

  Widget _buildRow() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
          child: Row(
            children: widget.selectItems.map((selectItem) {
            return Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if(widget.selectedItem?.value == selectItem.value) {
                    widget.setSelectedItem(null);
                  } else {
                    widget.setSelectedItem(selectItem);
                  }
                },
                style: elevatedButtonThemeData.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    widget.selectedItem?.value == selectItem.value ? primaryColor : surfaceColor,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    widget.selectedItem?.value == selectItem.value ? backgroundColor : textColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20, horizontal: 10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (selectItem.icon != null) Icon(
                      selectItem.icon,
                      color: widget.selectedItem?.value == selectItem.value ? backgroundColor : textColor,
                      size: 30,
                    ),
                    if (selectItem.icon != null) const SizedBox(height: 8),
                    Text(
                      selectItem.label,
                      style: textTheme.titleSmall?.copyWith(
                        color: widget.selectedItem?.value == selectItem.value ? backgroundColor : textColor,
                      )
                    ),
                  ],
                ),
              ),
            );
          }).toList()
        ),
      ),
    );
  }

  Widget _buildColumn(){
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: widget.selectItems.map((selectItem) {
          return ElevatedButton(
            onPressed: () {
              if(widget.selectedItem?.value == selectItem.value) {
                widget.setSelectedItem(null);
              } else {
                widget.setSelectedItem(selectItem);
              }
            },
            style: elevatedButtonThemeData.style?.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(
                widget.selectedItem?.value == selectItem.value ? primaryColor : surfaceColor,
              ),
              foregroundColor: MaterialStateProperty.all<Color>(
                widget.selectedItem?.value == selectItem.value ? backgroundColor : textColor,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (selectItem.icon != null) Icon(
                  selectItem.icon,
                  color: widget.selectedItem?.value == selectItem.value ? backgroundColor : textColor,
                  size: 30,
                ),
                if (selectItem.icon != null) const SizedBox(width: 20),
                Text(
                  selectItem.label,
                  style: textTheme.titleSmall?.copyWith(
                    color: widget.selectedItem?.value == selectItem.value ? backgroundColor : textColor,
                  )
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}