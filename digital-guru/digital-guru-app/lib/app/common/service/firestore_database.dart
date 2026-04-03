// This file is now deprecated. Use FirebaseFirestore.instance directly throughout your app.
// If you need a helper for document IDs:
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
