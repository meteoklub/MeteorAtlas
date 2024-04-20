import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:meteoapp/blocs/page_builder_bloc/page_builder_bloc.dart';

import 'package:meteoapp/domain/theme/consts.dart';
import 'package:meteoapp/src/pages/map_page/map_page.dart';
import 'package:meteoapp/src/pages/weather_page/weather_page.dart';
import 'package:meteoapp/src/pages/warning_page/warning_page.dart';

import '../../../blocs/location_bloc/location_bloc.dart';
import '../../../blocs/location_bloc/location_state.dart';
import '../../../blocs/weather_bloc/weather_bloc.dart';
import '../../../domain/services/route_service.dart';
import '../../components/buttons/navigation_fab.dart';
import '../../components/drawer_menu.dart';
import '../../components/map/default_map.dart';
import '../../components/profile/location_col.dart';
import '../warning_page/warnings_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, RestorationMixin {
  late LocationBloc locationBloc;
  late WeatherBloc weatherBloc;
  late WarningCubit warningCubit;
  bool locationPermissionRequested = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    weatherBloc = BlocProvider.of<WeatherBloc>(context);
    warningCubit = BlocProvider.of<WarningCubit>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final mapKey = GlobalKey<FlutterMapState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final pageIndex = BlocProvider.of<PageBuilderBloc>(context);
    final scrollController = ScrollController();
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerMenuComponent(router: pageIndex).animate().fade(),
      floatingActionButton:
          NavigationFab(scaffoldKey: _scaffoldKey, router: pageIndex).animate(),
      body: CustomScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverLayoutBuilder(
            builder: (context, constraints) {
              final scrolled = constraints.scrollOffset > 300;

              return BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  return SliverAppBar(
                      collapsedHeight: 60,
                      pinned: true,
                      expandedHeight: MediaQuery.of(context).size.height / 2,
                      shadowColor: Colors.black,
                      backgroundColor: Theme.of(context).primaryColor,
                      iconTheme: scrolled
                          ? const IconThemeData(
                              size: 40,
                              color: Colors.white,
                            )
                          : IconThemeData(
                              size: 40,
                              color: Theme.of(context).colorScheme.tertiary),
                      title: LocationColumn(
                        title: state is LocationDetailsLoaded
                            ? state.forecast.place
                            : AppLocalizations.of(context).loading,
                        isScrolled: scrolled,
                      ).animate().fadeIn(),
                      elevation: 10.0,
                      flexibleSpace: FlexibleSpaceBar(
                          background: DefaultMap(
                        key: mapKey,
                      )));
                },
              );
            },
          ),
          BlocBuilder<PageBuilderBloc, PageState>(
            buildWhen: (previous, current) => previous != current,
            bloc: pageIndex,
            builder: (context, state) {
              if (state is PageStateChanged) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      switch (index) {
                        case 0:
                          return _buildHourlyWeatherSection(
                            isHourly: false,
                          );

                        case 1:
                          {
                            if (state.page == 5) {
                              return MapPage(
                                key: mapKey,
                              );
                            }
                          }
                          return _buildHourlyWeatherSection(
                            isHourly: true,
                          );

                        default:
                          return const SizedBox.shrink();
                      }
                    },
                    childCount: 3, // Počet sekcí
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      switch (index) {
                        case 0:
                          return _buildHourlyWeatherSection(isHourly: false);

                        case 1:
                          return _buildHourlyWeatherSection(isHourly: true);
                        case 2:
                          return _buildWarningsSection();
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                    childCount: 3, // Počet sekcí
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyWeatherSection({
    bool isHourly = false,
  }) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationDetailsLoaded) {
          return _buildSection(
              context,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isHourly
                        ? AppLocalizations.of(context).todaysWeather
                        : AppLocalizations.of(context).weather_tomm,
                    style: kHeadline.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.bold,
                        fontFamily: "BespokeSerif"),
                  ),
                  Text(
                    '${state.forecast.place}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Routes.weatherList,
              SizedBox(
                height: 500,
                child: WeatherHorizontalList(
                    isHour: isHourly,
                    forecastList: isHourly
                        ? state.forecast.hourly
                        : state.forecast.daily),
              ));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildWarningsSection() {
    return BlocBuilder<WarningCubit, WarningState>(
      bloc: warningCubit,
      builder: (context, state) {
        if (state is WarningInitialState) {
          warningCubit.loadShortWarnings();
        }
        if (state is WarningsRegionLoaded) {
          return _buildSection(
            context,
            Text(
              AppLocalizations.of(context).warningsList,
              style: kHeadline.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontWeight: FontWeight.bold,
                  fontFamily: "BespokeSerif"),
            ),
            Routes.warnings,
            WarningListBuilder(
              warnings: state.warnings,
              places: state.places,
            ),
          );
        }
        if (state is WarningLoadingState) {
          return const CircularProgressIndicator();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildSection(
    BuildContext context,
    Widget? title,
    String route,
    Widget contentWidget,
  ) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: title ??
                Text(
                  'title',
                  style: kHeadline.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.bold,
                      fontFamily: "BespokeSerif"),
                ).animate().fadeIn().moveX(
                      begin: 50,
                      duration: const Duration(milliseconds: 500),
                    ),
          ),
          contentWidget,
        ],
      ),
    );
  }

  @override
  String? get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}
}
