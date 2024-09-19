import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_payment/constants.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        10, "USD"
      ); 

      if (paymentIntentClientSecret == null) {
        print("Failed to create payment intent");
        return;
      }

      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Kennedy Mutugi",
        )
      );
      await _processPayment();
    } catch (e) {
      print("Error making payment: $e");
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType, 
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          }
        )
      );

      if (response.data != null) {
        return response.data["client_secret"];
      }

      return null;
    } catch (e) {
      print("Error creating payment intent: $e");
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print("Error processing payment: $e");
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Stripe requires amount in cents
    return calculatedAmount.toString();
  }
}
