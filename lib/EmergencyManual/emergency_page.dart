import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:wikianesthesia_mobile/EmergencyManual/emergency_card.dart';
import 'package:wikianesthesia_mobile/util.dart';
import './emergency_drawer.dart';
import './emergency_topics.dart';
import './timer_button.dart';

class EmergencyPage extends StatefulWidget {
  final String pageTitle;
  const EmergencyPage({super.key, required this.pageTitle});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  /// Content of Markdown file.
  String _text = '';

  /// Title to display in the AppBar
  String _barTitle = '';

  /// List of Emergency Cards to display.
  List<EmergencyCard> _children = [];

  /// Widget containing all of the Emergency Cards
  late Widget _allCards;

  /// Widget for the Emergency Page
  late Widget _emergencyPage;

  /// List of Keys to access each Emergency Card
  final List<GlobalKey<EmergencyCardState>> _cardKeys = [];

  @override
  void initState() {
    super.initState();
    getText();
    renderWidget();
    _barTitle = emergencyTopics
        .where((p) => p["pageTitle"] == widget.pageTitle)
        .first['name'];
  }

  Future<String> getText() async {
    /// Loads in the Markdown Content

    final String response;
    try {
      response = await rootBundle
          .loadString('assets/EmergencyText/${widget.pageTitle}.md');
    } catch (_) {
      throw UnimplementedError('Emergency manual text not found!');
    }

    setState(() {
      _text = response;
      _children = parseText();
      renderWidget();
    });

    return response;
  }

  void renderWidget() {
    _allCards = SingleChildScrollView(
      child: Column(
        children: _children,
      ),
    );

    _emergencyPage = switch (widget.pageTitle) {
      'ACLS-AsystolePEA' => Column(
          children: [
            const SizedBox(height: 10),
            const PEAButtons(),
            Expanded(
              child: _allCards,
            ),
            const SizedBox(height: 5),
            const MainTimer(),
            const SizedBox(height: 5),
          ],
        ),
      'ACLS-VFVT' => Column(
          children: [
            const SizedBox(height: 10),
            const VFButtons(),
            Expanded(
              child: _allCards,
            ),
            const SizedBox(height: 5),
            const MainTimer(),
            const SizedBox(height: 5),
          ],
        ),
      'HandTs' => Column(
          children: [
            const SizedBox(height: 10),
            const VFButtons(),
            const SizedBox(height: 10),
            Expanded(
              child: _allCards,
            ),
            const SizedBox(height: 5),
            const MainTimer(),
            const SizedBox(height: 5),
          ],
        ),
      _ => Column(
          children: [
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      // Collapse or expand all cards
                      for (var key in _cardKeys) {
                        key.currentState!.expand();
                      }
                    },
                    child: const Text('Expand All')),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      // Collapse or expand all cards
                      for (var key in _cardKeys) {
                        key.currentState!.collapse();
                      }
                    },
                    child: const Text('Collapse All')),
                const Spacer(),
              ],
            ),
            Expanded(child: _allCards),
          ],
        ),
    };
  }

  List<EmergencyCard> parseText() {
    /// Takes the Markdown content and split it into Emergency Cards.
    List<EmergencyCard> parsed = [];
    List<String> allSteps = _text.split('#');

    for (String step in allSteps) {
      // Create an emergency card for each step

      String heading;
      String body;

      int idx = step.indexOf('\n');

      if (idx == -1) {
        continue;
      } else {
        heading = step.substring(0, idx).trim();
        body = step.substring(idx + 1).trim();
      }
      GlobalKey<EmergencyCardState> key = GlobalKey(debugLabel: heading);
      _cardKeys.add(key);
      parsed.add(EmergencyCard(body: body, heading: heading, key: key));
    }

    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            _barTitle,
            style: TextStyle(color: theme.colorScheme.onError),
          ),
          backgroundColor: theme.colorScheme.error,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            if (widget.pageTitle == 'ACLS-AsystolePEA' ||
                widget.pageTitle == 'ACLS-VFVT')
              ElevatedButton(
                onPressed: () {
                  goEmergencyPage(context, 'HandTs');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                ),
                child: Text(
                  "H's/T's",
                  style: TextStyle(
                      color: theme.colorScheme.onErrorContainer, fontSize: 16),
                ),
              ),
            if (widget.pageTitle == 'HandTs')
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                ),
                child: Text(
                  "Back",
                  style: TextStyle(
                      color: theme.colorScheme.onErrorContainer, fontSize: 16),
                ),
              ),
          ]),
      drawer: const EmergencyDrawer(),
      body: _emergencyPage,
    );
  }
}

class EmergencyCardList extends StatelessWidget {
  const EmergencyCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
