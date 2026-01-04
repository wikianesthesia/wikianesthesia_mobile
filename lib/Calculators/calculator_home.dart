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

class GuidelinesHome extends StatelessWidget {
  const GuidelinesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalculatorScaffold(
      title: 'Resources',
      child: GuidelinesGrid(),
    );
  }
}