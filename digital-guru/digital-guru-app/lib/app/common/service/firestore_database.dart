import 'package:firestore_service/firestore_service.dart';
import 'package:meta/meta.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  late final FirestoreService _service = FirestoreService.instance;

  FirestoreService get service => _service;
}
