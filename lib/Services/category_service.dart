import 'dart:convert';
import 'package:ssda/Infrastructure/HttpMethods/requesting_methods.dart';
import 'package:ssda/models/category_model.dart';

class CategoryService {
  final String baseUrl = "https://sridungargarhone.com";
  final String consumerKey = "ck_d7ef1f4a099e201fefb6b4cf5abe3108b1ead425";
  final String consumerSecret = "cs_8bcc847ea3e7159f501c242d2c047002ed9d06c5";

  Future<List<Category>> getAllCategories() async {
    final url =
        "$baseUrl/wp-json/wc/v3/products/categories?consumer_key=$consumerKey&consumer_secret=$consumerSecret";

    final response = await ApiService.requestMethods(
      methodType: "GET",
      url: url,
    );

    return (response as List).map((e) => Category.fromJson(e)).toList();
  }
}
