import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loyalties/providers/loyalties_provider.dart';
import 'package:loyalties/screens/loyalty_add.dart';
import 'package:loyalties/screens/loyalty_detail.dart';

class LoyaltiesScreen extends ConsumerWidget {
  const LoyaltiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(loyaltiesProvider.notifier).loadLoyalties();

    Widget content = Center(
      child: Text(
        'No loyalties found. Add one!',
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: const Color.fromARGB(255, 255, 177, 193),
            ),
      ),
    );

    final loyalties = ref.watch(loyaltiesProvider);
    if (loyalties.isNotEmpty) {
      content = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final loyalty in loyalties)
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoyaltyDetailScreen(
                      loyalty: loyalty,
                    ),
                  ),
                );
              },
              child: Dismissible(
                key: Key(loyalty.id),
                onDismissed: (direction) {
                  ref
                      .read(loyaltiesProvider.notifier)
                      .removeLoyalty(loyalty.id);
                },
                child: Card(
                  child: ListTile(
                    title: Text(loyalty.store),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: FileImage(loyalty.image),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your loyalties'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoyaltyAddScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
