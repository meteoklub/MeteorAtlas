import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/blocs/cubit/localizations_cubit.dart';
import 'package:meteoapp/domain/theme/app_theme_cubit.dart';
import '../../../domain/theme/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    final themebloc = BlocProvider.of<ThemeCubit>(context);
    final locales = BlocProvider.of<LocalizationCubit>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          AppLocalizations.of(context).settings,
        ),
      ),
      body: Column(
        children: [
          Spacers.heightBox(30),
          _CustomListTile(
            title: AppLocalizations.of(context).lang,
            icon: CupertinoIcons.globe,
            callback: () => _showOptionDialog(
              context,
              AppLocalizations.of(context).choose_lan,
              [
                SeetingsItem(
                  onTap: () => locales.updateLocale(const Locale('en', 'US')),
                  option: _buildOption(
                    context,
                    const Locale('en', 'US'),
                  ),
                ),
                SeetingsItem(
                  onTap: () => locales.updateLocale(
                    const Locale('cs', 'CZ'),
                  ),
                  option: _buildOption(
                    context,
                    const Locale('cs', 'CZ'),
                  ),
                ),
              ],
            ),
          ),
          Spacers.heightBox(30),
          _CustomListTile(
            title: AppLocalizations.of(context).theme,
            icon: CupertinoIcons.color_filter,
            callback: () => _showOptionDialog(
              context,
              AppLocalizations.of(context).select_theme,
              [
                SeetingsItem(
                  onTap: () => themebloc.setTheme(ThemeMode.light),
                  option: _buildThemeOption(context, ThemeMode.light),
                ),
                SeetingsItem(
                  onTap: () => themebloc.setTheme(ThemeMode.dark),
                  option: _buildThemeOption(
                    context,
                    ThemeMode.dark,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback callback;
  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.callback,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 18),
        onTap: callback,
      ),
    );
  }
}

void _showOptionDialog(
  BuildContext context,
  String title,
  List<SeetingsItem> option,
) {
  showDialog(
    context: context,
    barrierDismissible:
        true, // Nastavíme, že dialog je možné zavřít kliknutím mimo něj

    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Column(children: [
              for (int i = 0; i < option.length; i++)
                GestureDetector(
                  child: option[i].option,
                  onTap: () => setState(() {
                    option[i].onTap();
                  }),
                )
            ]);
          },
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child:
                Text('Cancel', style: Theme.of(context).textTheme.bodySmall!),
          ),
        ],
      );
    },
  );
}

Widget _buildOption(BuildContext context, Locale locale) {
  return BlocBuilder<LocalizationCubit, Locale>(
    builder: (context, state) {
      final languageName = _getLanguageName(locale.languageCode);
      final isSelected = state == locale;

      return Material(
        color: Colors.transparent,
        child: ListTile(
          title: Row(
            children: [
              Text(locale.languageCode),
              const SizedBox(width: 8),
              Text(languageName),
              Spacer(),
              if (isSelected) const Icon(Icons.check, color: Colors.blue),
            ],
          ),
          onTap: () {
            if (!isSelected) {
              BlocProvider.of<LocalizationCubit>(context).updateLocale(locale);
            }
          },
        ),
      );
    },
  );
}

String _getLanguageName(String languageCode) {
  switch (languageCode) {
    case 'en':
      return 'English';
    case 'cs':
      return 'Czech';
    // Add more cases as needed
    default:
      return '';
  }
}

Widget _buildThemeOption(BuildContext buildContext, ThemeMode themeMode) {
  return BlocBuilder<ThemeCubit, ThemeMode>(
    builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getThemeName(themeMode),
              style: Theme.of(buildContext).textTheme.titleMedium!.copyWith(
                  color: state == ThemeMode.dark ? Colors.white : Colors.black),
            ),
            Spacer(),
            if (state == themeMode)
              const Icon(CupertinoIcons.checkmark,
                  color: CupertinoColors.activeBlue),
          ],
        ),
      );
    },
  );
}

String _getThemeName(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.light:
      return 'Light';
    case ThemeMode.dark:
      return 'Dark';
    case ThemeMode.system:
      return 'System';
    default:
      return '';
  }
}

class SeetingsItem {
  final Widget option;
  final VoidCallback onTap;

  SeetingsItem({required this.option, required this.onTap});
}
