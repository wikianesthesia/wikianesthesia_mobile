import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/main.dart';
// import 'package:worker_manager/worker_manager.dart';

class PracticeGroupFinder {
  InAppWebViewController? webViewController;
  String url = "";
  late WidgetRef ref;
  late Notifier notifierPracticeGroup;
  late Notifier notifierFullName;

  void init(WidgetRef passedRef) {
    ref = passedRef;
    notifierPracticeGroup = ref.read(wikiPracticeGroupsProvider.notifier);
    notifierFullName = ref.read(wikiFullNameProvider.notifier);
  }

  Future<void> start(String userName) async {
    await wikiAPI.loadPracticeGroups(ref);
    
    if (wikiAPI.practiceGroups.isNotEmpty) {
      if (kDebugMode) {
        print('Practice groups already loaded.');
      }
      return;
    }

    if (userName.isEmpty) {
      if (kDebugMode) {
        print('Username is empty. Cannot find practice group.');
      }
      return;
    }

    loadPage(userName);
  }

  void loadPage(String userName) {
    HeadlessInAppWebView headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: WebUri("https://wikianesthesia.org/wiki/User:$userName")),
      onWebViewCreated: (controller) {
        // WebView created
        webViewController = controller;
      },
      onConsoleMessage: (controller, consoleMessage) {
        // Print console messages
        if (kDebugMode) {
          print('Console Message: ${consoleMessage.message}');
        }
      },
      onLoadStop: (controller, url) async {
        String html = await controller.evaluateJavascript(
            source: "document.documentElement.outerHTML;");
        wikiAPI.getPracticeGroups(html, notifierPracticeGroup, notifierFullName);
      },
    );

    headlessWebView.run();
  }
}
