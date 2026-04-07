import 'dart:async' show unawaited;

import 'package:digital_guru_app/app/common/constants/strings.dart';
import 'package:digital_guru_app/app/common/provider/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'alert_helpers.dart';

// ignore: must_be_immutable
class DGScaffold extends ConsumerWidget {
  DGScaffold({this.child});
  Widget? child;

  Future<void> _signOut(BuildContext context, SupabaseClient supabaseClient) async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e as Exception,
      ));
    }
  }

  Future<void> _confirmSignOut(
      BuildContext context, SupabaseClient supabaseClient) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: Strings.logout,
          content: Strings.logoutAreYouSure,
          cancelActionText: Strings.cancel,
          defaultActionText: Strings.logout,
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context, supabaseClient);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef watch) {
    final supabaseClient = watch.read(supabaseClientProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("Digital Guru"),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(Icons.logout, size: 30),
                  onPressed: () => _confirmSignOut(context, supabaseClient),
                ))
          ],
        ),
        body: child);
  }
}
