import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key, required this.onPressed, required this.text});

  final Future Function()? onPressed;
  final String text;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (_isLoading || widget.onPressed == null) ? null : _loadFuture,
      child: _isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(widget.text),
    );
  }

  Future<void> _loadFuture() async {
    setState(() => _isLoading = true);
    try {
      await widget.onPressed?.call();
    } catch (e) {
      final snackBar = SnackBar(content: Text('Error: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
