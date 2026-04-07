import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void backgroundHandler() {
  WidgetsFlutterBinding.ensureInitialized();

  // Notice these instances belong to a forked isolate.

  // Supabase Storage does not support background uploads in isolates directly.
  // If you want to show notifications on upload completion, trigger them from the main isolate after upload completes.
  // This file can be used for notification helpers if needed.
}