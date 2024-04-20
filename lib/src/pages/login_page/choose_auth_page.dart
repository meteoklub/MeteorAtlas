import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/domain/theme/consts.dart';
import 'package:meteoapp/src/pages/home_page/homepage_view.dart';
import 'package:meteoapp/src/pages/login_page/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/services/route.dart';
import '../../components/shake_widget.dart';

class ChooseAuthPage extends StatefulWidget {
  const ChooseAuthPage({super.key});
  static const routeName = '/auth';

  @override
  _ChooseAuthPageState createState() => _ChooseAuthPageState();
}

class _ChooseAuthPageState extends State<ChooseAuthPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _positionAnimation = Tween<double>(begin: 200.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: theme.iconTheme,
        title: Text(
          AppLocalizations.of(context).choose_auth,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: _positionAnimation.value),
          Column(
            children: [
              Spacers.heightBox(20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: const BorderSide(
                    width: 1.0,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      builder: (context) => const LoginPage(
                        isRegister: true,
                      ),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context).register,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Spacers.heightBox(20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: const BorderSide(
                    width: 1.0,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      builder: (context) => const LoginPage(
                        isRegister: false,
                      ),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context).login,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Spacers.heightBox(40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      builder: (context) => const HomepageRouter(),
                    ),
                  );
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ShakeWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          AppLocalizations.of(context).continueToApp,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              .animate()
              .shader()
              .moveY(duration: const Duration(milliseconds: 500))
              .fadeIn(),
        ],
      ),
    );
  }
}
