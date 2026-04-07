import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:digiguru/app/common/service/base_service.dart';

class PurchaseService extends BaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final List<String> _productIds = Platform.isAndroid
      ? ['android.test.purchased', 'point_1000', '5000_point', 'android.test.canceled']
      : ['com.cooni.point1000', 'com.cooni.point5000'];

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool? simulated = true;

PurchaseService({this.simulated});
  Future<void> initPurchaseService() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      print('In-app purchases not available');
      return;
    }
    await _loadProducts();
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print('Purchase stream error: $error');
    });
  }

  Future<void> _loadProducts() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails(_productIds.toSet());
    if (response.error != null) {
      print('Product query error: ${response.error}');
      return;
    }
    _products = response.productDetails;
  }

  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;
  
  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    // For consumables, use: await _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    _purchases = purchaseDetailsList;
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Verify purchase and deliver product
        _verifyAndDeliver(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        print('Purchase error: ${purchase.error}');
      }
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> _verifyAndDeliver(PurchaseDetails purchase) async {
    // TODO: Verify purchase with your backend and deliver the product
    print('Purchase verified: ${purchase.productID}');
  }
/*
  Future<List<PurchaseDetails>> getPastPurchases() async {
    final QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    if (response.error != null) {
      print('Past purchase query error: ${response.error}');
      return [];
    }
    _purchases = response.pastPurchases;
    return _purchases;
  }
*/
  void dispose() {
    _subscription.cancel();
  }
}