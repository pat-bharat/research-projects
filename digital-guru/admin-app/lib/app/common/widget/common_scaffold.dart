import 'package:digiguru/app/common/widget/app_bars.dart';
import 'package:digiguru/app/common/widget/bottom_nav_bar.dart';
import 'package:digiguru/app/common/widget/business_drawer.dart';
import 'package:digiguru/app/common/widget/user_drawer.dart';
import 'package:flutter/material.dart';

class CommonScaffold extends StatefulWidget {
  final appTitle;
  final Widget? bodyData;
  final showAppbar;
  final showDrawer;
  final scaffoldKey;
  final showBottomNav;
  final elevation;
  final dynamic model;
  final bottomNavBarIndex;
  CommonScaffold({
    this.appTitle,
    required this.model,
    this.bodyData,
    this.showAppbar = true,
    this.showDrawer = true,
    this.scaffoldKey,
    this.showBottomNav = true,
    this.elevation = 4.0,
    this.bottomNavBarIndex = 2,
    required Center body,
  });

  @override
  _CommonScaffoldState createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        key: widget.scaffoldKey != null ? widget.scaffoldKey : null,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: widget.model.isAdmin && widget.showAppbar
            ? buildBusinessAppBar(
                context,
                widget.model,
                widget.appTitle,
              )
            : widget.model.isSystemAdmin
                ? buildSystemAppBar(context, widget.model, widget.appTitle)
                : buildUserAppBar(context, widget.model, widget.appTitle),
        drawer: (widget.showDrawer)
            ? (widget.model.isAdmin
                ? BusinessDrawer()
                : UserDrawer(widget.model))
            : null,
        body: widget.bodyData,
        bottomNavigationBar: widget.model.isAdmin && widget.showBottomNav
            ? businessBottomNavBar(context, widget.bottomNavBarIndex)
            : widget.model.isSystemAdmin
                ? systemBottomNavBar(context, widget.bottomNavBarIndex)
                : null);
  }
}
