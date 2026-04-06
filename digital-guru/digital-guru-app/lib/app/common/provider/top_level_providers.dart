//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';

final supabaseClientProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange.map((event) => event.session?.user));

final databaseProvider = Provider<SupabaseClient>((ref) {
  // Optionally, you can use auth if you need user-specific logic
  // final auth = ref.watch(authStateChangesProvider);
  return Supabase.instance.client;
});

final loggerProvider = Provider<Logger>((ref) => Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printEmojis: false,
      ),
    ));
