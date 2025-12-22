import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sherlock/result.dart';
import 'package:sherlock/sherlock.dart';
import 'package:wikianesthesia_mobile/EmergencyManual/acls_home.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';

import '../util.dart';
import './emergency_topics.dart';

class ACLSEmergencyChooser extends ConsumerWidget {
  const ACLSEmergencyChooser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<List<String>> practiceGroups = ref.watch(wikiPracticeGroupsProvider);
    List<String> dbKeys = [];

    if (practiceGroups.isNotEmpty) {
      dbKeys = practiceGroups
        .map((subList) => subList[0])
        .toList();
    }
    bool isHopkins = dbKeys.contains('Hopkins');

    if (isHopkins) {
      return const EmergencyHome();
    } else {
      return const ACLSHome();
    }

  }
}

class EmergencyHome extends StatefulWidget {
  const EmergencyHome({super.key});

  @override
  State<EmergencyHome> createState() => _EmergencyHomeState();
}

class _EmergencyHomeState extends State<EmergencyHome> {
  /// Displays the Emergency Page with a list of all scenarios with a search bar

  /// List of Scenarios to display (initialized as every scenario,
  /// but can be replaced by search results)
  List<Map<String, dynamic>> _toBeListed = [...emergencyTopics]; //Copy of emergencyTopics
  bool searchResultsPresent = false;
  late Widget _buttonGrid;

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
              FocusManager.instance.primaryFocus?.unfocus();
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
    _toBeListed.removeWhere((topic) => topic['pageTitle'] == 'HypoxiaDDx'); // Remove HypoxiaDDx from listing since it's hidden
    List<Widget> allButtons = [];

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
      _buttonGrid = const AllCasesTable();
    }
  }

  void searchTopics(String input) async {
    if (input == '') {
      setState(() {
        _toBeListed = [...emergencyTopics];
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
        title: Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 0.0, bottom: 15, top: 8.0),
          child: _searchBar,
        ),
            //Text('Emergency Manual',
            //style: TextStyle(
            //  color: theme.colorScheme.onPrimary,
            //)),
        backgroundColor: theme.colorScheme.error,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        top: false,
        left: false,
        child: Column(
          children: [
            Expanded(child: _buttonGrid),
            Container(
              width: MediaQuery.of(context).size.width,
              color: theme.colorScheme.error,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Center(
                    child: Text('\u00a9 Stanford Anesthesia Cognitive Aid Program',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
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
          child: Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class CaseTableEntry extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;
  final Color iconColor;
  final Color labelColor;

  final bool showIcon;
  final double fontSize;
  final bool bold;

  final double? height;
  final double? width;

  const CaseTableEntry({
    // Required Parameters
    super.key,
    required this.onPressed,
    required this.icon,
    required this.iconColor,

    //Optional Parameters
    this.label = '',
    this.labelColor = Colors.black,
    this.showIcon = false,
    this.fontSize = 16,
    this.bold = true,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
    color: theme.canvasColor,
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          onPressed();
        },
        child: SizedBox(
          height: height,
          width: width,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CasesTable extends StatelessWidget {
  final List<Widget> cases;
  final int columns;

  const CasesTable({super.key, required this.cases, this.columns = 2});

  @override
  Widget build(BuildContext context) {
    int numRows = (cases.length / columns).ceil();
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: const TableBorder.symmetric(inside: BorderSide(color: Colors.grey),
                                          outside: BorderSide(color: Colors.grey),),
      children: [
        for (int i = 0; i < numRows; i++)
          TableRow(
            children: [
              for (int j = 0; j < columns; j++)
                (i + j*numRows) < cases.length
                    ? cases[i + j*numRows]
                    : const SizedBox
                        .shrink(),
            ],
          ),
      ],
    );
  }
}

class AllCasesTable extends StatelessWidget {
  const AllCasesTable({super.key});


  @override
  Widget build(BuildContext context) {
    List allTopics = [...emergencyTopics];
    allTopics.removeWhere((topic) => topic['pageTitle'] == 'HypoxiaDDx'); // Remove HypoxiaDDx from listing since it's hidden

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (kDebugMode) {
          print('Max Width: ${constraints.maxWidth}');
          print('Max Height: ${constraints.maxHeight}');
        }
        int columns;
        if (constraints.maxWidth > 600) {
          columns = 3;
        } else if (constraints.maxWidth > 250) {
          columns = 2;
        } else {
          columns = 1;
        }

        if(kDebugMode) {
          print('Using $columns columns for Cases Table');
        }
        int numRows = (allTopics.length / columns).ceil();
        double height = constraints.minHeight / numRows;

        if (height < 25) {
          height = 25;
        }

        if (kDebugMode) {
          print('Using height $height for ${allTopics.length} Cases Table entries');
        }

        final List<Widget> allCases = allTopics
          .map(
            (topic) => CaseTableEntry(
              onPressed: () {
                goEmergencyPage(context, topic['pageTitle']);
              },
              icon: topic['icon'],
              iconColor: topic['backgroundColor'],
              label: topic['name'],
              labelColor: Colors.black, //topic['iconColor'],
              showIcon: false,
              height: height,
            ),
          )
          .toList();

        return Scrollbar(
          child: SingleChildScrollView(
            child: Table(
              border: const TableBorder.symmetric(inside: BorderSide(color: Colors.grey)),
              columnWidths: const {
                0: IntrinsicColumnWidth(),
              },
              defaultColumnWidth: const FlexColumnWidth(1),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Container(
                          color: Colors.red,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'ACLS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CasesTable(cases: allCases.sublist(0, 6), columns: columns),
                  ]
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: RotatedBox(
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 25),
                          ],
                        ),
                      ),
                    ),
                    ),
                    CasesTable(cases: allCases.sublist(6), columns: columns),
                  ]
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

/*
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
                        children: aclsButtons.sublist(0, 3).map((e) => Expanded(child: e)).toList(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: aclsButtons.sublist(3).map((e) => Expanded(child: e)).toList(),
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
                      children: otherButtons.sublist(0, idxDivide).map((e) => Expanded(child: e)).toList(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: otherButtons.sublist(idxDivide).map((e) => Expanded(child: e)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      */