import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';

const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);

const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceMedium = SizedBox(height: 18.0);
const Widget verticalSpaceLarge = SizedBox(height: 30.0);
const Widget verticalSpaceXtraLarge = SizedBox(height: 50.0);
const Widget verticalSpaceMassive = SizedBox(height: 120.0);

Widget spacedDivider = Column(
  children: const <Widget>[
    verticalSpaceMedium,
    const Divider(color: Colors.blueGrey, height: 5.0),
    verticalSpaceMedium,
  ],
);

Widget verticalSpace(double height) => SizedBox(height: height);

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0}) =>
    (screenHeight(context) - offsetBy) / dividedBy;

double screenWidthFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0}) =>
    (screenWidth(context) - offsetBy) / dividedBy;

double halfScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 2);

double thirdScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 3);

void portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

commonContainer(BuildContext context, Widget child, {bool drawBorder = true}) {
  return Container(
    child: child,
    width: screenWidth(context),
    decoration: drawBorder ? boxDecoration(context) : null,
    padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
  );
}

buildCircularLoader(BuildContext context) {
  return GFLoader(
    type: GFLoaderType.circle,
  );
}

BoxDecoration boxDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).canvasColor,
    border: Border.all(color: Theme.of(context).hintColor),
    borderRadius: BorderRadius.circular(5),
    /* boxShadow: [
      BoxShadow(
        color: Theme.of(context).accentColor,
        offset: Offset(1, 1),
        blurRadius: 6.0,
      ),
    ],*/
  );
}

BoxDecoration buildLinearGradient(BuildContext context,
    {List<Color> colors,
    List<double> stops,
    BoxShape shape = BoxShape.rectangle}) {
  if (colors == null) colors = [Theme.of(context).primaryColor, Colors.white];
  if (stops == null) stops = [0.0, 0.5];
  return BoxDecoration(
      shape: shape,
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: stops,
      ));
}

CircleAvatar ceircularAvatar({double radious, String image}) {
  return CircleAvatar(
    backgroundColor: Colors.white,
    radius: radious,
    backgroundImage: NetworkImage(image),
  );
}

BoxDecoration decorationUnderline() {
  return BoxDecoration(
      border: Border(
          bottom: BorderSide(
    color: Colors.white,
    //width: 2.0, // Underline thickness
  )));
}

Container buildRemoteConfigContainer() {
  return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 15),
      /*decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),*/
      alignment: Alignment.center,
      child: Text(
        'Banner from emote Config',
        textAlign: TextAlign.center,
      ));
}

buildToolTip(BuildContext context, String msg) {
  if (msg != null) {
    return Tooltip(
      message: msg,
      child: Icon(
        Icons.info,
        color: Theme.of(context).iconTheme.color,
        size: Theme.of(context).iconTheme.size,
      ),
    );
  }
  return null;
}

buildWrappedText(BuildContext context, String text,
    {int lines = 1, TextStyle style}) {
  if (text != null) {
    return AutoSizeText(text,
        softWrap: true,
        minFontSize: 12,
        maxLines: lines,
        overflow: TextOverflow.ellipsis,
        style: style != null ? style : Theme.of(context).textTheme.headline4);
  } else {
    return Container();
  }
}

buildCachedNetworkCacheImage(BuildContext context, String url) {
  try {
    if (url != null && url.length > 0) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.fill,
        placeholder: (context, url) => buildCircularLoader(context),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    } else {
      return null;
    }
  } catch (e) {
    return Container(
      child: Icon(Icons.error, color: Colors.red),
    );
  }
}

buildScorabbleAccordian(BuildContext context,
    {@required List<Widget> headChildren,
    @required List<Widget> bodyChildren}) {
  return ExpandableNotifier(
    child: ScrollOnExpand(
      child: ExpandablePanel(
        collapsed: null,
        header: Container(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: headChildren,
                )
              ],
            )),
        expanded: Column(children: bodyChildren),
        theme: ExpandableThemeData(
          iconColor: Theme.of(context).primaryColor,
          tapHeaderToExpand: true,
          collapseIcon: Icons.arrow_circle_up,
          expandIcon: Icons.arrow_circle_down,
          iconSize: 35,
        ),
      ),
    ),
  );
}
