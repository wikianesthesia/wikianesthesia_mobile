import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';

class EPFlowsheetMenu extends StatelessWidget {
  const EPFlowsheetMenu({super.key});



  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Device Management Flowcharts',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => EPFlowsheetListTile(option: allFlowsheetOptions[index]),
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemCount: allFlowsheetOptions.length,)
        ),
      ),
    );
  }
}

const List<Map<String, String>> allFlowsheetOptions = [
  {
    'name': 'Pacemaker (PM) Management',
    'shortName': 'PM',
    'url': '/ep/flowsheet/pm',
  },
  {
    'name': 'Leadless PM Management',
    'shortName': 'Leadless PM',
    'url': '/ep/flowsheet/leadless-pm',
  },
  {
    'name': 'ICD Management',
    'shortName': 'ICD',
    'url': '/ep/flowsheet/icd',
  },
  {
    'name': 'ICD w/ Pacing Management',
    'shortName': 'ICD-PM',
    'url': '/ep/flowsheet/icd-pm',
  },
  {
    'name': 'Unknown Device Management',
    'shortName': 'unknown',
    'url': '/ep/flowsheet/unknown',
  },
  {
    'name': 'Post-Op Management',
    'shortName': 'postop',
    'url': '/ep/flowsheet/postop',
  }
];

class EPFlowsheetListTile extends StatelessWidget {
  final Map<String,String> option;
  
  const EPFlowsheetListTile({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.diagramProject),
      title: Text(option['name'] ?? ''),
      onTap: () {
        context.push(option['url'] ?? '');
      },
    );
  }
}