import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssda/screens/Auth/login_screen.dart';
import 'package:ssda/screens/Auth/otp_verification_screen.dart';
import 'package:ssda/screens/app_about_screen.dart';
import 'package:ssda/screens/cart_gift_screen.dart';
import 'package:ssda/screens/coupons_screeen.dart';
import 'package:ssda/screens/error_screen.dart';
import 'package:ssda/screens/home_screen.dart';
import 'package:ssda/screens/intro-screen/splasescreen.dart';
import 'package:ssda/screens/order_confirmation_screen.dart';
import 'package:ssda/screens/order_summary_screen.dart';
import 'package:ssda/screens/pdf_view_screen.dart';
import 'package:ssda/screens/products_screen.dart';
import 'package:ssda/screens/profile_screen.dart';
import 'package:ssda/screens/user_address_screen.dart';
import 'package:ssda/screens/user_cart_screen.dart';
import 'package:ssda/screens/user_orders_screen.dart';

import 'Services/cart_service.dart';


class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/ss':
        return ScalePageRoute(
          builder: (_) => const LoginScreen(),
        );
      case '/otp/verify':
        return ScalePageRoute(
          builder: (_) => OTPVerificationScreen(
            data: settings.arguments,
          ),
          animationDirection: AnimationDirection.rightToLeft,
        );
      case '/home':
        return ScalePageRoute(
          builder: (_) => const HomeScreen(),
        );
      case '/':
        return ScalePageRoute(
          builder: (_) => const SplaseScreen(),
        );
      case '/products':
        return ScalePageRoute(
          builder: (_) => ProductsScreen(
            categoryName: settings.arguments.toString(),
          ),
          animationDirection: AnimationDirection.rightToLeft,
        );
      case '/coupons':
        return ScalePageRoute(
          builder: (_) => const CouponsSelectionScreen(),
          animationDirection: AnimationDirection.rightToLeft,
        );

      case "/cart/gift":
        return ScalePageRoute(
          builder: (_) => const CartGiftScreen(),
        );


      case "/cart":
        return ScalePageRoute(
          builder: (context) => const CartScreen(),
        );


      case "/orders":
        return ScalePageRoute(
          builder: (_) => const OrdersScreen(),
          animationDirection: AnimationDirection.rightToLeft,
        );
      case "/order":
        return ScalePageRoute(
          builder: (_) => const OrderSummaryScreen(),
          animationDirection: AnimationDirection.rightToLeft,
        );
      case "/order/invoice":
        return ScalePageRoute(
          builder: (_) => const ViewOrderInvoiceScreen(),
          animationDirection: AnimationDirection.rightToLeft,
        );
      case "/order/confirm":
        return ScalePageRoute(
          builder: (_) => const OrderConfirmationScreen(),
        );

      case '/profile':
        return ScalePageRoute(
          builder: (_) => const ProfileScreen(),
        );
      case '/user/address':
        return ScalePageRoute(
          builder: (_) => const UserAddressScreen(),
          animationDirection: AnimationDirection.rightToLeft,
        );
      case '/app/about':
        return ScalePageRoute(
          builder: (_) => const AppAboutScreen(),
          animationDirection: AnimationDirection.rightToLeft,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorScreem(),
        );
    }
  }
}

enum AnimationDirection {
  leftToRight,
  rightToLeft,
  center,
}

class ScalePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final AnimationDirection animationDirection;

  ScalePageRoute({
    required this.builder,
    this.animationDirection = AnimationDirection.center,
  }) : super(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      // ✅ इस Builder से context अब Provider को access कर सकता है
      return Builder(
        builder: (innerContext) => builder(innerContext),
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (animationDirection) {
        case AnimationDirection.leftToRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case AnimationDirection.rightToLeft:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case AnimationDirection.center:
        default:
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          );
      }
    },
  );
}


