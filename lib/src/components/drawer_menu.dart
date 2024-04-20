import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:meteoapp/blocs/auth_bloc/auth_event.dart';
import 'package:meteoapp/src/components/profile/profile_image.dart';
import 'package:meteoapp/src/pages/login_page/choose_auth_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/auth_bloc/auth_state.dart';
import '../../blocs/page_builder_bloc/page_builder_bloc.dart';
import '../../domain/services/route.dart';

class DrawerMenuComponent extends StatelessWidget {
  static const routeName = "/drawer";

  final PageBuilderBloc router;
  const DrawerMenuComponent({
    super.key,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const UserImage(),
              Flexible(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    for (int i = 0; i < _pages.length; i++)
                      _tile(
                        _pages[i],
                        _paths[i],
                        context,
                        router.actualPage == i,
                        () => Navigator.of(context).pushNamed(_paths[i]),
                        BlocProvider.of<AuthBloc>(context).state,
                      ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(),
        ],
      ),
    );
  }

  Widget _tile(String title, String path, BuildContext context, bool isSelected,
          VoidCallback onTap, AuthState authState) =>
      Container(
        decoration: const BoxDecoration(),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          title: authState.user != null && title == 'Přihlášení'
              ? Text(
                  AppLocalizations.of(context).log_out,
                  textAlign: isSelected ? TextAlign.end : TextAlign.start,
                  style: isSelected
                      ? Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.white)
                      : Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                )
              : Text(
                  title,
                  textAlign: isSelected ? TextAlign.end : TextAlign.start,
                  style: isSelected
                      ? Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.white)
                      : Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                ),
          onTap: () {
            if (authState.user != null && title == 'Přihlášení') {
              BlocProvider.of<AuthBloc>(context).add(LogOut());
            } else {
              onTap();
            }
          },
          subtitle: isSelected
              ? const Divider(
                  color: Colors.white,
                )
              : Container(),
        ),
      );
}

final _pages = [
  "Domovská stránka",
  'Mapa',
  "Atlas mraků",
  'Meteoklub',
  'Nastavení',
  'Přihlášení',
];

final _paths = [
  "/homepage",
  "/map",
  "/atlas",
  "/aboutus",
  "/settings",
  "/auth"
];
