import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/Calculators/all_calculators.dart';
import 'calculator_scaffold.dart';

class CalculatorHome extends StatelessWidget {
  const CalculatorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalculatorScaffold(
      title: 'Calculators',
      child: CalculatorGrid(),
    );
  }
}

// GridView.extent(
//             maxCrossAxisExtent: 300,
//             mainAxisSpacing: 10,
//             crossAxisSpacing: 10,
//             primary: false,
//             padding: const EdgeInsets.all(20),
//             children: <Widget>[
//               TileButton(
//                 onPressed: () {
//                   context.push('/calculator/bodycomp');
//                 },
//                 icon: Icons.accessibility_new,
//                 label: 'Body Weights',
//                 backgroundColor: theme.colorScheme.primary,
//                 iconColor: theme.colorScheme.onPrimary,
//                 labelColor: theme.colorScheme.onPrimary,
//               ),
//               TileButton(
//                 onPressed: () {
//                   context.push('/calculator/equipment');
//                 },
//                 icon: Icons.construction,
//                 label: 'Equipment',
//                 backgroundColor: theme.colorScheme.secondary,
//                 iconColor: theme.colorScheme.onSecondary,
//                 labelColor: theme.colorScheme.onSecondary,
//               ),
//               TileButton(
//                 onPressed: () {
//                   context.push('/calculator/drugs');
//                 },
//                 icon: Icons.medication,
//                 label: 'Drugs',
//                 backgroundColor: theme.colorScheme.tertiary,
//                 iconColor: theme.colorScheme.onTertiary,
//                 labelColor: theme.colorScheme.onTertiary,
//               ),
//               TileButton(
//                 onPressed: () {
//                   context.push('/calculator/fluids');
//                 },
//                 icon: Icons.water_drop,
//                 label: 'Fluids/Blood',
//                 backgroundColor: theme.colorScheme.error,
//                 iconColor: theme.colorScheme.onError,
//                 labelColor: theme.colorScheme.onError,
//               ),
//               TileButton(
//                 onPressed: () {
//                   context.push('/calculator/insulin');
//                 },
//                 icon: FontAwesomeIcons.syringe,
//                 label: 'Insulin',
//                 backgroundColor: Colors.green,
//                 iconColor: Colors.white,
//                 labelColor: Colors.white,
//               ),
//               TileButton(
//                 onPressed: () {
//                   context.push('/calculator/ca1');
//                 },
//                 icon: Icons.checklist,
//                 label: 'Checklists',
//                 backgroundColor: theme.colorScheme.primary,
//                 iconColor: theme.colorScheme.onPrimary,
//                 labelColor: theme.colorScheme.onPrimary,
//               ),
//               TileButton(
//                 onPressed: () {
//                   context.push('/calculator/pump');
//                 },
//                 icon: Icons.favorite,
//                 label: 'Pump Cases',
//                 backgroundColor: theme.colorScheme.secondary,
//                 iconColor: theme.colorScheme.onSecondary,
//                 labelColor: theme.colorScheme.onSecondary,
//               ),
//             ])