import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//import 'utils/constants.dart';
/// TODO: update with your custom SCHEME and HOSTNAME
const myAuthRedirectUri = 'io.supabase.flutterdemo://login-callback';

/// TODO: Add your SUPABASE_URL / SUPABASE_KEY here
const supabaseUrl = 'SUPABASE_URL';
const supabaseAnnonKey = 'SUPABASE_KEY';
Future configureApp() async {
  // init Supabase singleton
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
    authOptions: FlutterAuthClientOptions(
      autoRefreshToken: true,
      localStorage: SecureLocalStorage(),
      detectSessionInUri: true,
    ),
    debug: false,
    postgrestOptions: PostgrestClientOptions(schema: 'digital_guru'),
  );
}

// user flutter_secure_storage to persist user session
class SecureLocalStorage extends LocalStorage {
  SecureLocalStorage();       
          @override
          Future<String?> accessToken() {
             const storage = FlutterSecureStorage();
            return storage.read(key: supabasePersistSessionKey);
          }
        
          @override
          Future<bool> hasAccessToken() {
            const storage = FlutterSecureStorage();
            return storage.containsKey(key: supabasePersistSessionKey);
          }
        
          @override
          Future<void> initialize() {
            // TODO: implement initialize
            throw UnimplementedError();
          }
        
          @override
          Future<void> persistSession(String persistSessionString) {
                        const storage = FlutterSecureStorage();
            return storage.write(key: supabasePersistSessionKey, value: persistSessionString);

          }
        
          @override
          Future<void> removePersistedSession() {
            const storage = FlutterSecureStorage();
            return storage.delete(key: supabasePersistSessionKey);
         }
}
