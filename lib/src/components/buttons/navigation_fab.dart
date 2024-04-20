import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:meteoapp/blocs/page_builder_bloc/page_builder_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../blocs/location_bloc/location_bloc.dart';
import '../../../blocs/location_bloc/location_state.dart';
import '../../../blocs/map_cubit/map_cubit.dart';
import '../../../domain/services/route_service.dart';
import '../../../domain/theme/consts.dart';
import '../../pages/login_page/login_page.dart';
import 'fancy_fab.dart';

class NavigationFab extends StatelessWidget {
  const NavigationFab({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.router,
  }) : _scaffoldKey = scaffoldKey;
  final PageBuilderBloc router;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 112,
      children: [
        ActionButton(
          onPressed: () => _showHomeDialog(_scaffoldKey.currentState!.context),
          icon: const Icon(Icons.location_on_outlined),
        ),
        ActionButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu),
        ),
        ActionButton(
          onPressed: () => Navigator.pushNamed(context, Routes.home),
          icon: const Icon(Icons.home),
        ),
      ],
    );
  }

  void _showHomeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return const BuildHomeLocationDialog(
          hasHomeLocation: true,
          isSharingAllowed: true,
        );
      },
    );
  }
}

class BuildHomeLocationDialog extends StatefulWidget {
  final bool hasHomeLocation;
  final bool isSharingAllowed;

  const BuildHomeLocationDialog({
    Key? key,
    required this.hasHomeLocation,
    required this.isSharingAllowed,
  }) : super(key: key);

  @override
  _BuildHomeLocationDialogState createState() =>
      _BuildHomeLocationDialogState();
}

class _BuildHomeLocationDialogState extends State<BuildHomeLocationDialog> {
  late TextEditingController _textEditingController;
  bool _isExpanded = false;
  late MapCubit mapCubit = MapCubit();
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    mapCubit = BlocProvider.of<MapCubit>(context);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visitedPlaces = BlocProvider.of<LocationBloc>(context);

    return BottomSheet(
      backgroundColor: Colors.white,
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context).my_loc,
                style: kBodyText2,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: ListView.separated(
                  itemCount: visitedPlaces.visitedLocations.length,
                  itemBuilder: (context, index) {
                    final place = visitedPlaces.visitedLocations[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          title: GestureDetector(
                            onTap: () => setState(() {
                              _isExpanded = !_isExpanded;
                              final LatLng targetCoordinate = LatLng(
                                  visitedPlaces
                                      .visitedLocations[index].latitude!,
                                  visitedPlaces
                                      .visitedLocations[index].longitude!);
                              visitedPlaces
                                  .add(UpdateLocation(targetCoordinate));
                              mapCubit.mapControllerValue
                                  ?.animateTo(dest: targetCoordinate);
                            }),
                            child: Text(
                                visitedPlaces.visitedLocations[index].title ??
                                    visitedPlaces.visitedLocations[index].index
                                        .toString(),
                                style: kBodyText2),
                          ),
                          initiallyExpanded: _isExpanded,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          subtitle: Text(
                            place.address ?? '',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                visitedPlaces.add(DeleteLocationAtIndex(index));
                              });
                            },
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InputField(
                                    label: "Nová hodnota",
                                    hintText: "Zadejte novou hodnotu",
                                    controller: _textEditingController,
                                    keyboardType: TextInputType.text,
                                    theme: Theme.of(context),
                                    suffixIcon: Icons.edit,
                                    onPressed: () {
                                      String newValue =
                                          _textEditingController.text;
                                      setState(() {
                                        visitedPlaces.add(RenameLocationIndex(
                                            newValue, index));
                                      });

                                      print("Nová hodnota: $newValue");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!widget.hasHomeLocation || !widget.isSharingAllowed)
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context).humid,
                        style: kCta,
                      ),
                    ),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
