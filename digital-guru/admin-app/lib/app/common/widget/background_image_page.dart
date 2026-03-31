import 'package:cached_network_image/cached_network_image.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import "package:flutter/material.dart";

class BackgroundImageBox extends StatelessWidget {
  final String url;
  final List<Widget> children;
  final MainAxisAlignment alignment;
  final List<Color> colors;
  BackgroundImageBox(
      {Key key,
      @required this.url,
      @required this.children,
      @required this.alignment,
      this.colors});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        url != null && url.length > 0
            ? Container(
                child: CachedNetworkImage(
                  imageUrl: url,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                        // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )
            : new Container(
                width: double.infinity,
                height: double.infinity,
                decoration: buildLinearGradient(context,
                    colors: colors != null ? colors : null),
              ),
        Row(
          mainAxisAlignment: alignment,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ],
    );
  }
}
