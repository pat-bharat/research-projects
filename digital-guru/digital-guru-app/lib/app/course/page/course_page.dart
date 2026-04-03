import 'package:digital_guru_app/app/common/widget/dg_scaffold.dart';
import 'package:digital_guru_app/app/common/widget/list_items_builder.dart';
import 'package:digital_guru_app/app/course/model/course.dart';
import 'package:digital_guru_app/app/course/provider/course_provider.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursePage extends ConsumerWidget {
  Widget _course(Course course) {
    debugPrint(course.toString());
    return Card(
        elevation: 10,
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(course.title!, style: TextStyle(fontSize: 15)),
              Text(course.instructorName!)
            ],
          ),
          // trailing: Text(author),
          dense: false,
          isThreeLine: true,

          subtitle: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: Text(course.description!)),
        ));
  }

  Widget _courseList(BuildContext context, WidgetRef watch) {
    final coursesAsyncValue = watch.read(coursesStreamProvider);

    return Expanded(
        child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: SizedBox(
                height: 200.0,
                child: ListItemsBuilder<Course>(
                  data: coursesAsyncValue,
                  itemBuilder: (context, course) => Dismissible(
                    key: Key('course-${course.id}'),
                    background: Container(color: Colors.red),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) =>
                        debugPrint(direction.toString()),
                    child: _course(course),
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context, WidgetRef watch) {
    return DGScaffold(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'All courses',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          _courseList(context, watch),
        ],
      ),
    ));
  }
}
