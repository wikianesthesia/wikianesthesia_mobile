import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/Pacemaker/ep_responses.dart';
import 'package:wikianesthesia_mobile/util.dart';

class EPMagnetDevice extends StatelessWidget {
  final String device;
  const EPMagnetDevice({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    List<String> manufacturers;
    String longName;

    // Determine which device manufacturers to show
    switch (device) {
      case 'pm':
        manufacturers = pacemakerMagnetResponse.keys.toList();
        longName = 'Pacemaker';
        break;
      case 'icd':
        manufacturers = icdMagnetResponse.keys.toList();
        longName = 'ICD';
        break;
      case 'leadless-pm':
        manufacturers = leadlessPMMagnetResponse.keys.toList();
        longName = 'Leadless Pacemaker';
        break;
      case 'sicd':
        manufacturers = sicdMagnetResponse.keys.toList();
        longName = 'SICD';
        break;
      default:
        manufacturers = [];
        longName = '';
    }

    return CalculatorScaffold(
      title: longName,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
              context: context,
              tiles: manufacturers.map((man) {
                return EPManufacturerTile(manufacturer: man, device: device);
              }).toList(),
            ).toList()
          ),
        ),
      ),
    );
  }
}

class EPManufacturerTile extends StatelessWidget {
  final String manufacturer;
  final String device;
  const EPManufacturerTile({super.key, required this.manufacturer, required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.heartCircleBolt),
      title: Text(manufacturer),
      onTap: () {
        // Navigate to device response page
        context.push('/ep/magnet/$device/${manufacturer.replaceAll('/', '-')}');
      },
    );
  }
}