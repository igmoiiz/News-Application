import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:frontend/Model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiServices extends ChangeNotifier {
  //  Instance for Supabase Client
  final SupabaseClient _supabase = Supabase.instance.client;
  //  Variables
  File? image;
  final ImagePicker picker = ImagePicker();
  //  Endpoint of the Backend <Change Ip Address Accordingly>
  final String endPoint = 'http://10.135.132.74:5000/api/news';
  //  List for news Data to store
  List<NewsModel> newsData = [];

  //  Method to get the news data
  Future<List<NewsModel>> getData() async {
    try {
      final response = await http.get(Uri.parse(endPoint));

      if (response.statusCode == 200) {
        log("Response Code is: ${response.statusCode}");
        List<dynamic> data = jsonDecode(response.body);
        newsData = data.map((e) => NewsModel.fromJson(e)).toList();
        notifyListeners();
        return newsData;
      } else {
        log("Failed to load data");
        notifyListeners();
        return newsData;
      }
    } catch (error) {
      log(error.toString());
      notifyListeners();
      return newsData;
    }
  }

  //  Method to post news Data
  Future<void> postData(
    String title,
    String description,
    String imageUrl,
  ) async {
    try {
      final newArticle = NewsModel(
        title: title,
        description: description,
        imageUrl: await postDataToSupabaseAndGetUrl(),
        createdAt: DateTime.now(),
      );
      final response = await http.post(
        Uri.parse("$endPoint/post"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(newArticle.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Status Code: ${response.statusCode}");
        log("Data Posted to Backend: $newArticle");
      } else {
        log("Error while Posting the Data to Backend: ${response.statusCode}");
        throw Exception("Failed to post data");
      }
      notifyListeners();
    } on SocketException {
      log("No internet connection");
      notifyListeners();
    } on HttpException {
      log("No service found");
      notifyListeners();
    } on FormatException {
      log("Invalid response format");
      notifyListeners();
    } catch (error) {
      log(error.toString());
      notifyListeners();
    }
  }

  //  Method to pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
      notifyListeners();
    } catch (error) {
      log(error.toString());
      notifyListeners();
    }
  }

  //  Method to post the data to supabase and get a url
  Future<String> postDataToSupabaseAndGetUrl() async {
    try {
      //  Check if the uploaded image is null or not
      if (image == null) {
        notifyListeners();
        return '';
      }
      //  Generating image details and path
      final articleId = DateTime.now().millisecondsSinceEpoch;
      final fileName = "article_$articleId.jpg";
      //  Converting the image to bytes
      final bytes = image!.readAsBytesSync();
      //  Uploading the bytes to supabase bucket
      await _supabase.storage.from('articles').uploadBinary(fileName, bytes);
      //  Getting the public url of the image from bucket
      final imageUrl = _supabase.storage
          .from('articles')
          .getPublicUrl(fileName);
      return imageUrl;
    } catch (error) {
      log(error.toString());
      return '';
    }
  }
}
