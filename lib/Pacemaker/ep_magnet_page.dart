import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:wikianesthesia_mobile/Pacemaker/ep_responses.dart';

class EPMagnetPage extends StatelessWidget {
  final String device;
  final String manufacturer;
  const EPMagnetPage({super.key, required this.device, required this.manufacturer});

  @override
  Widget build(BuildContext context) {
    List<Map<String,String>> responses;
    String longName = manufacturer.replaceAll('-', '/');

    // Determine which device responses to show
    switch (device) {
      case 'pm':
        responses = pacemakerMagnetResponse[longName] ?? [];
        break;
      case 'icd':
        responses = icdMagnetResponse[longName] ?? [];
        break;
      case 'leadless-pm':
        responses = leadlessPMMagnetResponse[longName] ?? [];
        break;
      case 'sicd':
        responses = sicdMagnetResponse[longName] ?? [];
        break;
      default:
        responses = [];
        longName = '';
    }

    const headerStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

    return CalculatorScaffold(
      title: longName,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(height: 0),
          itemCount: responses.length,
          itemBuilder: (context, index) => SelectionArea(
            child: ListTile(
              title: Text(responses[index]['mode'] ?? '', style: headerStyle),
              subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: MarkdownBody(
                shrinkWrap: true,
                data: responses[index]['description'] ?? ''
              ),
            ),
            ),
          ) //ExpansionInfoTile(title: responses[index]['mode'] ?? '', content: responses[index]['description'] ?? ''),
        )
      ),
    );
  }
}