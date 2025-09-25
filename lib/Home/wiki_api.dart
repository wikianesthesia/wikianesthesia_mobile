import 'dart:io' as io;

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
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

  List<List<String>> practiceGroups = [];

  // Initialize API
  Future<WikiAPI> initialize() async {
    await prepareJar();

    // Initialize the Dio instance with the cookie jar
    _dio.interceptors.add(CookieManager(cookieJar));

    // Initialize the secure storage
    secureStorage = const FlutterSecureStorage();

    // Read the logged-in state from secure storage
    String? loggedInState = await secureStorage.read(key: 'loggedIn');
    if (loggedInState != null) {
      loggedIn = loggedInState == 'true';
      if (loggedIn) {
        // If logged in, read the username
        userName = await secureStorage.read(key: 'userName') ?? '';
      }
    }

    return this;
  }

  Future<void> prepareJar() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    cookieJar = PersistCookieJar(
      storage: FileStorage('$appDocPath/.cookies/'),
      ignoreExpires: false,
    );
  }

  /// Load the username from secure storage and update the Riverpod provider
  Future<void> loadUsername(WidgetRef ref) async {
    // Get the username from secure storage
    userName = await secureStorage.read(key: 'userName') ?? '';
    // Update the Riverpod provider
    ref.read(wikiUserNameProvider.notifier).setUserName(userName);
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
    // Update the Riverpod provider
    ref.read(wikiUserNameProvider.notifier).setUserName('');
    ref.read(wikiPracticeGroupsProvider.notifier).setPracticeGroups([]);
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
  List<List<String>> getPracticeGroups(String html, var notifier) {
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

    // Update the Riverpod provider
    notifier.setPracticeGroups(practiceGroups);

    return practiceGroups;
  }

  /// Searches WikiAnesthesia API
  Future<List<SearchResult>> search(String query) async {
    if (query == '') {
      return List<SearchResult>.empty();
    }

    final queryParams = {
      'action': 'opensearch',
      'format': 'json',
      'search': query,
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
        return SearchResult.fromJson(response.data);
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

  static List<SearchResult> fromJson(List<dynamic> body) {
    /// Generates list of SearchResult items from a JSON returned from WikiAnesthesia
    List<dynamic> nameList = body[1];
    List<dynamic> urlList = body[3];

    return [
      for (int i = 0; i < nameList.length; i++)
        SearchResult(title: nameList[i], url: urlList[i])
    ];
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
