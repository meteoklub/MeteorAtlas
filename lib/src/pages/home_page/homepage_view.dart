import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/src/pages/home_page/home_view.dart';
import 'package:simple_animations/simple_animations.dart';
import '../../../blocs/location_bloc/location_bloc.dart';
import '../../../blocs/notification_bloc/notification_bloc.dart';

class HomepageRouter extends StatelessWidget {
  const HomepageRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final _location = BlocProvider.of<LocationBloc>(context);

    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is OnMessageReceivedEvent) {}
        if (state is NotificationReceivedState) {}
        return BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {},
          child: BlocProvider.value(
            value: _location,
            child: const HomePage(),
          ),
        );
      },
    );
  }
}

Widget radianDark(Widget child) => Container(
    decoration: const BoxDecoration(
      color: Color(0xff000000),
    ),
    child: PlasmaRenderer(
      type: PlasmaType.infinity,
      particles: 10,
      color: const Color(0x443a2555),
      blur: 0.4,
      size: 1,
      speed: 4.21,
      offset: 0,
      blendMode: BlendMode.plus,
      particleType: ParticleType.atlas,
      variation1: 0,
      variation2: 0,
      variation3: 0,
      rotation: 0,
      child: child,
    ));

Widget radian(Widget child) => Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 36, 111, 92),
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: PlasmaRenderer(
        type: PlasmaType.infinity,
        particles: 13,
        color: const Color(0x4400cd71),
        blur: 0.4,
        size: 1,
        speed: 1,
        offset: 0,
        blendMode: BlendMode.screen,
        particleType: ParticleType.atlas,
        variation1: 0,
        variation2: 0,
        variation3: 0,
        rotation: 0,
        child: PlasmaRenderer(
          type: PlasmaType.bubbles,
          particles: 10,
          color: const Color(0x44ffffff),
          blur: 0.4,
          size: 1,
          speed: 1,
          offset: 0,
          blendMode: BlendMode.plus,
          particleType: ParticleType.atlas,
          variation1: 0,
          variation2: 0,
          variation3: 0,
          rotation: 0,
          child: child,
        ),
      ),
    );

void showConnectionErrorSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Connection error. Please check your internet connection."),
      duration: Duration(seconds: 3),
    ),
  );
}

// Add a function to show a snackbar for Firebase session expiration
void showSessionExpirationSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Session expired. Please log in again."),
      duration: Duration(seconds: 3),
    ),
  );
}

void showAuthenticationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("You have been successfully logged out"),
        content: const Text("See you around. ;)"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("I will!"),
          ),
        ],
      );
    },
  );
}
