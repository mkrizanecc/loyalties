import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onPickImage,
  });

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInput();
  }
}

class _ImageInput extends State<ImageInput> {
  File? _selectedImage;

  void _selectImage() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    await pickedImage.saveTo(pickedImage.path);

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _selectImage,
      icon: const Icon(Icons.image_outlined),
      label: const Text('Select an image'),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _selectImage,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.5,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: content,
    );
  }
}
