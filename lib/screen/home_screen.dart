import 'package:flutter/material.dart';
import 'package:flutter_stripe_sample/screen/card_payment/card_field_theme_page.dart';
import 'package:flutter_stripe_sample/screen/card_payment/card_form_page.dart';
import 'package:flutter_stripe_sample/screen/card_payment/custom_card_payment_page.dart';
import 'package:flutter_stripe_sample/screen/card_payment/no_webhook_card_payment_page.dart';
import 'package:flutter_stripe_sample/screen/payment_sheet/custom_flow_page.dart';
import 'package:flutter_stripe_sample/screen/payment_sheet/single_step_page.dart';
import 'package:flutter_stripe_sample/screen/wallet/apple_pay_page.dart';
import 'package:flutter_stripe_sample/screen/wallet/apple_pay_plugin_page.dart';
import 'package:flutter_stripe_sample/screen/wallet/apple_pay_setup_page.dart';
import 'package:flutter_stripe_sample/screen/wallet/google_pay_page.dart';
import 'package:flutter_stripe_sample/screen/wallet/google_pay_plugin_page.dart';
import 'package:flutter_stripe_sample/widget/platform_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _applePayPath = 'assets/apple_pay.png';
  static const _googlePayPath = 'assets/google_play.png';

  static final _items = [
    _Item(
      title: 'Payment Sheet',
      children: [
        _ItemTile(
          title: 'Single step',
          supportedPlatforms: const [
            DevicePlatform.ios,
            DevicePlatform.android,
          ],
          builder: (context) => const SingleStepPage(),
        ),
        _ItemTile(
          title: 'Custom Flow',
          supportedPlatforms: const [
            DevicePlatform.ios,
            DevicePlatform.android,
          ],
          builder: (context) => const CustomFlowPage(),
        ),
      ],
    ),
    _Item(
      title: 'Card Payments',
      children: [
        // _ItemTile(
        //   title: 'Simple - Using webhooks',
        //   supportedPlatforms: const [
        //     DevicePlatform.android,
        //     DevicePlatform.ios,
        //     DevicePlatform.web,
        //   ],
        //   builder: (context) => const WebhookCardPaymentPage(),
        // ),
        _ItemTile(
          title: 'Without webhook',
          supportedPlatforms: const [
            DevicePlatform.ios,
            DevicePlatform.android,
            DevicePlatform.web
          ],
          builder: (context) => const NoWebhookCardPaymentPage(),
        ),
        _ItemTile(
          title: 'Card Field themes',
          supportedPlatforms: const [
            DevicePlatform.ios,
            DevicePlatform.android,
            DevicePlatform.web,
          ],
          builder: (context) => const CardFieldThemePage(),
        ),
        _ItemTile(
          title: 'Card Form',
          supportedPlatforms: const [
            DevicePlatform.ios,
            DevicePlatform.android,
            DevicePlatform.web
          ],
          builder: (context) => const CardFormPage(),
        ),
        _ItemTile(
          title: 'Flutter UI (not PCI compliant)',
          supportedPlatforms: const [
            DevicePlatform.ios,
            DevicePlatform.android,
          ],
          builder: (context) => const CustomCardPaymentPage(),
        ),
      ],
    ),
    _Item(
      title: 'Wallets',
      children: [
        _ItemTile(
          title: 'Apple pay',
          supportedPlatforms: const [DevicePlatform.ios],
          builder: (context) => const ApplePayPage(),
          leading: Image.asset(_applePayPath, width: 48),
        ),
        _ItemTile(
          title: 'Apple Pay - Pay Plugin',
          supportedPlatforms: const [DevicePlatform.ios],
          builder: (context) => const ApplePayPluginPage(),
          leading: Image.asset(_applePayPath, width: 48),
        ),
        _ItemTile(
          title: 'Open Apple Pay setup',
          supportedPlatforms: const [DevicePlatform.ios],
          builder: (context) => const ApplePaySetupPage(),
          leading: Image.asset(_applePayPath, width: 48),
        ),
        _ItemTile(
          title: 'Google Pay',
          supportedPlatforms: const [DevicePlatform.android],
          builder: (context) => const GooglePayPage(),
          leading: Image.asset(_googlePayPath, width: 48),
        ),
        _ItemTile(
          title: 'Google Pay - Pay Plugin',
          supportedPlatforms: const [DevicePlatform.android],
          builder: (context) => const GooglePayPluginPage(),
          leading: Image.asset(_googlePayPath, width: 48),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter stripe'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => _items[index],
        itemCount: _items.length,
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: children,
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.title,
    required this.supportedPlatforms,
    required this.builder,
    this.leading,
  });

  final String title;
  final List<DevicePlatform> supportedPlatforms;
  final Widget? leading;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final route = MaterialPageRoute(builder: builder);
        Navigator.push(context, route);
      },
      leading: leading,
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformIcons(supportedPlatforms: supportedPlatforms),
          const Icon(Icons.chevron_right_rounded)
        ],
      ),
    );
  }
}
