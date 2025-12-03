import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';

class EPHome extends StatelessWidget {
  const EPHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalculatorScaffold(
      title: 'EP Devices',
      child: EPGrid(),
    );
  }
}

// TODO: add disclaimers
const List<Map<String, dynamic>> allEPOptions = [
  {
    'name': 'Device Magnet Responses',
    'shortName': 'Magnet',
    'url': '/ep/magnet',
    'icon': FontAwesomeIcons.magnet,
    'type': 'native',
  },
  {
    'name': 'Device Management Flowcharts',
    'shortName': 'Flowcharts',
    'url': '/ep/flowsheet',
    'icon': FontAwesomeIcons.diagramProject,
    'type': 'native',
  },
];

class EPListTile extends StatelessWidget {
  final Map<String,dynamic> option;
  const EPListTile({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(option['icon']),
      title: Text(option['name']),
      onTap: () {
        context.push(option['url']);
      },
    );
  }
}

class EPGrid extends StatelessWidget {
  const EPGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListView(
          shrinkWrap: true,
          children: ListTile.divideTiles(
            context: context,
            tiles: allEPOptions.map((calc) {
              return EPListTile(option: calc);
            }).toList(),
          ).toList()
        ),
      ),
    );
  }
}