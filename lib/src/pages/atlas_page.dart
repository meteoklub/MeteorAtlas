import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meteoapp/domain/theme/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/theme/theme_extention.dart';

class AtlasItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const AtlasItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width /
          2, // Set width to half of the screen
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imageUrl,
              height: 300, // Set height as per your requirement
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
          const SizedBox(height: 10.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            description,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class AtlasPage extends StatefulWidget {
  const AtlasPage({Key? key}) : super(key: key);
  static const routeName = "/atlas";

  @override
  createState() => _AtlasPageState();
}

class _AtlasPageState extends State<AtlasPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).atlas),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Atlas mraků", style: kHeadline),
              SizedBox(
                height: 600,
                child: AtlasList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AtlasList extends StatelessWidget {
  const AtlasList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AtlasItem(
            imageUrl:
                'https://www.heart.org/-/media/Images/Health-Topics/Congenital-Heart-Defects/50_1683_44bc_ASD-Repairs.jpg?h=361&w=600&hash=3DAB3DD67F5AD7433CC98C2629B99224', // Example image URL
            title: 'Warning Title $index',
            description: 'Warning Description $index',
          ),
        );
      },
    );
  }
}
