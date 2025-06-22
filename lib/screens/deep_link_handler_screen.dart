import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssda/models/news_article_model.dart';
import 'package:ssda/screens/intro-screen/homenav.dart';
import 'package:ssda/screens/news_detail_screen.dart';
import 'package:ssda/services/news_service.dart';

class DeepLinkHandlerScreen extends StatefulWidget {
  final int articleId;
  const DeepLinkHandlerScreen({required this.articleId});

  @override
  _DeepLinkHandlerScreenState createState() => _DeepLinkHandlerScreenState();
}

class _DeepLinkHandlerScreenState extends State<DeepLinkHandlerScreen> {
  @override
  void initState() {
    super.initState();
    _handleLink();
  }

  Future<void> _handleLink() async {
    try {
      final article = await NewsService.getArticleById(widget.articleId);
      if (article != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => NewsDetailScreen(article: article),
        ));
      } else {
        _goHome();
      }
    } catch (e) {
      _goHome();
    }
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeNav(index: 0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
