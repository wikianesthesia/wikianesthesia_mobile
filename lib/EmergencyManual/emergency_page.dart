import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wikianesthesia_mobile/EmergencyManual/code_log.dart';

import 'package:wikianesthesia_mobile/EmergencyManual/emergency_card.dart';
import 'package:wikianesthesia_mobile/util.dart';
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
  List<Widget> _children = [];

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
    _barTitle = allEmergencyTopics
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
    _allCards = Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 2.0, right: 2.0, top: 0.0),
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: _children,
          ),
        ),
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
          ],
        ),
      'Basic_PEA' => Column(
          children: [
            const SizedBox(height: 10),
            const PEAButtons(),
            Expanded(
              child: _allCards,
            ),
          ],
        ),
      'ACLS-VFVT' => Column(
          children: [
            const SizedBox(height: 10),
            const VFButtons(),
            Expanded(
              child: _allCards,
            ),
          ],
        ),
      'Basic_VFVT' => Column(
          children: [
            const SizedBox(height: 10),
            const VFButtons(),
            Expanded(
              child: _allCards,
            ),
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
          ],
        ),
      _ => Column(
          children: [
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                    ),
                  ),
                  onPressed: () {
                    // Collapse or expand all cards
                    for (var key in _cardKeys) {
                      key.currentState!.expand();
                    }
                  },
                  child: const Text('Expand All')
                ),
                const Spacer(),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                    ),
                  ),
                  onPressed: () {
                    // Collapse or expand all cards
                    for (var key in _cardKeys) {
                      key.currentState!.collapse();
                    }
                  },
                  child: const Text('Collapse All')
                ),
                const Spacer(),
              ],
            ),
            Expanded(child: _allCards),
          ],
        ),
    };
  }

  List<Widget> parseText() {
    /// Takes the Markdown content and split it into Emergency Cards.
    List<Widget> parsed = [];
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
      parsed.add(const Divider(height: 1));
    }

    return parsed;
  }
  
  @override
  Widget build(BuildContext context) {
    bool isCardiacPage = widget.pageTitle == 'ACLS-AsystolePEA' || widget.pageTitle == 'ACLS-VFVT' || widget.pageTitle == 'HandTs' || widget.pageTitle == 'Basic_PEA' || widget.pageTitle == 'Basic_VFVT' || widget.pageTitle == 'Basic_PEA';
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: isCardiacPage ? false : true,
          title: FittedBox(
            child: Text(
              _barTitle,
              style: TextStyle(color: theme.colorScheme.onError),
            ),
          ),
          backgroundColor: theme.colorScheme.error,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: isCardiacPage ? [
              const MainTimer(),
              const SizedBox(width: 5,),
              if (widget.pageTitle != 'HandTs')
                const HTButton(),
              if (widget.pageTitle != 'HandTs')
                const SizedBox(width: 5,),
              const ShowCodeLog(),
              const SizedBox(width: 5,),
              const ShowResetTimers(),
          ] : null,),
      body: _emergencyPage,
    );
  }
}

class ShowResetTimers extends StatelessWidget {
  const ShowResetTimers({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    

    return IconButton.outlined(
      style: OutlinedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Set border radius
        ),
        side: const BorderSide(
          color: Colors.white, // Your desired outline color
      )),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ResetTimersLog();
          },
        );
      },
      icon:Icon(Icons.history, color: theme.colorScheme.onError),);
  }
}

class ShowCodeLog extends StatelessWidget {
  const ShowCodeLog({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    

    return IconButton.outlined(
      style: OutlinedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Set border radius
        ),
        side: const BorderSide(
          color: Colors.white, // Your desired outline color
      )),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CodeLog();
          },
        );
      },
      icon:Icon(Icons.article_outlined, color: theme.colorScheme.onError),);
  }
}

class HTButton extends StatelessWidget {
  const HTButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return OutlinedButton(
      onPressed: () {
        goEmergencyPage(context, 'HandTs');
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        side: const BorderSide(color: Colors.white), // Set border color and width
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Set border radius
        ),
        // Other style properties like foregroundColor, backgroundColor, etc.
      ),
      child: Text(
        "Hs/Ts",
        style: TextStyle(
            color: theme.colorScheme.onError, fontSize: 16),
      ),
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
