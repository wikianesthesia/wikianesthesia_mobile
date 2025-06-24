import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wikianesthesia_mobile/util.dart';

class WikiSearchView extends StatefulWidget {
  const WikiSearchView({super.key});

  @override
  State<WikiSearchView> createState() => _WikiSearchViewState();
}

class _WikiSearchViewState extends State<WikiSearchView> {
  final _debouncedSearch = _debounce<List<SearchResult>, String>(_WikiAPI.search, const Duration(milliseconds: 200));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10,),
        SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search),
              hintText: 'Search WikiAnesthesia',
              constraints: BoxConstraints(
                minHeight: 50,
                maxHeight: 50,
                minWidth: 10,
                maxWidth: MediaQuery.sizeOf(context).width - 30,
              ),
            );
          },
          isFullScreen: true,
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
                      itemCount: results.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(results[index].title),
                          onTap: () {
                            goWikiPage(context,results[index].url);
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
        ),
        const SizedBox(width: 10,),
      ],
    );
  }
}

// Searches WikiAnesthesia API.
class _WikiAPI {

  /// Searches WikiAnesthesia API
  static Future<List<SearchResult>> search(String query) async {
    if (query == '') {
      return List<SearchResult>.empty();
    }

    final queryParams = {
      'action': 'opensearch',
      'format': 'json',
      'search': query,
    };

    const String baseurl = 'wikianesthesia.org';
    final uri = Uri.https(baseurl,'/w/api.php', queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (response.body.isEmpty)  {
        return [];
      } else {
        return SearchResult.fromJson(response.body);
      }
    } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to access WikiAnesthesia API');
    }

  }
}

class SearchResult {
  final String title;
  final String url;

  const SearchResult({required this.title, required this.url});

  static List<SearchResult> fromJson(String body) {
    /// Generates list of SearchResult items from a JSON returned from WikiAnesthesia
    List<dynamic> resultList = jsonDecode(body);
    List<dynamic> nameList = resultList[1];
    List<dynamic> urlList = resultList[3];

    return [for(int i = 0; i<nameList.length; i++)
      SearchResult(title: nameList[i], url: urlList[i])
    ];
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