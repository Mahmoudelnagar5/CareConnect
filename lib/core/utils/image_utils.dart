import 'dart:convert';
import 'dart:typed_data';

String bytesToBase64Image(Uint8List bytes, String mimeType) {
  return 'data:$mimeType;base64,${base64Encode(bytes)}';
}
