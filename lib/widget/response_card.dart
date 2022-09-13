import 'package:flutter/material.dart';

class ResponseCard extends StatelessWidget {
  const ResponseCard({super.key, required this.response});

  final String response;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'RESPONSE',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Text(response),
          )
        ],
      ),
    );
  }
}
