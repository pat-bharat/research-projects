import 'package:digiguru/app/common/service/base_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class PurchaseService extends BaseService {
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  StreamSubscription? _conectionSubscription;
  final List<String> _productLists = Platform.isAndroid
      ? [
          'android.test.purchased',
          'point_1000',
          '5000_point',
          'android.test.canceled',
        ]
      : ['com.cooni.point1000', 'com.cooni.point5000'];

  String _platformVersion = 'Unknown';
  List<Purchase> _purchases = [];
  List<Purchase> _purchasesHistory = [];
  List<Purchase> _items = [];

  bool simulated = true;
  Future<void> initPurchaseService() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // refresh items for android
    try {
      var products = await FlutterInappPurchase.instance.getAvailablePurchases();
      _items = products;
    } catch (err) {
      print('getProducts error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.instance.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.instance.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.instance.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
  }

  Future requestPurchase(Purchase item) async {
    final props = Platform.isIOS
        ? RequestPurchaseIosProps(sku: item.productId) as RequestPurchaseProps
        : RequestPurchaseAndroidProps(skus: List.of([item.productId])) as RequestPurchaseProps;
    return await FlutterInappPurchase.instance.requestPurchase(props);
  }

  Future getProducts() async {
    return this._productLists;
  }

  Future getPurchases() async {
    List<Purchase> items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items) {
      print('${item.toString()}');
      this._purchases.add(item);
    }
    return this._purchases;
  }

  Future getPurchaseHistory() async {
    List<Purchase> items =
        await FlutterInappPurchase.instance.getAvailablePurchases() ?? [];
    for (var item in items) {
      print('${item.toString()}');
      this._purchasesHistory.add(item);
    }

    return _purchasesHistory;
  }
}
