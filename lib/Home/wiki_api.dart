import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wiki_api.g.dart';

// Searches WikiAnesthesia API.
class WikiAPI {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://wikianesthesia.org/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  late final PersistCookieJar cookieJar;
  late final FlutterSecureStorage secureStorage;
  late bool loggedIn = false;
  String userName = '';
  String fullName = '';

  List<List<String>> practiceGroups = [];

  // Initialize API
  Future<WikiAPI> initialize() async {
    await prepareJar();

    if (!kIsWeb) {
      // Initialize the Dio instance with the cookie jar
      _dio.interceptors.add(CookieManager(cookieJar));
    }

    // Initialize the secure storage
    secureStorage = const FlutterSecureStorage();

    try {
      // Read the logged-in state from secure storage
      String? loggedInState = await secureStorage.read(key: 'loggedIn') ;
      if (loggedInState != null) {
        loggedIn = loggedInState == 'true';
        if (loggedIn) {
          // If logged in, read the username
          userName = await secureStorage.read(key: 'userName') ?? '';
          fullName = await secureStorage.read(key: 'fullName') ?? '';
        }
      }
    } on PlatformException {
      // Workaround for https://github.com/mogol/flutter_secure_storage/issues/43
      await secureStorage.deleteAll();
    }

    return this;
  }

  Future<void> prepareJar() async {
    if (kIsWeb) {
      // Web does not support file storage for cookies
      cookieJar = PersistCookieJar(ignoreExpires: false);
      return;
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      cookieJar = PersistCookieJar(
        storage: FileStorage('$appDocPath/.cookies/'),
        ignoreExpires: false,
      );
    }
  }

  /// Load the username from secure storage and update the Riverpod provider
  Future<void> loadUsername(WidgetRef ref) async {
    // Get the username from secure storage
    userName = await secureStorage.read(key: 'userName') ?? '';
    // Update the Riverpod provider
    ref.read(wikiUserNameProvider.notifier).setUserName(userName);

    fullName = await secureStorage.read(key: 'fullName') ?? '';
    ref.read(wikiFullNameProvider.notifier).setUserName(fullName);
  }

  void clearCookies(WidgetRef ref) async {
    cookieJar.deleteAll();
    loggedIn = false;
    userName = '';
    practiceGroups = [];
    secureStorage.write(key: 'loggedIn', value: 'false');
    secureStorage.write(key: 'userName', value: '');
    secureStorage.write(key: 'practiceGroups', value: '');
    secureStorage.write(key: 'practiceGroupsLoaded', value: 'false');
    secureStorage.write(key: 'practiceGroupsLastUpdated', value: '');
    secureStorage.write(key: 'fullName', value: '');
    // Update the Riverpod provider
    ref.read(wikiUserNameProvider.notifier).setUserName('');
    ref.read(wikiPracticeGroupsProvider.notifier).setPracticeGroups([]);
    ref.read(wikiFullNameProvider.notifier).setUserName('');
  }

  void saveCookies(List<io.Cookie> ioCookies, String userName) async {
    // Save cookies to the cookie jar
    await cookieJar.saveFromResponse(
      Uri.parse('https://wikianesthesia.org'),
      ioCookies,
    );

    await secureStorage.write(
      key: 'loggedIn',
      value: 'true',
    );

    // Save the username to secure storage
    await secureStorage.write(
      key: 'userName',
      value: userName,
    );
  }

  /// Check if practice groups are already loaded in secure storage, and then load it
  Future<List<List<String>>> loadPracticeGroups(WidgetRef ref) async {
    List<List<String>> practiceGroups = [];

    // Check if practice groups are already loaded and were updated within the last day
    bool practiceGroupsLoaded =
        await secureStorage.read(key: 'practiceGroupsLoaded') == 'true';
    String? practiceGroupsLastUpdated =
        await secureStorage.read(key: 'practiceGroupsLastUpdated');

    if (kDebugMode) {
      print('Practice groups loaded: $practiceGroupsLoaded');
      print('Practice groups last updated: $practiceGroupsLastUpdated');
    }

    if (practiceGroupsLoaded &&
        practiceGroupsLastUpdated != null &&
        DateTime.parse(practiceGroupsLastUpdated)
            .isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      // Practice groups already loaded
      practiceGroups = await secureStorage.read(key: 'practiceGroups').then(
          (value) => value != null
              ? value.split('||').map((e) => e.split('|')).toList()
              : []);
      ref
          .read(wikiPracticeGroupsProvider.notifier)
          .setPracticeGroups(practiceGroups);

      if (kDebugMode) {
        print('Practice Groups: $practiceGroups');
      }
      return practiceGroups;
    }

    // Update the Riverpod provider
    ref
        .read(wikiPracticeGroupsProvider.notifier)
        .setPracticeGroups(practiceGroups);

    return practiceGroups;
  }

  /// Scrapes all of user's Practice Groups from WikiAnesthesia.
  /// Returns as List of List of Strings. First List is the dbkey, second is the shortname, third is the full name.
  List<List<String>> getPracticeGroups(String html, var notifierPracticeGroup, var notifierFullName) {
    // Use RegExp to find practice groups in the HTML file of the user profile
    RegExp expSpan = RegExp(
        r'<span data-dbkey="(.*)" data-shortname="(.*)".*>(.*)<\/span>',
        multiLine: true);
    Iterable<RegExpMatch> matches = expSpan.allMatches(html);

    if (matches.isNotEmpty) {
      practiceGroups = matches
          .map((m) => [m.group(1) ?? '', m.group(2) ?? '', m.group(3) ?? ''])
          .toList();
    } else {
      practiceGroups = []; // Return empty list if no practice groups found
    }

    // Use RegEx to find full name in the HTML file of the user profile
    expSpan = RegExp(
        r'<title>(.*) - WikiAnesthesia<\/title>',
        multiLine: true);
    matches = expSpan.allMatches(html);

    String fullName = '';
    if (matches.isNotEmpty) {
      fullName = matches.first.group(1) ?? '';
      notifierFullName.setUserName(fullName);
    } else {
      notifierFullName.setUserName(''); // Return empty string if no full name found
    }

    // Save Practice Groups to secure storage
    secureStorage.write(
      key: 'practiceGroups',
      value: practiceGroups.map((e) => e.join('|')).join('||'),
    );

    secureStorage.write(
      key: 'practiceGroupsLoaded',
      value: practiceGroups.isNotEmpty ? 'true' : 'false',
    );

    secureStorage.write(
      key: 'practiceGroupsLastUpdated',
      value: DateTime.now().toIso8601String(),
    );

    secureStorage.write(key: 'fullName', value: fullName);

    // Update the Riverpod provider
    notifierPracticeGroup.setPracticeGroups(practiceGroups);

    return practiceGroups;
  }

  /// Searches WikiAnesthesia API
  Future<SearchResultList> search(String query) async {
    if (query == '') {
      return SearchResultList.empty();
    }

    final queryParams = {
      'action': 'opensearch',
      'format': 'json',
      'search': query,
      'origin': '*',
    };

    // Construct the URI for the API request
    const String endpoint = 'w/api.php';
    final response = await _dio.get(endpoint, queryParameters: queryParams);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (response.data.isEmpty) {
        return SearchResultList.empty();
      } else {
        return fromSearchJson(response.data);
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to access WikiAnesthesia API');
    }
  }

  Future<SearchResultList> fromSearchJson(List<dynamic> body) async {
    /// Generates list of SearchResult items from a JSON returned from WikiAnesthesia
    List<String> nameList = body[1].cast<String>();
    List<String> urlList = body[3].cast<String>();

    return SearchResultList(
      allTitles: nameList,
      allURLs: urlList,
    );
  }

  /// Searches WikiAnesthesia API
  Future<List<int>> getArticleScores(List<String> titles) async {
    if (titles.isEmpty) {
      return List<int>.empty();
    }

    final queryParams = {
      'action': 'articlescores',
      'format': 'json',
      'asaction': 'getscores',
      'titles': titles.join('|'),
      'origin': '*',
    };

    // Construct the URI for the API request
    const String endpoint = 'w/api.php';
    final response = await _dio.get(endpoint, queryParameters: queryParams);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (response.data.isEmpty) {
        return [];
      } else {
        Map<String,dynamic> body = response.data;
        return fromScoreJson(titles, body);
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to access WikiAnesthesia API');
    }
  }

  List<int> fromScoreJson(List<String> titles,Map<String,dynamic> body) {
    Map<String,dynamic> entries = body['articlescores']['getscores']['result'];
    
    List<int> scores = [];

    for (var title in titles) {
      var entry = entries[title];
      if (!entry.isEmpty) {
        scores.add(int.parse(entry['EditorRating']['main']['value'] ?? '-1'));
      } else {
        scores.add(-1);
      }
    }

    return scores;
  }
}

class SearchResult {
  final String title;
  final String url;
  final int score;

  const SearchResult({required this.title, required this.url, required this.score});
}

class SearchResultList {
  final List<String> allTitles;
  final List<String> allURLs;

  const SearchResultList({required this.allTitles, required this.allURLs});

  bool get isEmpty {
    return allTitles.isEmpty;
  }

  static empty() {
    return const SearchResultList(allTitles: [], allURLs: []);
  }

}

@Riverpod(keepAlive: true)
class WikiUserName extends _$WikiUserName {
  @override
  String build() {
    // Initialize with an empty string or a default value
    return '';
  }

  void setUserName(String name) {
    // Update the state with the new username
    state = name;
  }
}

@Riverpod(keepAlive: true)
class WikiFullName extends _$WikiFullName {
  @override
  String build() {
    // Initialize with an empty string or a default value
    return '';
  }

  void setUserName(String name) {
    // Update the state with the new username
    state = name;
  }
}

@Riverpod(keepAlive: true)
class WikiPracticeGroups extends _$WikiPracticeGroups {
  @override
  List<List<String>> build() {
    // Initialize with an empty list or a default value
    return [];
  }

  void setPracticeGroups(List<List<String>> groups) {
    // Update the state with the new practice groups
    state = groups;
  }
}
