import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kaon_sa_kuan/config/cloudinary_config.dart';

class CloudinaryService {
  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/image/upload',
      );

      final request = http.MultipartRequest(
        'POST',
        url,
      );

      request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();

        final data = jsonDecode(responseData);

        return data['secure_url'];
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(
        'Failed to upload image: $e',
      );
    }
  }
}
