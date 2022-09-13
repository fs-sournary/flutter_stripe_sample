import 'package:flutter/material.dart';

enum DevicePlatform { ios, android, web }

extension on DevicePlatform {
  IconData get icon {
    switch (this) {
      case DevicePlatform.android:
        return Icons.android;
      case DevicePlatform.ios:
        return Icons.apple;
      default:
        return Icons.web;
    }
  }
}

class PlatformIcons extends StatelessWidget {
  const PlatformIcons({super.key, required this.supportedPlatforms});

  final List<DevicePlatform> supportedPlatforms;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final platform in DevicePlatform.values) ...[
          _Icon(supportPlatforms: supportedPlatforms, platform: platform),
          const SizedBox(width: 8),
        ]
      ],
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.supportPlatforms,
    required this.platform,
  });

  final List<DevicePlatform> supportPlatforms;
  final DevicePlatform platform;

  @override
  Widget build(BuildContext context) {
    final isSupported = supportPlatforms.contains(platform);
    final color = isSupported ? Colors.green[400] : Colors.red[400];
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(platform.icon, color: Colors.white),
    );
  }
}
