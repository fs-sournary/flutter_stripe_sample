import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_sample/data/config.dart';
import 'package:flutter_stripe_sample/widget/loading_button.dart';
import 'package:flutter_stripe_sample/widget/response_card.dart';
import 'package:flutter_stripe_sample/extension/map_extension.dart';
import 'package:http/http.dart' as http;

class NoWebhookCardPaymentPage extends StatefulWidget {
  const NoWebhookCardPaymentPage({super.key});

  @override
  State<NoWebhookCardPaymentPage> createState() {
    return _NoWebhookCardPaymentPageState();
  }
}

class _NoWebhookCardPaymentPageState extends State<NoWebhookCardPaymentPage> {
  final _controller = CardEditController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Field - No webhook'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardField(controller: _controller),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                child: LoadingButton(
                  onPressed: _controller.complete ? _handlePayment : null,
                  text: 'Pay',
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: ResponseCard(
                  response: _controller.details.toJson().toPrettyString(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    try {
      // 1. Gather custom billing information. Mock data.
      const billingDetails = BillingDetails(
        email: 'stripesample@gmail.com',
        name: 'Test',
        phone: '+48888000888',
        address: Address(
          city: 'Chicago',
          country: 'US',
          line1: '1234 Circle Park',
          line2: '',
          postalCode: '77063',
          state: 'Texas',
        ),
      );
      // 2. Create payment method.
      const params = PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
      );
      final paymentMethod = await Stripe.instance.createPaymentMethod(params);
      // 3. Call API to create a PaymentIntent
      final paymentMethodResult = await _callPaymentMethodApi(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'usd',
        items: ['id-1'],
      );
      // 4. Handle error If calling the payment method api failed;
      if (paymentMethodResult['error'] != null && mounted) {
        final snackBar = SnackBar(
          content:
              Text('Payment method error: ${paymentMethodResult['error']}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      // 5. Handle if the payment succeeded. See server/src/utils.ts
      if (paymentMethodResult['clientSecret'] != null &&
          paymentMethodResult['requiresAction'] == null &&
          mounted) {
        const snackBar = SnackBar(
          content: Text('Succeeded. Your payment was confirmed successfully'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      // 6. Handle if the payment requires an action.
      if (paymentMethodResult['clientSecret'] != null &&
          paymentMethodResult['requiresAction'] == true) {
        final paymentIntent = await Stripe.instance.handleNextAction(
          paymentMethodResult['clientSecret'],
        );
        // 7. Call confirm API
        if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
          await _callConfirmIntentApi(paymentIntent.id);
        }
      }
    } catch (e) {
      final snackBar = SnackBar(content: Text('Error: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<Map<String, dynamic>> _callPaymentMethodApi({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<String>? items,
  }) async {
    final url = Uri.parse('$apiUrl/pay-without-webhooks');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'items': items,
      }),
    );
    return json.decode(response.body);
  }

  Future<void> _callConfirmIntentApi(String paymentIntentId) async {
    final url = Uri.parse('$apiUrl/charge-card-off-session');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'paymentIntentId': paymentIntentId}),
    );
    final responseBody = json.decode(response.body);
    if (!mounted) return;
    if (responseBody['error'] != null) {
      final snackBar = SnackBar(
        content: Text('Confirm intent error: ${responseBody['error']}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(
        content: Text('Success!: The payment was confirmed successfully!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_update);
    _controller.dispose();
    super.dispose();
  }

  void _update() => setState(() {});
}
