
import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Loyalty {
  Loyalty({
    String? id,
    required this.store, 
    required this.image, 
  }) : id = id ?? uuid.v4();

  final String id;
  final String store;
  final File image;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'store': store,
      'image': image.path,
    };
  }
}
