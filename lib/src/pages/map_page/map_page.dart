import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/blocs/map_cubit/map_cubit.dart';

import '../../components/map/default_map.dart';
import '../warning_page/warnings_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapPage extends StatelessWidget {
  const MapPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<WarningCubit>(context);
    final mapBloc = BlocProvider.of<MapCubit>(context);

    return BlocBuilder<WarningCubit, WarningState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is WarningsRegionLoaded) {
          return SizedBox(
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).map_page),
              ),
              body: DefaultMap(warnings: state.warnings),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
