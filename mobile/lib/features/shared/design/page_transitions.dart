import 'package:flutter/material.dart';

class HealynPageTransitionsBuilder extends PageTransitionsBuilder {
  const HealynPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInOutCubic,
    );

    final slide = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(curved);


    return SlideTransition(
      position: slide,
      child: child,
    );
  }
}