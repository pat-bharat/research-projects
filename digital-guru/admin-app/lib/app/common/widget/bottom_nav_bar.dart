import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:flutter/material.dart';

final NavigationService _navigationService = locator<NavigationService>();

businessBottomNavBar(BuildContext context, int index) {
  return ConvexAppBar(
    items: [
      TabItem(icon: Icons.business, title: Strings.settings),
      // TabItem(icon: Icons.money, title: Strings.invoices),
      TabItem(icon: Icons.pages, title: Strings.courses),
      TabItem(icon: Icons.people, title: Strings.instructors),
      // TabItem(icon: Icons.message, title: Strings.legals),
      TabItem(icon: Icons.people, title: Strings.trialPackages),
    ],
    top: 0,
    height: 55,
    backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
    color: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme?.color,
    initialActiveIndex: index,
    //optional, default as 0
    onTap: ((int index) => {
          if (index == 0)
            _navigationService.navigateTo(BusinessDashboardViewRoute)
          else if (index == 1)
            _navigationService.navigateTo(CourseViewListRoute)
          else if (index == 2)
            _navigationService.navigateTo(InstructorListViewRoute)
          else if (index == 3)
            _navigationService.navigateTo(FreeUserModuleListRoute)
          else
            {
              _navigationService.navigateTo(CourseViewListRoute,
                  arguments: true)
            }
        }),
  );
}

systemBottomNavBar(BuildContext context, int index) {
  return ConvexAppBar(
    items: [
      TabItem(icon: Icons.business, title: Strings.settings),
      // TabItem(icon: Icons.money, title: Strings.invoices),
      TabItem(icon: Icons.pages, title: Strings.busineses),
    ],
    top: 0,
    height: 55,
    backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
    color: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme?.color,
    initialActiveIndex: index,
    //optional, default as 0
    onTap: ((int index) => {
          if (index == 0)
            _navigationService.navigateTo(SystemProfileViewRoute)
          else if (index == 1)
            _navigationService.navigateTo(SystemBusinessManagementViewRoute)
          else
            {
              _navigationService.navigateTo(SystemProfileViewRoute,
                  arguments: true)
            }
        }),
  );
}

consumerBottomNavBar(BuildContext context, int index) {
  return ConvexAppBar(
    items: [
      //TabItem(icon: Icons.business, title: Strings.settings),
      // TabItem(icon: Icons.money, title: Strings.invoices),
      TabItem(icon: Icons.pages, title: Strings.courses),
      // TabItem(icon: Icons.people, title: Strings.instructors),
      // TabItem(icon: Icons.message, title: Strings.legals),
      TabItem(icon: Icons.people, title: Strings.trialPackages),
      TabItem(icon: Icons.people, title: Strings.trialPackages),
    ],
    top: -15,
    height: 55,
    backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
    color: Theme.of(context).bottomNavigationBarTheme.selectedIconTheme?.color,
    initialActiveIndex: index,
    //optional, default as 0
    onTap: ((int index) => {
          if (index == 0)
            _navigationService.navigateTo(CourseViewListRoute)
          else if (index == 1)
            _navigationService.navigateTo(FreeUserModuleListRoute,
                arguments: true)
          else if (index == 2)
            _navigationService.navigateTo(FreeUserModuleListRoute,
                arguments: false)
          else
            {
              _navigationService.navigateTo(CourseViewListRoute,
                  arguments: true)
            }
        }),
  );
}
