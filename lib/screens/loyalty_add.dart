import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loyalties/providers/loyalties_provider.dart';
import 'package:loyalties/models/loyalty.dart';
import 'package:loyalties/widgets/image_input.dart';

class LoyaltyAddScreen extends ConsumerStatefulWidget {
  const LoyaltyAddScreen({super.key});

  @override
  ConsumerState<LoyaltyAddScreen> createState() {
    return _LoyaltyAddScreen();
  }
}

class _LoyaltyAddScreen extends ConsumerState<LoyaltyAddScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredStore = '';
  bool? _imageSelected;
  File? _selectedImage;

  void _newLoyalty() {
    if (_selectedImage == null) {
      setState(() {
        _imageSelected = false;
      });
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_imageSelected == false) {
        return;
      }

      setState(() {
        _imageSelected = true;
      });

      final newLoyalty = Loyalty(
        store: _enteredStore,
        image: _selectedImage!,
      );

      ref.read(loyaltiesProvider.notifier).newLoyalty(newLoyalty);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('New loyalty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  label: Text('Store'),
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.length > 50) {
                    return 'Store name must be between 1 and 50 characters.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _enteredStore = value!;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                  setState(() {
                    _imageSelected = true;
                  });
                },
              ),
              if (_imageSelected != null && _imageSelected == false) ...[
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Please pick an image.',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: const Color.fromARGB(255, 255, 177, 193),
                      ),
                ),
              ],
              const SizedBox(
                height: 12,
              ),
              ElevatedButton.icon(
                onPressed: _newLoyalty,
                icon: const Icon(Icons.loyalty),
                label: const Text('Add loyalty'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
