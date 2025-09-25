import 'package:flutter/material.dart';
import 'dart:async';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/main.dart';
import 'package:wikianesthesia_mobile/util.dart';

class WikiSearchView extends StatefulWidget {
  const WikiSearchView({super.key});

  @override
  State<WikiSearchView> createState() => _WikiSearchViewState();
}

class _WikiSearchViewState extends State<WikiSearchView> {
  late final _Debounceable<List<SearchResult>, String> _debouncedSearch;

  @override
  void initState() {
    super.initState();
    initWikiAPI();
  }

  void initWikiAPI() async {
    // Initialize the WikiAPI and debounced search function
    _Debounceable<List<SearchResult>, String> search = _debounce<List<SearchResult>, String>(wikiAPI.search, const Duration(milliseconds: 200));
    setState(() {
      _debouncedSearch = search;
    });
  }

  Widget searchEntry(String query) {
    if (query.startsWith('PracticeGroup:')) {
      // If the query starts with 'PracticeGroup:', format it accordingly

      List<String> splitQuery = query.split('/');
      String practiceGroup = splitQuery[0];
      String articleTitle = splitQuery[1];
      practiceGroup = practiceGroup.replaceAll('PracticeGroup:', '');

      return Row(children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(practiceGroup, style: const TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(articleTitle)),
      ]);
    } else {
      // For other queries, just return the query text
      return Text(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 10.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          hintText: 'Search WikiAnesthesia',
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) async {
        if (controller.text.isEmpty) {
          return [];
        }
        
        return [FutureBuilder<List<SearchResult>?>(future: _debouncedSearch(controller.text),
          builder: (context,snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(
                title: Center(
                  child: LinearProgressIndicator(), // Show loading indicator
                ),
              ); // Show loading indicator
            } else if (snapshot.hasError) { // Show Error
              return ListTile(
                  title: Center(
                    child: Text('Error: ${snapshot.error}')
                  )
                ); 
            } else if (snapshot.hasData) {
              final results = snapshot.data!;
              if (results.isEmpty) {
                return const Center(child: Text('No suggestions found'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == results.length) {
                      // Add a search option at the end
                      return ListTile(
                        title: Text('Search for pages containing "${controller.text}"', style: const TextStyle(fontStyle: FontStyle.italic)),
                        leading: const Icon(Icons.search),
                        onTap: () {
                          goWikiPage(context,'https://wikianesthesia.org/wiki/Special:Search?search=${Uri.encodeComponent(controller.text)}');
                          controller.closeView(controller.text);
                        },
                      );
                    }

                    return ListTile(
                      title: searchEntry(results[index].title),
                      onTap: () {
                        goWikiPage(context,results[index].url);
                        controller.closeView(controller.text);
                      },
                    );
                  },
                );
              }
            } else {
              return const ListTile(
                  title: Center(
                    child: Text('No Suggestions Found')
                  )
                );
            }
          },
        )];
      },
    );
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function, Duration duration) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer(duration);
    try {
      await debounceTimer!.future;
    } on _CancelException {
      return null;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer(Duration duration) {
    _timer = Timer(duration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}