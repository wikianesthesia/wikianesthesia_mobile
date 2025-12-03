import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Calculators/calculator_scaffold.dart';
import 'package:wikianesthesia_mobile/Pacemaker/ep_flowsheets.dart';

class EPFlowsheet extends StatefulWidget {
  final String flowsheet;
  const EPFlowsheet({super.key, required this.flowsheet});

  @override
  State<EPFlowsheet> createState() => _EPFlowsheetState();
}

class _EPFlowsheetState extends State<EPFlowsheet> {
  late final Map<String,FlowSheetItem> algorithm;
  List<EPFlowsheetCard> cards = [];
  late final String title;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    algorithm = (switch(widget.flowsheet) {
      'pm' => pacemakerManagement,
      'icd' => icdManagement,
      'leadless-pm' => leadlessPMManagement,
      'icd-pm' => icdPMManagement,
      'unknown' => unknownDeviceManagement,
      'postop' => postOpManagement,
      _ => {},
    });

    title = (switch(widget.flowsheet) {
      'pm' => 'Pacemaker Management',
      'icd' => 'ICD Management',
      'leadless-pm' => 'Leadless Pacemaker Management',
      'icd-pm' => 'ICD with Pacemaker Management',
      'unknown' => 'Unknown Device Management',
      'postop' => 'Post-Op Device Management',
      _ => 'Device Management Flowchart',
    });

    cards = [
      EPFlowsheetCard(item: algorithm['start']!, onSelected: selectOption, isStart: true, selected: ''),
    ];
  }

  void selectOption(String next, String selected) {
    if (next.contains('/')) {
      context.push(next);
      return;
    }
    
    FlowSheetItem nextItem = algorithm[next]!;

    setState(() {
      cards.last = EPFlowsheetCard(item: cards.last.item, selected: selected, onSelected: selectOption);
      cards.add(EPFlowsheetCard(item: nextItem, onSelected: selectOption, selected: ''));
    });

    scrollToBottom();
  }

  void reset() {
    setState(() {
      cards = [
        EPFlowsheetCard(item: algorithm['start']!, onSelected: selectOption, isStart: true, selected: ''),
      ];
    });
  }

  void undo() {
    if (cards.length > 1) {
      setState(() {
        cards.removeLast();
        cards.last = EPFlowsheetCard(
          item: cards.last.item,
          selected: '',
          onSelected: selectOption,
        );
      });
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalculatorScaffold(
      title: title,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          //shrinkWrap: true,
          children: [
            ...cards,
            if (cards.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: undo,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                    ),
                  ),
                  child: const Text('Undo Last'),
                ),
                ElevatedButton(
                  onPressed: reset,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                    ),
                  ),
                  child: const Text('Restart'),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}

typedef OnSelectedCallback = void Function(String next, String selected);
class EPFlowsheetCard extends StatelessWidget {
  final String selected;
  final FlowSheetItem item;
  final OnSelectedCallback onSelected;
  final bool isStart;

  const EPFlowsheetCard({super.key, required this.item, required this.selected, required this.onSelected, this.isStart=false});

  List<T> intersperse<T>(List<T> list, T separator) {
    if (list.isEmpty) {
      return [];
    }

    final result = <T>[];
    for (int i = 0; i < list.length; i++) {
      result.add(separator);
      result.add(list[i]);
    }
    return result + [separator];
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = item.next.keys.toList();
    Widget optionButtons;

    if (options.isNotEmpty) {
      optionButtons = SegmentedButton(
        segments: [
          ...options.map((option) => ButtonSegment<String>(
            value: option,
            label: Text(option),
            enabled: selected.isEmpty,
          ))
        ],
        selected: {selected},
        onSelectionChanged: (Set<String> newSelection) {
          if (newSelection.isNotEmpty) {
            onSelected(item.next[newSelection.first]!, newSelection.first);
          }
        },
      );
    } else {
      optionButtons = const Text('END OF FLOWCHART', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,);
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.question, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
            if (item.footnotes.isNotEmpty) ShowFootnotesButton(footnotes: item.footnotes),
            const Divider(),
            optionButtons,
          ],
        ),
      )
    );
  }
}

class ShowFootnotesButton extends StatelessWidget {
  final List<int> footnotes;
  
  const ShowFootnotesButton({super.key, required this.footnotes});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => FootnotesDialog(footnotes: footnotes),
        );
      },
      child: const Text('Show Footnotes', style: TextStyle(fontStyle: FontStyle.italic),),
    );
  }
}

class FootnotesDialog extends StatelessWidget {
  final List<int> footnotes;
  
  const FootnotesDialog({super.key, required this.footnotes});

  @override
  Widget build(BuildContext context) {
    String footnoteText = footnotes.map((note) => flowchartFootnotes[note] ?? '').join('\n\n');
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: const Text('Footnotes'),
      actionsPadding: const EdgeInsets.only(bottom: 8.0, right: 8.0, top: 0.0),
      content: SizedBox(
        width: width * 0.8,
        child: Scrollbar(child: Markdown(data: footnoteText,shrinkWrap: true,))
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ]
    );
  }
}