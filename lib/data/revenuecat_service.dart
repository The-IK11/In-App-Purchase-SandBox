import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenuecatService {
  RevenuecatService._internal();

  static final RevenuecatService _instance = RevenuecatService._internal();

  factory RevenuecatService() {
    return _instance;
  }

  static const bool mockMode = true;

  Future<void> init() async {
    if (mockMode) return;

    await Purchases.setLogLevel(LogLevel.debug);

    if (Platform.isIOS) {
      await Purchases.configure(
        PurchasesConfiguration("test_psDZiLltJmQsgVXcDRSRXcUDgBu"),
      );
    } else {
      await Purchases.configure(
        PurchasesConfiguration("test_psDZiLltJmQsgVXcDRSRXcUDgBu"),
      );
    }
  }

  Future<bool> purchasePremium() async {
    if (mockMode) {
      await Future.delayed(const Duration(seconds: 1));
      return true; // fake success
    }

    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.monthly;

      if (package == null) {
        throw Exception("No package found");
      }

      final purchaseResult = await Purchases.purchasePackage(package);
      final customerInfo = purchaseResult.customerInfo;

      return customerInfo.entitlements.active.containsKey("premium");
    } catch (e) {
      rethrow;
    }
  }
}
