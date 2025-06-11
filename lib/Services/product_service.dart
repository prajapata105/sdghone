// lib/services/product_service.dart
import 'package:ssda/Infrastructure/HttpMethods/requesting_methods.dart';
import 'package:ssda/Services/WooUserMapper.dart';
import 'package:ssda/models/product_model.dart';
import 'package:ssda/Services/Exceptions/api_exception.dart';

class ProductService {
  static const String _baseUrl = WooUserMapper.baseUrl + '/wp-json/wc/v3/';
  static const String _consumerKey = WooUserMapper.consumerKey;
  static const String _consumerSecret = WooUserMapper.consumerSecret;

  static Future<List<Product>> getProducts({
    int page = 1,
    int perPage = 20,
    String? categoryId,
  }) async {
    String categoryQuery = '';
    if (categoryId != null && categoryId.isNotEmpty) {
      categoryQuery = '&category=$categoryId';
    }
    final String url =
        '${_baseUrl}products?consumer_key=$_consumerKey&consumer_secret=$_consumerSecret&page=$page&per_page=$perPage$categoryQuery&status=publish';
    try {
      final response = await ApiService.requestMethods(url: url, methodType: "GET");
      if (response != null && response is List) {
        return response.map((data) => Product.fromJson(data)).toList();
      }
      return [];
    } catch (e) {
      print("ProductService Error (getProducts): $e");
      return [];
    }
  }

  static Future<List<Product>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    final String url =
        '${_baseUrl}products?search=$query&consumer_key=$_consumerKey&consumer_secret=$_consumerSecret&status=publish';
    try {
      final response = await ApiService.requestMethods(url: url, methodType: "GET");
      if (response != null && response is List) {
        return response.map((data) => Product.fromJson(data)).toList();
      }
      return [];
    } catch (e) {
      print("ProductService Error (searchProducts): $e");
      return [];
    }
  }
}