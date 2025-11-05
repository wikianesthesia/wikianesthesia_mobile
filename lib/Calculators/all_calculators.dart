
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/util.dart';

/// This file contains the list of emergency topics for the Emergency Manual.
/// Each topic is represented as a map with the following keys:

/// Emergency Scenarios. Name is the english name to be displayed.
/// pageTitle is the Markdown file name in assets/EmergencyText
/// Tags is a list of alternative search tags for Sherlock

const List<Map<String, dynamic>> allCalculators = [
  {
    'name': 'Body Composition',
    'shortName': 'Body Comp',
    'url': 'https://wikianesthesia.org/wiki/Body_composition_calculations',
    'icon': FontAwesomeIcons.childReaching,
    'type': 'wikipage',
  },
  {
    'name': 'Cardiovascular',
    'shortName': 'Cardiac',
    'url': 'https://wikianesthesia.org/wiki/Cardiovascular_calculations',
    'icon': FontAwesomeIcons.heartPulse,
    'type': 'wikipage',
  },
  {
    'name': 'Drug Dosages',
    'shortName': 'Drugs',
    'url': 'https://wikianesthesia.org/wiki/Drug_dosage_calculations',
    'icon': FontAwesomeIcons.syringe,
    'type': 'wikipage',
  },
  {
    'name': 'Insulin Drip',
    'shortName': 'Insulin',
    'url': '/calculator/insulin',
    'icon': FontAwesomeIcons.syringe,
    'type': 'native',
    'restrict': 'Hopkins',
  },
  {
    'name': 'Equipment Size',
    'shortName': 'Equipment',
    'url': 'https://wikianesthesia.org/wiki/Equipment_size_calculations',
    'icon': Icons.construction,
    'type': 'wikipage',
  },
  {
    'name': 'Fluid Management',
    'shortName': 'Fluids',
    'url': 'https://wikianesthesia.org/wiki/Fluid_management_calculations',
    'icon': Icons.water_drop,
    'type': 'wikipage',
  },
  {
    'name': 'Neuro',
    'shortName': 'Neuro',
    'url': 'https://wikianesthesia.org/wiki/Neuro_calculations',
    'icon': FontAwesomeIcons.brain,
    'type': 'wikipage',
  },
  {
    'name': 'Respiratory',
    'shortName': 'Respiratory',
    'url': 'https://wikianesthesia.org/wiki/Respiratory_calculations',
    'icon': FontAwesomeIcons.lungs,
    'type': 'wikipage',
  },
  {
    'name': 'Checklists',
    'shortName': 'Checklists',
    'url': '/calculator/ca1',
    'icon': Icons.checklist,
    'type': 'native',
  },
  {
    'name': 'Pump Case',
    'shortName': 'Pump Case',
    'url': '/calculator/pump',
    'icon': Icons.favorite,
    'type': 'native',
    'restrict': 'Hopkins',
  },
  {
    'name': 'Calculator Guide',
    'shortName': 'Guide',
    'url': 'https://wikianesthesia.org/wiki/WikiAnesthesia:Calculators_guide',
    'icon': FontAwesomeIcons.book,
    'type': 'wikipage',
  },
];

class CalculatorListTile extends ConsumerWidget {
  final Map<String,dynamic> calculator;
  const CalculatorListTile({super.key, required this.calculator});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<List<String>> practiceGroups = ref.watch(wikiPracticeGroupsProvider);

    List<String> dbKeys = [];

    if (practiceGroups.isNotEmpty) {
      dbKeys = practiceGroups
        .map((subList) => subList[0])
        .toList();
    }

    // Check to see if calculator is restricted only to certain practice group
    if (calculator.containsKey('restrict') && !dbKeys.contains(calculator['restrict'])) {
      return const SizedBox.shrink();
    }

    return ListTile(
      leading: Icon(calculator['icon']),
      title: Text(calculator['name']),
      onTap: () {
        context.pop();
        if (calculator['type'] == 'wikipage') {
          goCalcPage(context, calculator['url']);
        } else if (calculator['type'] == 'native') {
          context.push(calculator['url']);
        }
      },
    );
  }
}

ExpansionPanelRadio calcPanel(BuildContext context) {
  return ExpansionPanelRadio(
    headerBuilder: (context, isExpanded) => const ListTile(title: Text('Calculators')),
    value: 'calculators',
    canTapOnHeader: true,
    body: Column(
      children: allCalculators.map((calc) => CalculatorListTile(calculator: calc)).toList(),
    )
  );
}

class CalculatorIconButton extends StatelessWidget {
  final Map<String,dynamic> calculator;
  const CalculatorIconButton({super.key, required this.calculator});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(calculator['icon']),
      trailing: const Icon(Icons.chevron_right),
      title:  Text(calculator['name']),
      onTap: () {
        if (calculator['type'] == 'wikipage') {
          goCalcPage(context, calculator['url']);
        } else if (calculator['type'] == 'native') {
          context.push(calculator['url']);
        }
      },
    );
  }
}

class CalculatorGrid extends ConsumerWidget {
  const CalculatorGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<List<String>> practiceGroups = ref.watch(wikiPracticeGroupsProvider);
    List<String> dbKeys = [];

    if (practiceGroups.isNotEmpty) {
      dbKeys = practiceGroups
        .map((subList) => subList[0])
        .toList();
    }


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListView(
          shrinkWrap: true,
          children: ListTile.divideTiles(
            context: context,
            tiles: allCalculators.map((calc) {
                if (calc.containsKey('restrict') && !dbKeys.contains(calc['restrict'])) {
                  return null;
                } else {
                  return CalculatorIconButton(calculator: calc);
              }
            }).where((e) => e != null) // Remove null items
            .cast<Widget>()
            .toList(),
          ).toList()
        ),
      ),
    );
  }
}