import 'package:flutter/material.dart';

class MeteoNavigator<T> extends PageRouteBuilder<T> {
  final Widget page;

  MeteoNavigator({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var offsetAnimation = animation.drive(tween);

            var opacityAnimation =
                Tween<double>(begin: 0.0, end: 1.0).animate(animation);

            return Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: opacityAnimation.value,
                    child: child,
                  ),
                ),
                Positioned(
                  top: offsetAnimation.value.dy *
                      MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Opacity(
                    opacity: 1.0 - opacityAnimation.value,
                    child: child,
                  ),
                ),
              ],
            );
          },
        );
}
