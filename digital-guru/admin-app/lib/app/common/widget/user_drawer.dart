import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatefulWidget {
  dynamic model;
  UserDrawer(this.model);
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              BaseService.currentUser?.fullName ?? '',
            ),
            accountEmail: Text(BaseService.currentUser?.email ?? ''),
            currentAccountPicture: new CircleAvatar(
              backgroundImage:
                  new AssetImage('assets/images/blank_profile.png'),
            ),
          ),
          new ListTile(
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              _navigationService.navigateTo(UserProfileViewRoute);
            },
          ),
          ListTile(
            title: Text(
              "Download Status",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Icon(
              Icons.download_sharp,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              _navigationService.navigateTo(ViewDownloadQueueRoute,
                  arguments: Theme.of(context).platform);
            },
          ),
          ListTile(
            title: Text(
              "Preview as Admin",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              setState(() {
                BaseService.currentUser?.userRole = "Admin";
                _navigationService.navigateTo(HomeViewRoute);
              });
            },
          ),
          ListTile(
            title: Text(
              "Trial Lessons",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Icon(
              Icons.playlist_add_check_sharp,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              setState(() {
                _navigationService.navigateTo(FreeUserModuleListRoute);
              });
            },
          ),
          ListTile(
            title: Text(
              "My Packages",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Icon(
              Icons.playlist_add_check_sharp,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              setState(() {
                _navigationService.navigateTo(PurchasedUserModuleListRoute);
              });
            },
          ),
          new ListTile(
            title: Text(
              Strings.settings,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          new ListTile(
            title: Text(
              Strings.aboutUs,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Icon(
              Icons.people,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          new ListTile(
            title: Text(
              Strings.logout,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              setState(() {
                widget.model.signOut();
              });
            },
          ),
        ],
      ),
    );
  }
}
