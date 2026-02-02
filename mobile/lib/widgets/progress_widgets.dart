import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

/// A reusable progress indicator widget
class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final String? label;
  final Color? color;
  final double height;

  const ProgressIndicatorWidget({
    Key? key,
    required this.progress,
    this.label,
    this.color,
    this.height = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color ?? FitolaTheme.primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: height,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? FitolaTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// A circular progress widget with percentage text
class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final String? label;
  final Color? color;
  final double size;
  final double strokeWidth;

  const CircularProgressWidget({
    Key? key,
    required this.progress,
    this.label,
    this.color,
    this.size = 80,
    this.strokeWidth = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: strokeWidth,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? FitolaTheme.primaryColor,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color ?? FitolaTheme.primaryColor,
                    ),
              ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label!,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
