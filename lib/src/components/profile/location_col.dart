import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/domain/services/route.dart';
import 'package:meteoapp/src/pages/map_page/map_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../blocs/location_bloc/location_bloc.dart';
import '../../../domain/models/location_model.dart';
import '../../pages/login_page/login_page.dart';

class LocationColumn extends StatefulWidget {
  final bool isScrolled;
  final String title;
  final LocationBloc? bloc;
  const LocationColumn(
      {Key? key, this.isScrolled = false, required this.title, this.bloc})
      : super(key: key);

  @override
  _LocationColumnState createState() => _LocationColumnState();
}

class _LocationColumnState extends State<LocationColumn> {
  bool isSearching = false;
  late LocationBloc locationBloc = LocationBloc();
  final TextEditingController _locationController = TextEditingController();
  List<LocationWithAddress> suggestions = []; // Seznam sugestí

  void searchLocation(String locationName) {
    final locationBloc = widget.bloc ?? BlocProvider.of<LocationBloc>(context);

    List<LocationWithAddress> filteredLocations = locationBloc.visitedLocations
        .where((location) =>
            (location.title
                    ?.toLowerCase()
                    .contains(locationName.toLowerCase()) ??
                false) ||
            (location.address
                    ?.toLowerCase()
                    .contains(locationName.toLowerCase()) ??
                false))
        .toList();

    // Zobrazte první tři shody pod vstupním polem
    suggestions = filteredLocations.length > 3
        ? filteredLocations.sublist(0, 3)
        : filteredLocations;

    setState(() {}); // Znovu vykreslit widget po aktualizaci sugestí
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isSearching)
                  Text(
                    widget.title,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          letterSpacing: 1.2,
                          color:
                              widget.isScrolled ? Colors.white : Colors.black,
                        ),
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 200))
                      .moveY(
                        begin: 50,
                      ),
                if (isSearching)
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: InputField(
                        label: AppLocalizations.of(context).location,
                        hintText: 'Enter location',
                        controller: _locationController,
                        keyboardType: TextInputType.emailAddress,
                        theme: theme,
                        icon: Icons.location_on_outlined,
                        suffixIcon: Icons.close,
                        onChanged: searchLocation,
                        onPressed: () => setState(() {
                          isSearching = !isSearching;
                        }),
                      ),
                    ),
                  ),
                !widget.isScrolled || isSearching
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isSearching = !isSearching;
                          });
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ).animate().fade(curve: Curves.easeIn),
                      )
                    : IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              CustomPageRoute(builder: (_) => const MapPage()));
                        },
                        icon: const Icon(
                          Icons.map_outlined,
                        ).animate().fade(curve: Curves.easeIn),
                      )
              ],
            ),
/*          if (suggestions.isNotEmpty)
            Column(
              children: suggestions.map((location) {
                return ListTile(
                  title: Text(location.title ?? ''),
                  subtitle: Text(location.address ?? ''),
                  onTap: () {
                    // Zde zpracujte kliknutí na sugestii
                  },
                );
              }).toList(),
            ),
    */
          ],
        ));
  }
}
