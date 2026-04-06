import 'dart:async';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/shared_services/supabase_data_service.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:flutter/services.dart';

class BusinessLegalService extends BaseService {
  final supabaseDataService = SupabaseDataService();
  Future getConsumerLegals() async {
    try {
      List<SystemLegal> legals = new List.empty(growable: true);
      var userData = await supabaseDataService.fetchAll('business_legals');

      userData.forEach((legal) =>
          legals.add(SystemLegal.fromJson(legal['id'], legal)));
      return legals;
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        print(e);
        return List.empty(growable: true);
      }

      return List.empty(growable: true);
    }
  }
}
