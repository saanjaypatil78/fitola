import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

/// A reusable info dialog widget
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final String buttonText;

  const InfoDialog({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.buttonText = 'OK',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? FitolaTheme.primaryColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(title),
          ),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Show the info dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        buttonText: buttonText,
      ),
    );
  }
}

/// A reusable confirm dialog widget
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final String confirmText;
  final String cancelText;
  final bool isDangerous;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDangerous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ??
                  (isDangerous ? FitolaTheme.errorColor : FitolaTheme.primaryColor),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(title),
          ),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isDangerous ? FitolaTheme.errorColor : FitolaTheme.primaryColor,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Show the confirm dialog and return the result
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        confirmText: confirmText,
        cancelText: cancelText,
        isDangerous: isDangerous,
      ),
    );
    return result ?? false;
  }
}

/// A reusable input dialog widget
class InputDialog extends StatefulWidget {
  final String title;
  final String message;
  final String? initialValue;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const InputDialog({
    Key? key,
    required this.title,
    required this.message,
    this.initialValue,
    this.hintText = '',
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  State<InputDialog> createState() => _InputDialogState();

  /// Show the input dialog and return the entered value
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? initialValue,
    String hintText = '',
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    int? maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => InputDialog(
        title: title,
        message: message,
        initialValue: initialValue,
        hintText: hintText,
        confirmText: confirmText,
        cancelText: cancelText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}

class _InputDialogState extends State<InputDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (widget.validator != null) {
      final error = widget.validator!(_controller.text);
      if (error != null) {
        setState(() => _errorText = error);
        return;
      }
    }
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: _errorText,
            ),
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            autofocus: true,
            onSubmitted: (_) => _onConfirm(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText),
        ),
        ElevatedButton(
          onPressed: _onConfirm,
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
