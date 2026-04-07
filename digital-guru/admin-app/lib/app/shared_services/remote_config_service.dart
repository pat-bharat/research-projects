import 'package:supabase_flutter/supabase_flutter.dart';

const String _ShowMainBanner = "show_main_banner";
const String _ConfigTable = "app_config";

class RemoteConfigService {
  static RemoteConfigService? _instance;
  final SupabaseClient _client = Supabase.instance.client;
  Map<String, dynamic> _config = {};

  static Future<RemoteConfigService> getInstance() async {
    _instance ??= RemoteConfigService();
    await _instance!.initialise();
    return _instance!;
  }

  bool get showMainBanner => _config[_ShowMainBanner] ?? false;

  Future initialise() async {
    try {
      final response = await _client.from(_ConfigTable).select().single();
      _config = response;
    } catch (e) {
      print(
          'Unable to fetch remote config from Supabase. Default values will be used.');
      _config = {_ShowMainBanner: false};
    }
  }
}
