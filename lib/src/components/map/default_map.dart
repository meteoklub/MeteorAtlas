import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../blocs/auth_bloc/auth_bloc.dart';
import '../../../blocs/auth_bloc/auth_state.dart';
import '../../../blocs/location_bloc/location_bloc.dart';
import '../../../blocs/location_bloc/location_state.dart';
import '../../../blocs/map_cubit/map_cubit.dart';
import '../../../domain/models/warnings.dart';
import '../../../domain/theme/consts.dart';
import '../../pages/warning_page/warnings_cubit.dart';
import '../buttons/navigation_fab.dart';

class DefaultMap extends StatefulWidget {
  const DefaultMap({
    Key? key,
    this.warnings,
    this.mapKey,
  }) : super(key: key);
  final GlobalKey<_DefaultMapState>? mapKey;

  final List<LongWarning>? warnings;

  @override
  _DefaultMapState createState() => _DefaultMapState();
}

class _DefaultMapState extends State<DefaultMap> with TickerProviderStateMixin {
  late LatLng _currentPosition;
  double _markerSize = 80;
  late final MapCubit mapCubit;
  bool _mapInitialized = false;
  late AnimatedMapController controller;
  late LocationBloc bloc;
  @override
  void initState() {
    super.initState();

    if (!_mapInitialized) {
      _currentPosition = LatLng(49.23, 17.63);
      mapCubit = BlocProvider.of<MapCubit>(context);
      bloc = BlocProvider.of<LocationBloc>(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeMap();
      });
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the state is disposed
    controller.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {
        controller = mapCubit.mapController = AnimatedMapController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _mapInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _mapInitialized
        ? _buildMap()
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildMap() {
    return BlocBuilder<LocationBloc, LocationState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is LocationInitial) {
          bloc.add(UpdateLocation(_currentPosition));
        }
        if (state is LocationDetailsLoaded) {
          return Stack(
            children: [
              FlutterMap(
                mapController: controller,
                options: MapOptions(
                  keepAlive: true,
                  center: _currentPosition,
                  interactiveFlags:
                      InteractiveFlag.all & ~InteractiveFlag.rotate,
                  zoom: 16.0,
                  onPositionChanged: (position, hasGesture) {
                    setState(() {
                      _currentPosition = position.center!;
                      print(position.center);
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: PolygonLayer(
                      polygons: widget.warnings?.isNotEmpty ?? false
                          ? _buildPolygonsFromRegions(widget.warnings!)
                          : [],
                    ),
                  ),
                  AnimatedMarkerLayer(
                    markers: [
                      AnimatedMarker(
                        width: _markerSize - 20,
                        height: _markerSize - 20,
                        point: _currentPosition,
                        builder: (ctx, _) => Icon(
                          Icons.add,
                          size: _markerSize,
                          color: Colors.black,
                        ),
                      ),
                      if (state.visitedLocations?.isNotEmpty ?? false)
                        ...state.visitedLocations!.map((e) => AnimatedMarker(
                              width: _markerSize,
                              height: _markerSize,
                              point: LatLng(e.latitude!, e.longitude!),
                              builder: (BuildContext context, _) {
                                final size = Tween(
                                  begin: 0.0,
                                  end: _markerSize - 40,
                                ).animate(_).value;
                                return Column(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: size,
                                    ),
                                    Text(
                                      e.title ?? e.index ?? '',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                );
                              },
                            )),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: MediaQuery.of(context).size.width * 0.25,
                left: MediaQuery.of(context).size.width * 0.25,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    BlocProvider.of<LocationBloc>(context)
                        .add(UpdateLocation(_currentPosition));
                  },
                  child: Text(
                    AppLocalizations.of(context).set_loc,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.user != null) {
                      return IconButton(
                        onPressed: () => _showHomeDialog(context),
                        icon: const Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.black,
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              if (widget.warnings?.isNotEmpty ?? false)
                Positioned(
                  bottom: 0,
                  child: BlocBuilder<WarningCubit, WarningState>(
                    builder: (context, state) {
                      if (state is WarningsRegionLoaded) {
                        return IconButton(
                          onPressed: () {
                            _showWarningsDialog(context, state.warnings);
                          },
                          icon: const Icon(
                            Icons.warning,
                            size: 40,
                            color: Colors.black,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
            ],
          );
        } else
          return Container();
      },
    );
  }

  void _showHomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const BuildHomeLocationDialog(
          hasHomeLocation: true,
          isSharingAllowed: true,
        );
      },
    );
  }

  void _showWarningsDialog(BuildContext context, List<LongWarning> warnings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildWarningsDialog(context, warnings);
      },
    );
  }

  Widget _buildWarningsDialog(
    BuildContext context,
    List<LongWarning> warnings,
  ) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      actionsAlignment: MainAxisAlignment.center,
      scrollable: true,
      title: Text(
        AppLocalizations.of(context).warningsList,
        style: kBodyText2,
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 3,
        child: ListView.separated(
          itemCount: warnings.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: BlocBuilder<WarningCubit, WarningState>(
                builder: (context, state) {
                  if (state is WarningsRegionLoaded) {
                    var keys = <String>[];
                    warnings[index]
                        .types
                        .asMap()
                        .forEach((key, value) => keys.add(key.toString()));

                    final categories = getCategories(keys);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          initiallyExpanded: true,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          subtitle: Text(state.places[index], style: kSubtitle),
                          title: Text(
                            getTime(warnings[index].dateStart),
                            style: kSubtitle.copyWith(letterSpacing: 1.5),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _navigateToRegionOnMap(
                                context,
                                warnings[index].region,
                              ).then(
                                (value) => Navigator.of(context).pop(),
                              );
                            },
                            icon: const Icon(Icons.map_outlined),
                          ),
                          children: [
                            for (String category in categories)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  category,
                                  style: kCategory,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 2,
              color: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context).close,
            style: kCta,
          ),
        ),
      ],
    ).animate().fadeIn(duration: const Duration(milliseconds: 750));
  }

  List<String> getCategories(List<String> categoryCodes) {
    List<String> categories = [];
    final locale = Localizations.localeOf(context);
    final categoryMap = localizationData[locale] ?? localizationData["en"];
    categoryCodes.forEach((code) {
      final key = "category_$code";
      final category = categoryMap?[key] ?? "Unknown Category";
      categories.add(category);
    });
    return categories;
  }

  String getTime(int date) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
    return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
  }

  Future<void> _navigateToRegionOnMap(
    BuildContext context,
    List<Geopoint> region,
  ) async {
    if (region.isNotEmpty) {
      final targetCoordinate = LatLng(region.last.lat, region.last.lon);
      BlocProvider.of<MapCubit>(context).setMapPosition(targetCoordinate);
    }
  }

  final Map<String, Map<String, String>> localizationData = {
    "cs": {
      "category_0":
          "Jiné jevy (situace, která nelze popsat ani jednou z kategorií)",
      "category_1": "Vysoké teploty",
      "category_2": "Nízké teploty",
      "category_3": "Výrazné změny teplot",
      "category_4": "Zvýšená biozátěž",
      "category_5": "Riziko požárů",
      "category_6": "Znečištění ovzduší",
      "category_7": "Silné nárazy větru",
      "category_8": "Silný vítr",
      "category_9": "Sněžení",
      "category_10": "Sněhové jazyky",
      "category_11": "Závěje",
      "category_12": "Sněhová bouře",
      "category_13": "Riziko lavin",
      "category_14": "Náledí",
      "category_15": "Ledovka",
      "category_16": "Námraza",
      "category_17": "Mrznoucí mlhy",
      "category_18": "Výrazně snížená viditelnost",
      "category_19": "Vydatný déšť",
      "category_20": "Extrémní srážky",
      "category_21": "Povodně",
      "category_22": "Bouřky",
      "category_23": "Přívalové srážky",
      "category_24": "Přívalové povodně",
      "category_25": "Supercelární bouře",
      "category_26": "Krupobití",
      "category_27": "Riziko vzniku tornáda",
    },
    "en": {
      "category_0":
          "Other phenomena (a situation that cannot be described by any of the categories)",
      "category_1": "High temperatures",
      "category_2": "Low temperatures",
      "category_3": "Significant temperature changes",
      "category_4": "Increased bioload",
      "category_5": "Fire hazard",
      "category_6": "Air pollution",
      "category_7": "Strong wind gusts",
      "category_8": "Strong wind",
      "category_9": "Snowfall",
      "category_10": "Snow drifts",
      "category_11": "Drifts",
      "category_12": "Snowstorm",
      "category_13": "Avalanche risk",
      "category_14": "Black ice",
      "category_15": "Glaze ice",
      "category_16": "Frost",
      "category_17": "Freezing fog",
      "category_18": "Significantly reduced visibility",
      "category_19": "Heavy rain",
      "category_20": "Extreme precipitation",
      "category_21": "Floods",
      "category_22": "Thunderstorms",
      "category_23": "Heavy rainfall",
      "category_24": "Flash floods",
      "category_25": "Supercellular storm",
      "category_26": "Hail",
      "category_27": "Tornado risk",
    },
  };

  List<Polygon> _buildPolygonsFromRegions(List<LongWarning> regions) {
    List<Polygon> polygons = [];

    for (var region in regions) {
      if (region.region.length >= 3) {
        List<LatLng> points =
            region.region.map((point) => LatLng(point.lat, point.lon)).toList();

        polygons.add(Polygon(
          points: points,
          color: Colors.blue,
          isFilled: true,
        ));
      }
    }

    return polygons;
  }
}
