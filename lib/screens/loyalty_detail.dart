import 'package:flutter/material.dart';

import 'package:loyalties/models/loyalty.dart';

class LoyaltyDetailScreen extends StatelessWidget {
  const LoyaltyDetailScreen({super.key, required this.loyalty});

  final Loyalty loyalty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(loyalty.store),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: FileImage(loyalty.image)),
          const SizedBox(
            height: 14,
          ),
          Text(
            loyalty.store,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: const Color.fromARGB(255, 255, 177, 193),
                ),
          ),
        ],
      ),
    );
  }
}
