import 'package:digiguru/app/AppConfig.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/model/dialog_models.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/user/model/user.dart';
import 'package:digiguru/app/auth/service/authentication_service.dart';
import 'package:digiguru/app/firebase_services/service/remote_config_service.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:digiguru/app/video/service/download_service.dart';
import 'package:flutter/widgets.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  User? get currentUser => BaseService.currentUser;
  Business get currentBusiness => BaseService.currentBusiness;
  bool get isAdmin => BaseService.isAdmin();
  bool get isSystemAdmin => BaseService.isSystemAdmin();
  bool get isConsumerUser => BaseService.isConsumnerUser();
  String get userAuthToken => BaseService.currentUserToken;
  // Since it'll most likely be used in almost every view we expose it here
  bool get showMainBanner => _remoteConfigService.showMainBanner;
  String get baseUploadUrl => _authenticationService.baseUploadUrl;

  bool _busy = false;
  bool get busy => _busy;
  bool isDisposed = false;

  final DownloadService _downloadService = locator<DownloadService>();
  late AppConfig appConfig;
  BaseModel();

  void setBusy(bool value) {
    _busy = value;
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void refresh() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  void signOut() async {
    var result = await _authenticationService.signOff();
    if (result is String) {
      await _dialogService.showDialog(
        title: 'Error!',
        description: "Failed to sign Off!\n" + result.toString(),
      );
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }
  }

  void goBack() {
    _navigationService.pop();
  }

  void viewImage(String url) {
    if (url != null && url.length > 0)
      _navigationService.navigateTo(ViewImageRoute, arguments: url);
  }

  void viewPdf(String url) {
    if (url != null && url.length > 0)
      _navigationService.navigateTo(ViewPdfRoute, arguments: url);
  }

  void viewVideo(VideoInfo video) {
    if (video != null && video.videoUrl != null && video.videoUrl.length > 0) {
      if (video.youtube == null || !video.youtube) {
        _navigationService.navigateTo(ViewVideoRoute,
            arguments: video.videoUrl);
      } else {
        _navigationService.navigateTo(YoutubeVideoRoute,
            arguments: video.videoUrl);
      }
    }
  }

  void downloadVideo(VideoInfo videoInfo) {
    if (!videoInfo.youtube) {
      _downloadService.requestDownload(videoInfo.videoUrl, videoInfo.title);
    }
  }

  void showDownloadQueueView(TargetPlatform platform) {
    _navigationService.navigateTo(ViewDownloadQueueRoute, arguments: platform);
  }

  void showUploadQueueView() {
    _navigationService.navigateTo(ViewUploadQueueRoute);
  }

  Future<bool> confirmDeleteVideo(String fileName) async {
    DialogResponse resp = await _dialogService.showConfirmationDialog(
        title: "Are you sure?", description: "Want to delete " + fileName);
    return resp.confirmed ?? false;
  }
}
