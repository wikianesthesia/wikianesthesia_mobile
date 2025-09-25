import 'package:wikianesthesia_mobile/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

class EmergencyCard extends StatefulWidget {
  final String body;
  final String heading;

  const EmergencyCard({super.key, required this.body, this.heading = ''});

  @override
  State<EmergencyCard> createState() => EmergencyCardState();
}

class EmergencyCardState extends State<EmergencyCard> {
  final ExpansionTileController controller = ExpansionTileController();
  bool isExpanded = true;

  void collapse() {
    setState(() {
      isExpanded = false;
    });
    controller.collapse();
  }

  void expand() {
    setState(() {
      isExpanded = true;
    });
    controller.expand();
  }

  final MarkdownStyleSheet _style = MarkdownStyleSheet(
      textAlign: WrapAlignment.start,
      h1Align: WrapAlignment.start,
      unorderedListAlign: WrapAlignment.start);

  @override
  Widget build(context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
          decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.blue, width: 10))),
          child: ExpansionTile(
            controller: controller,
            initiallyExpanded: isExpanded,
            title: Text(
              widget.heading,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            dense: true,
            childrenPadding: const EdgeInsets.only(bottom: 8.0),
            children: [
              Markdown(
                data: widget.body,
                listItemCrossAxisAlignment:
                    MarkdownListItemCrossAxisAlignment.start,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                onTapLink: (text, href, title) {
                  if (href!.length > 4 && href.substring(0, 4) == 'http') {
                    // Open the link in a webview
                    launchURL(href);
                  } else {
                    context.pushNamed('emergencypage',
                        pathParameters: {'pageTitle': href});
                  }
                },
                styleSheet: _style,
              )
            ],
          )),
    );
  }
}
