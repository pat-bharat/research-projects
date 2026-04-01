import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _ShowMainBanner = "show_main_banner";

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  final defaults = <String, dynamic>{_ShowMainBanner: false};

  static RemoteConfigService? _instance = null;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: FirebaseRemoteConfig.instance,
      );
    }

    return _instance!;
  }

  RemoteConfigService({required FirebaseRemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  bool get showMainBanner => _remoteConfig.getBool(_ShowMainBanner);

  Future initialise() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } catch (e) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }
}
