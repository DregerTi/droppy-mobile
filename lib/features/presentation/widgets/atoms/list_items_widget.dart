import 'package:droppy/features/presentation/widgets/atoms/tile_item_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../config/theme/color.dart';
import '../../../../../config/theme/widgets/text.dart';

class ListItemsWidget extends StatelessWidget {
  final List<TileItemWidget> children;
  final String? title;

  const ListItemsWidget({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        if (title != null) Text(
          title!,
          style: textTheme.titleMedium,
        ),
        if (title != null) const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: surfaceColor,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return const Column(
                children:[
                  SizedBox(height: 14),
                  Divider(
                    color: onBackgroundColor,
                    height: 1,
                  ),
                  SizedBox(height: 14),
                ]
              );
            },
            itemCount: children.length,
            itemBuilder: (context, index) {
              return children[index];
            },
          ),
        ),
      ]
    );
  }
}