import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:wikianesthesia_mobile/util.dart';

class DisclaimersLog extends StatefulWidget {
  final String title;
  const DisclaimersLog({super.key, required this.title});

  @override
  State<DisclaimersLog> createState() => _DisclaimersLogState();
}

class _DisclaimersLogState extends State<DisclaimersLog> {
  String disclaimerText = '';

  @override
  void initState() {
    super.initState();

    // Load the disclaimers from the markdown file
    loadDisclaimers();
  }

  void loadDisclaimers() async {
    final String response = await rootBundle.loadString('assets/${widget.title}.md');
    setState(() {
      disclaimerText = response;
    });
  }

  @override
  Widget build(BuildContext context){
    return Dialog.fullscreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Scrollbar(
              child: Markdown(
                onTapLink: (text, href, title) {
                  if (href != null) {
                    launchURL(href);
                  }
                },
                data: disclaimerText,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class OpenDisclaimers extends StatelessWidget {
  final String title;
  const OpenDisclaimers({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DisclaimersLog(title: title);
          },
        );
      },
     child: Text('Disclaimers, Updates, and References', style: TextStyle(color: Theme.of(context).colorScheme.primary),)
    );
    
    // Card(
    //   clipBehavior: Clip.hardEdge,
    //   child: ListTile(
    //     onTap: () {
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return const DisclaimersLog();
    //         },
    //       );
    //     },
    //     title: const Text('Disclaimers and References'),
    //     leading: const Icon(Icons.info),
    //   ),);
  }
}