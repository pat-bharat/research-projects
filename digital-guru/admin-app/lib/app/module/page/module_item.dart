import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/constants/tooltips.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/background_image_page.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:flutter/material.dart';

class ModuleItem extends StatelessWidget {
  final Module? module;
  final Function? onDeleteItem;
  final Function? onEditItem;
  final Function? onEditLessons;
  final Function? onPurchase;
  final Function? onViewDoc;
  final Function? onPlayVideo;
  final bool isAdmin;
  final bool? canPurchase;
  const ModuleItem(
      {Key? key,
      this.module,
      this.onDeleteItem,
      this.onEditItem,
      this.onEditLessons,
      this.onViewDoc,
      this.onPlayVideo,
      this.onPurchase,
      this.isAdmin = false,
      this.canPurchase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160, //(screenHeight(context) - 40) / 4.5,
      margin: const EdgeInsets.all(2),
      //decoration: boxDecorationWhite(),
      alignment: Alignment.center,
      child: BackgroundImageBox(
          url: module?.moduleBackground?.imageUrl ?? '',
          colors: [Theme.of(context).primaryColor, Colors.white],
          alignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                module?.name != null && module!.name.length > 0
                    ? Container(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: buildWrappedText(
                          context,
                          module!.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: buildWrappedText(
                    context,
                    module!.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                module!.lessonCount != null
                    ? Container(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Text(
                          Strings.total +
                              ' ' +
                              module!.lessonCount.toString() +
                              ' ' +
                              Strings.lessons,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ))
                    : Container(),
                displayTags(context, module!.tags),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: verticalSpaceTiny,
                    ),
                    isAdmin
                        ? _buildAdminActionIconsRow(context)
                        : _buildUserActionIconsRow(context),
                    horizontalSpaceTiny //TODO // pipulate user controls
                  ],
                ),
                verticalSpace(3),
              ],
            ))
          ]),
    );
  }

  Widget displayTags(BuildContext context, List<String> tags) {
    if (tags != null && tags.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              new Text(
                tags[0],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              new Text(
                tags[3],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              //new Text(tags[2], style: moduleTagTextStyle),
            ],
          ),
          horizontalSpaceSmall,
          Column(
            children: [
              new Text(
                tags[1],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              new Text(
                tags[4],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              //new Text(tags[2], style: moduleTagTextStyle),
            ],
          ),
          horizontalSpaceSmall,
          Column(
            children: [
              new Text(
                tags[2],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              new Text(
                tags[5],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              //new Text(tags[5], style: moduleTagTextStyle),
            ],
          )
        ],
      );
    }
    return Container();
  }

  Row _buildAdminActionIconsRow(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        IconButton(
          color: Theme.of(context).iconTheme.color,
          icon: Icon(Icons.delete),
          tooltip: Tooltips.deleteModule,
          onPressed: () {
            if (onDeleteItem != null) {
              onDeleteItem!();
            }
          },
        ),
        IconButton(
          color: Theme.of(context).iconTheme.color,
          icon: Icon(
            Icons.edit,
          ),
          tooltip: Tooltips.editModule,
          onPressed: () {
            if (onEditItem != null) {
              onEditItem!();
            }
          },
        ),
        BusyButton(
          title: Strings.details,
          onPressed: () {
            if (onEditLessons != null) {
              onEditLessons!();
            }
          },
        ),
        horizontalSpaceSmall,
      ],
    );
  }

  _buildUserActionIconsRow(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        module?.moduleVideo?.videoUrl != null
            ? IconButton(
                color: Theme.of(context).iconTheme.color,
                icon: Icon(Icons.play_arrow_sharp),
                tooltip: Tooltips.playVideo,
                onPressed: () {
                  if (onPlayVideo != null) {
                    onPlayVideo!();
                  }
                },
              )
            : Container(),
        module?.moduleDetailDoc?.docUrl != null
            ? IconButton(
                color: Theme.of(context).iconTheme.color,
                icon: Icon(
                  Icons.picture_as_pdf_sharp,
                ),
                tooltip: Tooltips.viewPdf,
                onPressed: () {
                  if (onViewDoc != null) {
                    onViewDoc!();
                  }
                },
              )
            : Container(),
        BusyButton(
          title: Strings.details,
          onPressed: () {
            if (onEditLessons != null) {
              onEditLessons!();
            }
          },
        ),
        horizontalSpaceSmall,
        canPurchase != null && canPurchase!
            ? BusyButton(
                title: Strings.buy,
                busy: false,
                onPressed: () {
                  if (onPurchase != null) {
                    onPurchase!();
                  }
                },
              )
            : Container(),
      ],
    );
  }
}
