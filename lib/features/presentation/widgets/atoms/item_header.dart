import 'package:flutter/widgets.dart';
import '../../../../config/theme/widgets/text.dart';
import 'cached_image_widget.dart';

class ItemHeader extends StatelessWidget {
  final String? imageUrl;
  final List<String>? imagesUrls;
  final String? title;

  const ItemHeader({
    Key? key,
    this.imageUrl,
    this.imagesUrls,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(title);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (imageUrl != null) CachedImageWidget(
          imageUrl: imageUrl!,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3.5,
          fit: BoxFit.fitWidth,
        ),
        if(title != null) Container(
          alignment: const Alignment(-1, 0),
          padding: const EdgeInsets.all(20),
          child: Text(
            title!,
              style: textTheme.titleLarge,
          ),
        ),
      ]
    );
  }
}