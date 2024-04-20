import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../domain/services/date_service.dart';

class WarningDetails {
  final String title;
  final String description;

  const WarningDetails(this.title, this.description);
}

class WarningCard extends StatelessWidget {
  final Color activeColor;
  final Color? inactiveColor;
  final String title;
  final String descr;
  final String dateStart;
  final String dateEnd;

  final VoidCallback onTap; // Přidání onTap callbacku

  const WarningCard({
    Key? key,
    required this.activeColor,
    this.inactiveColor,
    required this.onTap,
    required this.title,
    required this.descr,
    required this.dateEnd,
    required this.dateStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startDate = DateTimeService.parseFromSeconds(dateStart);
    final endDate = DateTimeService.parseFromSeconds(dateEnd);
    final formattedRange = startDate + '-' + endDate;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    shape: BoxShape.rectangle,
                    backgroundBlendMode: BlendMode.srcOver,
                    gradient: LinearGradient(colors: [
                      Theme.of(context).primaryColor,
                      Color(0xff8da0cb)
                    ])),
              )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (inactiveColor ?? activeColor),
                      ),
                      child: const Icon(
                        Icons.message,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            formattedRange,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    descr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
