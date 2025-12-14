import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:wikianesthesia_mobile/Anticoagulation/ac_drugs.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:flutter/material.dart';

// TODO: refactor to stateless widget

class ACPage extends StatefulWidget {
  final String drugName;
  const ACPage({super.key, required this.drugName});

  @override
  State<ACPage> createState() => _ACPageState();
}

class _ACPageState extends State<ACPage> {
  late final Map<String,String> drug;
  late List<bool> expandedTiles;

  @override
  void initState() {
    super.initState();
    drug = acDrugs.firstWhere((element) => element['Generic'] == widget.drugName, orElse: () => {});
    expandedTiles = List<bool>.filled(4, false);
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: widget.drugName,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListView(
          shrinkWrap: true,
          children: [
            DrugInfoTile(title: 'Hold Prior to Neuraxial/Nerve Procedure', content: drug['HoldPrior'] ?? 'Information not available'),
            const Divider(height: 0),
            DrugInfoTile(title: 'Resume After Neuraxial/Nerve Procedure', content: drug['ResumeAfter'] ?? 'Information not available'),
            const Divider(height: 0),
            DrugInfoTile(title: 'Hold Prior to Catheter Removal', content: drug['HoldPriorCathRemoval'] ?? 'Information not available'),
            const Divider(height: 0),
            DrugInfoTile(title: 'Resume After Catheter Removal', content: drug['ResumeAfterCathRemoval'] ?? 'Information not available'),
            if (drug['Notes'] != null && drug['Notes']!.isNotEmpty) ...[
              const Divider(height: 0),
              DrugInfoTile(title: 'Notes', content: drug['Notes'] ?? 'Information not available'),
            ]
          ]
        )
      ),
    );
  }
}

class DrugInfoTile extends StatelessWidget {
  final String title;
  final String content;

  const DrugInfoTile({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

    return ListTile(
      title: Text(title, style: headerStyle),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: SelectionArea(
          child: MarkdownBody(
            shrinkWrap: true,
            data: content,
          ),
        ),
      ),
    );
    // return Theme(
    //   data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    //   child: ExpansionTile(
    //     initiallyExpanded: true,
    //     expandedAlignment: Alignment.centerLeft,
    //     tilePadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
    //     childrenPadding: const EdgeInsets.only(top: 0, bottom: 10),
    //     title: Text(title, style: headerStyle),
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 35.0),
    //         child: MarkdownBody(
    //           shrinkWrap: true,
    //           data: content
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}