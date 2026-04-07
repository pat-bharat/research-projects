import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:flutter/material.dart';

class BusinessDrawer extends StatefulWidget {
  @override
  _BusinessDrawerState createState() => _BusinessDrawerState();
}

class _BusinessDrawerState extends State<BusinessDrawer> {
  final NavigationService _navigationService = locator<NavigationService>();
  late bool isAdmin;
  @override
  void initState() {
    super.initState();
    isAdmin = true;
  }

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
              backgroundImage: new AssetImage('assets/images/logo.png'),
            ),
          ),
          new ListTile(
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              _navigationService.navigateTo(UserProfileViewRoute);
            },
          ),
          new ListTile(
            title: Text(
              "Dashboard",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              _navigationService.navigateTo(BusinessDashboardViewRoute);
            },
          ),
          new ListTile(
            title: Text(
              "Upload Status",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: Icon(
              Icons.upload_sharp,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              _navigationService.navigateTo(ViewUploadQueueRoute);
            },
          ),
          ListTile(
            title: Text(
              "Download Status",
              style: Theme.of(context).textTheme.bodyMedium,
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
          isAdmin
              ? ListTile(
                  title: Text(
                    "Preview as User",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: () {
                    setState(() {
                      BaseService.currentUser?.userRole = UserRole.user;
                      BaseService.isPreviewAsUser = true;
                      isAdmin = true;
                      _navigationService.navigateTo(HomeViewRoute);
                    });
                  },
                )
              : ListTile(
                  title: Text(
                    "Preview as Admin",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: () {
                    setState(() {
                      isAdmin = false;
                      BaseService.currentUser?.userRole = UserRole.admin;
                      _navigationService.navigateTo(HomeViewRoute);
                    });
                  },
                ),
          ListTile(
            title: Text(
              "Preview as System Admin",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              setState(() {
                BaseService.currentUser?.userRole = "System";
                _navigationService.navigateTo(HomeViewRoute);
              });
            },
          ),
          ListTile(
            title: Text(
              "View Invoices",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: Icon(
              Icons.pages,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              _navigationService.navigateTo(BusinessInvoiceListViewRoute);
            },
          ),
          ListTile(
            title: Text(
              "Manage Legals",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: Icon(
              Icons.dock,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              _navigationService.navigateTo(BusinessLegalListViewRoute);
            },
          ),
          new ListTile(
            title: Text(
              Strings.aboutUs,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: Icon(
              Icons.people,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          new ListTile(
            title: Text(
              Strings.logout,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          // Divider(),
          // MyAboutTile()
        ],
      ),
    );
  }
}
