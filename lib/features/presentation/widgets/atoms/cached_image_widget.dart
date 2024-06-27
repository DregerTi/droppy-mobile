import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const CachedImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder : (context, imageProvider) => ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(0.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover
            )
          ),
        ),
      ),
      progressIndicatorBuilder : (context, url, downloadProgress) => ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(0.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
          ),
          child: const CupertinoActivityIndicator(),
        ),
      ),
      errorWidget : (context, url, error) =>
        ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(0.0),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.08),
            ),
            child: const Icon(Icons.error),
        ),
      )
    );
  }
}