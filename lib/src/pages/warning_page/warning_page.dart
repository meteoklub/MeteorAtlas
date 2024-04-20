import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:meteoapp/domain/services/route.dart';
import 'package:meteoapp/domain/theme/consts.dart';
import 'package:meteoapp/src/components/map/default_map.dart';
import 'package:meteoapp/src/pages/warning_page/warnings_cubit.dart';
import '../../../blocs/cubit/date_picker.dart';
import '../../../blocs/map_cubit/map_cubit.dart';
import '../../../domain/models/warnings.dart';
import '../../../domain/services/date_service.dart';
import '../../components/cards/animated_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WarningsPage extends StatefulWidget {
  const WarningsPage({Key? key}) : super(key: key);
  static const routeName = "/warnings";

  @override
  createState() => _WarningsPageState();
}

class _WarningsPageState extends State<WarningsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<DatePickerCubit, DateTime?>(
          builder: (context, state) {
            final formattedDate = state != null
                ? '${state.day}/${state.month}/${state.year}'
                : 'Select a date';
            return BlocProvider(
              create: (context) => DatePickerCubit(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).alerts,
                          style: kHeadline,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: WarningList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class WarningList extends StatelessWidget {
  const WarningList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarningCubit, WarningState>(
      bloc: BlocProvider.of<WarningCubit>(context),
      builder: (context, state) {
        if (state is WarningLoadingState) {
          return const CircularProgressIndicator(); // Zobrazit načítací indikátor
        } else if (state is WarningsRegionLoaded) {
          final warnings = state.warnings;
          final places = state.places;
          return SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: WarningListBuilder(warnings: warnings, places: places),
          );
        } else if (state is WarningErrorState) {
          return Text('Error: ${state.error}'); // Zobrazit chybu
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class WarningListBuilder extends StatelessWidget {
  WarningListBuilder({
    Key? key,
    required this.warnings,
    required this.places,
  }) : super(key: key);

  final List<LongWarning> warnings;
  final List<String> places;
  final GlobalKey<FlutterMapState> mapKey = GlobalKey<FlutterMapState>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: warnings.length,
      itemBuilder: (context, index) {
        final warning = warnings[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: WarningCard(
            onTap: () => handleCardTap(
              warning,
              context,
              places[index],
            ),
            activeColor: Theme.of(context).colorScheme.secondary,
            inactiveColor: Colors.orangeAccent,
            descr: warning.content.text,
            title: places[index],
            dateEnd: warning.dateEnd.toString(),
            dateStart: warning.dateStart.toString(),
          ).animate().moveX(begin: 200).scale(),
        );
      },
    );
  }

  void handleCardTap(LongWarning warning, BuildContext context, String place) {
    final loc = LatLng(warning.region.first.lat, warning.region.first.lon);
    BlocProvider.of<MapCubit>(context).setMapPosition(loc);
    Navigator.push(
      context,
      CustomPageRoute(
        builder: (_) =>
            WarningDetailScreen(place: place, warningDetails: warning),
      ),
    );
  }
}

class WarningDetailScreen extends StatelessWidget {
  final LongWarning warningDetails;
  final String place;
  static const route = '/warningID';

  const WarningDetailScreen({
    Key? key,
    required this.place,
    required this.warningDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startDate =
        DateTimeService.parseFromSeconds(warningDetails.dateStart.toString());
    final endDate =
        DateTimeService.parseFromSeconds(warningDetails.dateEnd.toString());
    final formattedRange = startDate + '-' + endDate;

    // Create a GlobalKey for DefaultMap

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(place),
            Flexible(
              child: Text(
                formattedRange,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).descr_Warning,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: DefaultMap(
                warnings: [warningDetails],
              ),
            ),
            Text(
              warningDetails.content.text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
