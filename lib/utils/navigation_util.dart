import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NavigationUtil {
  /// Navigate to a new screen
  static Future<T?> navigateTo<T>(
    BuildContext context,
    Widget screen, {
    PageTransitionType transitionType = PageTransitionType.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
    bool replace = false,
    bool clearStack = false,
  }) async {
    if (clearStack) {
      return await Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: transitionType,
          duration: duration,
          child: screen,
        ),
        (route) => false,
      );
    }

    if (replace) {
      return await Navigator.pushReplacement(
        context,
        PageTransition(
          type: transitionType,
          duration: duration,
          child: screen,
        ),
      );
    }

    return await Navigator.push(
      context,
      PageTransition(
        type: transitionType,
        duration: duration,
        child: screen,
      ),
    );
  }

  /// Navigate to a named route
  static Future<T?> navigateToNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool replace = false,
    bool clearStack = false,
  }) async {
    if (clearStack) {
      return await Navigator.pushNamedAndRemoveUntil(
        context,
        routeName,
        (route) => false,
        arguments: arguments,
      );
    }

    if (replace) {
      return await Navigator.pushReplacementNamed(
        context,
        routeName,
        arguments: arguments,
      );
    }

    return await Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Pop the current screen
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  /// Pop until a specific route name
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Pop the current screen if can pop
  static void maybePop<T>(BuildContext context, [T? result]) {
    Navigator.maybePop(context, result);
  }

  /// Get the current route name
  static String? getCurrentRoute(BuildContext context) {
    String? currentRoute;
    Navigator.popUntil(context, (route) {
      currentRoute = route.settings.name;
      return true;
    });
    return currentRoute;
  }
}
