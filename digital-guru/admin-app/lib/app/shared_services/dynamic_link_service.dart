import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleDynamicLinks() async {
    // Get the initial dynamic link if the app is opened with a dynamic link
   // final PendingDynamicLinkData? data =
    //    await FirebaseDynamicLinks.instance.getInitialLink();

    // handle link that has been retrieved
    //_handleDeepLink(data);

    // Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    //FirebaseDynamicLinks.instance.onLink.listen(
    //    (PendingDynamicLinkData dynamicLink) async {
    //  // handle link that has been retrieved
    //  _handleDeepLink(dynamicLink);
    //}, onError: (exception) async {
    //  print('Link Failed: $exception');
    //});
  }
/**
  void _handleDeepLink(PendingDynamicLinkData? data) {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      var isPost = deepLink.pathSegments.contains('post');
      if (isPost) {
        var title = deepLink.queryParameters['title'];
        if (title != null) {
          _navigationService.navigateTo(CreateCourseViewRoute,
              arguments: title);
        }
      }
    }
  }
*/
  Future<String> createFirstPostLink(String title) async {
   /** final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://filledstacks.page.link',
      link: Uri.parse('https://www.digiguru.com/post?title=$title'),
      androidParameters: AndroidParameters(
        packageName: 'com.filledstacks.digiguru',
      ),

      // Other things to add as an example. We don't need it now
      iosParameters: const IOSParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final dynamicUrl = await FirebaseDynamicLinks.instance.buildLink(parameters);
*/
    //return dynamicUrl.toString();
    return "";
  }
}
