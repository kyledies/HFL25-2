import 'package:flutter/material.dart';
import 'package:flutter_modern_animated_loader/flutter_animated_loader.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final String? label;

  const AppLoader({
    super.key,
    this.size = 64,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterAnimatedLoader.arcTrio(
          color: cs.primary,
          size: size,
        ),
        if (label != null) ...[
          const SizedBox(height: 12),
          Text(
            label!,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.8)),
          ),
        ],
      ],
    );
  }
}
