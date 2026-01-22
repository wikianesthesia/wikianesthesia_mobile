import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/Anticoagulation/disclaimers_log.dart';
import 'package:wikianesthesia_mobile/Calculators/all_calculators.dart';
import 'calculator_scaffold.dart';

class CalculatorHome extends StatelessWidget {
  const CalculatorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Calculators',
      child: Padding(
          padding: const EdgeInsets.only(top: 1.0, left: 2.0, right: 2.0, bottom: 0.0),
          child: Scrollbar(
            child: ListView(
              children: const [
                OpenDisclaimers(title: 'Calc_Disclaimers'),
                Divider(height: 0,),
                CalculatorGrid(),
              ],
            ),
          ),
        ),
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