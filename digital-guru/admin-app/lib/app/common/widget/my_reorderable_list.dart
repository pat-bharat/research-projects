import 'package:flutter/material.dart';

class MyReorderableListView extends StatefulWidget {
  final List<dynamic> list;
  final List<Widget> children;
  MyReorderableListView({required this.list, required this.children});

  @override
  _MyReorderableListViewState createState() => _MyReorderableListViewState();
}

class _MyReorderableListViewState extends State<MyReorderableListView> {
  @override
  void initState() {
    super.initState();
  }

  void reorderData(int oldindex, int newindex) {
    if (widget.list.isNotEmpty) {
      setState(() {
        if (newindex > oldindex) {
          newindex -= 1;
        }
        widget.list.insert(newindex, widget.list.removeAt(oldindex));
      });
    }
  }

  void sorting() {
    setState(() {
      widget.list.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ReorderableListView(
      children: widget.children,
      onReorder: reorderData,
    );
  }
}
