import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sherlock/result.dart';
import 'package:sherlock/sherlock.dart';

import '../util.dart';
import './emergency_topics.dart';

class EmergencyHome extends StatefulWidget {
  const EmergencyHome({super.key});

  @override
  State<EmergencyHome> createState() => _EmergencyHomeState();
}

class _EmergencyHomeState extends State<EmergencyHome> {
  /// Displays the Emergency Page with a list of all scenarios with a search bar

  /// List of Scenarios to display (initialized as every scenario,
  /// but can be replaced by search results)
  List<Map<String, dynamic>> _toBeListed = emergencyTopics;
  bool searchResultsPresent = false;

  /// SearchBar Widget
  late Widget _searchBar;

  /// Text controller for the SearchBar
  final _controller = TextEditingController();

  /// Sherlock Instance for searching
  final Sherlock _sherlock = Sherlock(elements: emergencyTopics, priorities: {
    'name': 3,
    'tags': 2,
    'pageTitle': 2,
  });

  /// GridView of TileButtons
  Widget _buttonGrid = GridView.extent(
    primary: false,
    padding: const EdgeInsets.all(20),
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    maxCrossAxisExtent: 300,
    children: const [],
  );

  @override
  void initState() {
    super.initState();
    generateTileButtons();
    buildSearchBar();
  }

  void buildSearchBar() {
    _searchBar = TextField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2.0,
              color: Colors.white,
            ),
          ),
          hintText: 'Search Scenarios',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            // Gives button at end of SearchBar to clear input
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.clear();
              searchTopics('');
            },
            tooltip: 'Clear',
          )),
      onChanged: (String input) {
        searchTopics(input);
      },
      onSubmitted: (String input) {
        searchTopics(input);
      },
      controller: _controller,
    );
  }

  void generateTileButtons() {
    List<Widget> allButtons = [];

    /// Generates a GridView of TileButtons based on list of scenarios to display

    // _buttonGrid = GridView.count(
    //   primary: false,
    //   padding: const EdgeInsets.all(20),
    //   crossAxisSpacing: 2,
    //   mainAxisSpacing: 2,
    //   crossAxisCount: 2,
    //   childAspectRatio: 3,
    //   children: allButtons,
    // );

    if (searchResultsPresent) {
      if (_toBeListed.isEmpty) {
        _buttonGrid = const Center(
          child: Text('No results found.'),
        );
      } else {
        allButtons = _toBeListed
            .map(
              (topic) => CaseButton(
                onPressed: () {
                  goEmergencyPage(context, topic['pageTitle']);
                },
                icon: topic['icon'],
                backgroundColor: topic['backgroundColor'],
                iconColor: topic['backgroundColor'],
                label: topic['name'],
                labelColor: Colors.black, //topic['iconColor'],
                showIcon: true,
              ),
            )
            .toList();

        _buttonGrid = ListView(
          padding: const EdgeInsets.all(8),
          children: allButtons,
        );
      }
    } else {
      List<Widget> aclsButtons = _toBeListed
          .sublist(0, 6)
          .map(
            (topic) => CaseCardButton(
              onPressed: () {
                goEmergencyPage(context, topic['pageTitle']);
              },
              icon: topic['icon'],
              backgroundColor: topic['backgroundColor'],
              iconColor: topic['backgroundColor'],
              label: topic['name'],
              labelColor: Colors.black, //topic['iconColor'],
              showIcon: false,
            ),
          )
          .toList();

      Widget aclsGrid = Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  color: Colors.red,
                  child: const Text(
                    'ACLS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: aclsButtons.sublist(0, 3),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: aclsButtons.sublist(3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      List<Widget> otherButtons = _toBeListed
          .sublist(6)
          .map(
            (topic) => CaseCardButton(
              onPressed: () {
                goEmergencyPage(context, topic['pageTitle']);
              },
              icon: topic['icon'],
              backgroundColor: topic['backgroundColor'],
              iconColor: topic['backgroundColor'],
              label: topic['name'],
              labelColor: Colors.black, //topic['iconColor'],
              fontSize: 14,
            ),
          )
          .toList();

      int idxDivide = (otherButtons.length / 2).ceil();
      Widget otherGrid = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Container(
                color: Colors.grey,
                child: const Row(
                  children: [
                    Spacer(),
                    Text(
                      'Other Scenarios',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 25),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: otherButtons.sublist(0, idxDivide),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: otherButtons.sublist(idxDivide),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      _buttonGrid = SingleChildScrollView(
        child: Column(
          children: [
            aclsGrid,
            otherGrid,
          ],
        ),
      );
    }
  }

  void searchTopics(String input) async {
    if (input == '') {
      setState(() {
        _toBeListed = emergencyTopics;
        searchResultsPresent = false;
        generateTileButtons();
      });
    } else {
      /// Searches for the emergency topics using Sherlock
      List<Result> searchResults = await _sherlock.search(input: input);
      if (searchResults.isNotEmpty) {
        /// If search results are not empty, set the list to the search results
        setState(() {
          _toBeListed = searchResults.sorted().unwrap();
          searchResultsPresent = true;
          generateTileButtons();
        });
      } else {
        /// If no search results, set the list to an empty list
        setState(() {
          _toBeListed = [];
          searchResultsPresent = true;
          generateTileButtons();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Emergency Manual',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
            )),
        backgroundColor: theme.colorScheme.error,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _searchBar,
          ),
          Expanded(child: _buttonGrid),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            color: theme.colorScheme.error,
            child: const Center(
              child: Text('\u00a9 Stanford Anesthesia Cognitive Aid Program, 2021',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class CaseButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color labelColor;

  final bool showIcon;

  const CaseButton({
    // Required Parameters
    super.key,
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,

    //Optional Parameters
    this.label = '',
    this.labelColor = Colors.black,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onPressed();
      },
      title: Text(label, style: const TextStyle(fontSize: 18)),
      visualDensity: const VisualDensity(vertical: -4),
      minVerticalPadding: 0,
      dense: true,
      //contentPadding: EdgeInsets.zero,
      leading: showIcon
          ? Icon(
              icon,
              color: iconColor,
              size: 22,
            )
          : null,
      textColor: labelColor,
    );
  }
}

class CaseCardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color labelColor;

  final bool showIcon;
  final double fontSize;
  final bool bold;

  const CaseCardButton({
    // Required Parameters
    super.key,
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,

    //Optional Parameters
    this.label = '',
    this.labelColor = Colors.black,
    this.showIcon = false,
    this.fontSize = 16,
    this.bold = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            label,
            style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
