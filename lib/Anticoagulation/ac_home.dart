import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:wikianesthesia_mobile/Anticoagulation/ac_drugs.dart';
import 'package:wikianesthesia_mobile/Home/home_drawer.dart';
import 'package:wikianesthesia_mobile/Wiki/account_widget.dart';
import 'package:wikianesthesia_mobile/util.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sherlock/result.dart';
import 'package:sherlock/sherlock.dart';

class ACHome extends StatefulWidget {
  const ACHome({super.key});

  @override
  State<ACHome> createState() => _ACHome();
}

class _ACHome extends State<ACHome> {

  // List of Drugs to display
  List<Map<String,String>> _toBeListed = [];

  /// SearchBar Widget
  late Widget _searchBar;

  /// Text controller for the SearchBar
  final _controller = TextEditingController();

  /// Sherlock Instance for searching
  late final Sherlock _sherlock;


  @override
  void initState() {
    super.initState();
    getCodes();
    buildSearchBar();
  }

  List<Map<String,String>> sortDrugs(List<Map<String,String>> drugs) {
    drugs.sort((a, b) => a['Generic']!.compareTo(b['Generic']!));
    return drugs;
  }

  void getCodes() async {
    setState(() { 
      _toBeListed = sortDrugs(acDrugs);
      _sherlock = Sherlock(
        elements: acDrugs,
      );
    });
  }

  void buildSearchBar() {
    _searchBar = TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Search Anticoagulants',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton( // Gives button at end of SearchBar to clear input
          icon: const Icon(Icons.close),
          onPressed: () {
            _controller.clear();
            searchCodes('');
            FocusManager.instance.primaryFocus?.unfocus();
          },
          tooltip: 'Clear',
        )
      ),
      onChanged: (String input) {searchCodes(input);},
      onSubmitted: (String input) {searchCodes(input);},
      controller: _controller,
    );
  }


  void searchCodes(String input) async {
    if (input == '') {
      setState(() {
        _toBeListed = acDrugs;
      });
    } else {
      /// Searches for the emergency topics using Sherlock
      List<Result> searchResults = await _sherlock.search(input: input); 
      if (searchResults.isNotEmpty) {
        /// If search results are not empty, set the list to the search results
        setState(() {
          _toBeListed = searchResults.sorted().map((r) => r.element as Map<String, String>).toList();
        });
      } else {
        /// If no search results, set the list to an empty list
        setState(() {
          _toBeListed = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a toast message when the page is first opened
    // This is to inform the user that they can tap to call or long press to copy
    
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 15, top: 8.0),
          child: _searchBar,
        ),
        backgroundColor: theme.colorScheme.primary,
        actions: const [
          AccountWidget(),
        ],
      ),
      endDrawer: const HomeDrawer(),
      body: SafeArea(
        left: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 1.0, left: 2.0, right: 2.0, bottom: 0.0),
          child: Scrollbar(
            child: ListView(
              children: [
                const OpenDisclaimers(),
                const Divider(height: 0,),
                DrugListView(drugs: _toBeListed),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OpenDisclaimers extends StatelessWidget {
  const OpenDisclaimers({
    super.key,
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
            return const DisclaimersLog();
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

class DrugListTile extends StatelessWidget {
  final String drugName;
  final String brandName;
  final List<Map<String,String>> doseOptions;

  const DrugListTile({
    super.key,
    required this.drugName,
    required this.brandName,
    required this.doseOptions,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (doseOptions.isEmpty) {
          goACPage(context, drugName);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DoseLog(drugName: drugName, doseOptions: doseOptions);
            },
          );
        }
      },
      title: Text(drugName.trim()),
      subtitle: Text(brandName.trim()),
    );
  }
}

class DrugListView extends StatelessWidget {
  final List<Map<String,String>> drugs;

  const DrugListView({
    super.key,
    required this.drugs,
  });

  List<Widget> buildDrugListTiles() {
    // Get all unique drug names without dose options
    List<String> drugNames = drugs.map((drug) => drug['Generic']!.replaceAll(RegExp(r'\([^)]*\)'), '')).toList(); // Remove dose options in parentheses
    drugNames = drugNames.toSet().toList(); // Remove duplicates

    return drugNames.map((drug) {
      List<Map<String,String>> allMatches = acDrugs.where((d) => d['Generic']!.startsWith(drug)).toList();
      if (allMatches.length == 1 && allMatches[0]['Generic'] == drug) {
        // If only one match and no dose options, pass empty list
        return DrugListTile(drugName: drug, brandName: allMatches[0]['Brand'] ?? '', doseOptions: const []);
      } else {
        // Otherwise get all dose options
        List<Map<String,String>> doseOptions = allMatches.map((d) => {
          // Extract dose by removing drug name and trimming parentheses
          'Dose': d['Generic']!.replaceFirst(drug, '').trim().replaceAll(RegExp(r'^\(|\)$'), ''),
          'Brand': d['Brand'] ?? '',
          'Definition': d['Dose'] ?? '',
        }).toList();
        return DrugListTile(drugName: drug, brandName: allMatches[0]['Brand'] ?? '', doseOptions: doseOptions);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ListTile.divideTiles(tiles: buildDrugListTiles(), context: context).toList(),
    );
  }
}

class DisclaimersLog extends StatefulWidget {
  const DisclaimersLog({super.key});

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
    final String response = await rootBundle.loadString('assets/AC_Disclaimers.md');
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

class DoseLog extends StatelessWidget {
  final String drugName;
  final List<Map<String,String>> doseOptions;
  
  const DoseLog({super.key, required this.drugName, required this.doseOptions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> definitionWidgets = doseOptions.map((opt) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            //backgroundColor: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 14.0),
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            //side: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          onPressed: () {
            String target = '$drugName(${opt['Dose']})';
            Navigator.of(context).pop();
            goACPage(context, target);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                opt['Dose'] ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5,),
              MarkdownBody(
                shrinkWrap: true,
                styleSheet: MarkdownStyleSheet(
                  h3: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  h3Align: WrapAlignment.center,),
                data: opt['Definition'] ?? '',
              ),
            ],
          ),
        ),
      );
    }).toList();

    return AlertDialog(
      title: Text(drugName),
      actionsPadding: const EdgeInsets.only(bottom: 8.0, right: 8.0, top: 0.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Select a dose:', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 18),),
            ...definitionWidgets,
          ]
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ]
    );
  }
}