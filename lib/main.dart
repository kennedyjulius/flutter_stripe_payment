import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_payment/constants.dart';
import 'package:flutter_stripe_payment/home_page.dart';

Future<void> main() async {
  await _setup();
  runApp(const MyApp());
}

Future<void>_setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51Q0eMj1V05v2ARTpR1lIxMQpJgDkVUPF5W9AJ7LCmp6AikYXzlfCZRlxpQ24Jz1J1pYUsNPG0CRw3Eq0t7xIqx1J0025nIPdDR";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
     
        useMaterial3: true,
      ),
      home: const HomePage()
    );
  }
}
