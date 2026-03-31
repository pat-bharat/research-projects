import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:flutter/material.dart';

class InstructorItem extends StatelessWidget {
  final Instructor instructor;
  final Function onDeleteItem;
  final Function onEditItem;
  final Function onEditModules;
  final bool isAdmin;

  const InstructorItem(
      {Key key,
      this.instructor,
      this.onDeleteItem,
      this.onEditItem,
      this.onEditModules,
      this.isAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: lesson.videoInfo != null ? null : 60,
      // margin: const EdgeInsets.only(right: 10, top: 5),
      alignment: Alignment.center,
      child: _buildInstructorPanel(context, instructor),
    );
  }

  _buildInstructorPanel(BuildContext context, Instructor instructor) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      // padding: EdgeInsets.all(5.0),
      // height: MediaQuery.of(context).size.height / 10,
      decoration: boxDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 80,
            height: 80,
            child: instructor.profilePic != null &&
                    instructor.profilePic.length > 0
                ? buildCachedNetworkCacheImage(context, instructor.profilePic)
                : Container(
                    child: Icon(Icons.person_rounded, size: 60),
                    padding: EdgeInsets.all(10),
                    //decoration: linearGradient(shape: BoxShape.circle)
                  ),
          ),
          /*: SizedBox(
                  width: 80,
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.fill,
                  )),*/
          horizontalSpaceMedium,
          Expanded(
            child: Text(instructor.fullName,
                style: Theme.of(context).textTheme.headline3),
          ),
          isAdmin
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          iconSize: Theme.of(context).iconTheme.size,
                          onPressed: () {
                            if (onDeleteItem != null) {
                              onDeleteItem();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          iconSize: Theme.of(context).iconTheme.size,
                          onPressed: () {
                            if (onEditItem != null) {
                              onEditItem();
                            }
                          },
                        )
                      ],
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}
