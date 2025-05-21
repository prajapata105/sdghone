import 'package:ssda/Infrastructure/HttpMethods/requesting_methods.dart';

import '../models/product_model.dart';

class ProductService {
  final String baseUrl = "https://sridungargarhone.com";
  final String consumerKey = "ck_d7ef1f4a099e201fefb6b4cf5abe3108b1ead425";
  final String consumerSecret = "cs_8bcc847ea3e7159f501c242d2c047002ed9d06c5";

  Future<List<Product>> getAllProducts({String? search}) async {
    final query = search != null ? "&search=$search" : "";
    final fullUrl =
        "$baseUrl/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret$query";

    final response = await ApiService.requestMethods(
      methodType: "GET",
      url: fullUrl,
    );

    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> getAllProductsByCategory(int categoryId) async {
    final fullUrl =
        "$baseUrl/wp-json/wc/v3/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret&category=$categoryId";

    final response = await ApiService.requestMethods(
      methodType: "GET",
      url: fullUrl,
    );

    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

}
