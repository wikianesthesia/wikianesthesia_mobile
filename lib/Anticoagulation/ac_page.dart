import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:wikianesthesia_mobile/Calculators/patient_demo.dart';
import 'package:wikianesthesia_mobile/Calculators/patient_widget.dart';
import 'package:wikianesthesia_mobile/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sherlock/result.dart';
import 'package:sherlock/sherlock.dart';

class ACPage extends StatelessWidget {
  final String drugName;
  const ACPage({super.key, required this.drugName});

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: 'Anticoagulation',
      child: Placeholder(),
    );
  }
}
