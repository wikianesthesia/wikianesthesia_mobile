import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Home/search_wiki_bar.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/Wiki/practicegroup.dart';
import 'package:wikianesthesia_mobile/main.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey webViewKey = GlobalKey();
  final CookieManager cookiesManager = CookieManager.instance();

  final PracticeGroupFinder practiceGroupFinder = PracticeGroupFinder();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
    useShouldOverrideUrlLoading: false,
  );

  PullToRefreshController? pullToRefreshController;
  double _progress = 0; // For progress bar
  bool _isLoading = false;

  late PersistCookieJar cookieJar;

  @override
  void initState() {
    super.initState();

    practiceGroupFinder.init(ref);
  }

  Future<void> saveCookies() async {
    // Get all cookies from the InAppWebView and convert them to dio cookies
    var cookies = await cookiesManager.getCookies(
        url: WebUri('https://wikianesthesia.org'));
    if (cookies.isNotEmpty) {
      // Convert WebView cookies to io.Cookie format
      List<io.Cookie> ioCookies = cookies.map((cookie) {
        return io.Cookie(cookie.name, cookie.value)
          ..domain = cookie.domain
          ..path = cookie.path
          ..expires = cookie.expiresDate != null
              ? DateTime.fromMillisecondsSinceEpoch(cookie.expiresDate!)
              : null
          ..secure = cookie.isSecure ?? false
          ..httpOnly = cookie.isHttpOnly ?? false;
      }).toList();

      String userName = '';
      // Extract the username from the cookies
      if (ioCookies.isNotEmpty) {
        for (var cookie in ioCookies) {
          if (cookie.name == 'mediawiki_productionUserName') {
            userName = cookie.value;
            break;
          }
        }
      }

      // Save cookies to the cookie jar
      wikiAPI.saveCookies(ioCookies, userName);

      // Start fetching practice groups
      await practiceGroupFinder.start(userName);

      // Update the Riverpod providers
      ref.read(wikiUserNameProvider.notifier).setUserName(userName);

      if (kDebugMode) {
        print('Cookies saved: $ioCookies');
      }
    } else {
      if (kDebugMode) {
        print('No cookies found.');
      }
    }
  }

  void removeHeaderFooter(InAppWebViewController controller) async {
    var result = await controller.evaluateJavascript(
      source: '''
        var elements = document.getElementsByClassName("p-navbar not-collapsible");

        while(elements.length > 0){
          elements[0].parentNode.removeChild(elements[0]);
        }

        var header = document.getElementById("contentHeader");
        console.log('-------------------');
        header.id = 'newContentHeader';
        header.style.position = 'relative';
        header.style.top = '0px';

        
        document.getElementById("wpRemember").checked = true;
      ''',
    );
    if (kDebugMode) {
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 80,
          title: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: WikiSearchView(),
          ),
          titleSpacing: 8.0,
          backgroundColor: theme.colorScheme.primary,
          actions: kIsWeb
              ? null
              : [
                  FutureBuilder<bool>(
                    future:
                        webViewController?.canGoBack() ?? Future.value(false),
                    builder: (context, snapshot) {
                      final canGoBack = snapshot.data ?? false;
                      return IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: Colors.white,
                        disabledColor: Colors.grey,
                        onPressed: canGoBack
                            ? () {
                                webViewController?.goBack();
                              }
                            : null,
                      );
                    },
                  ),
                  FutureBuilder<bool>(
                    future: webViewController?.canGoForward() ??
                        Future.value(false),
                    builder: (context, snapshot) {
                      final canGoBack = snapshot.data ?? false;
                      return IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        color: Colors.white,
                        disabledColor: Colors.grey,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: canGoBack
                            ? () {
                                webViewController?.goForward();
                              }
                            : null,
                      );
                    },
                  ),
                ],
          leading: InkWell(
            onTap: () {
              context.go(
                '/',
              );
              FocusScope.of(context).unfocus();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 7.0),
              child: ImageIcon(
                AssetImage('assets/wikianesthesia_logo.png'),
                color: Colors.white,
                size: 16.0,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                  url: WebUri(
                      'https://wikianesthesia.org/w/index.php?title=Special:UserLogin&returnto=Asdfasdf')),
              initialSettings: settings,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                _isLoading = true;
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController?.endRefreshing();

                if (url.toString().contains('/wiki/Asdfasdf')) {
                  // If the URL contains 'Asdfasdf', it means the user is logged in.
                  // Save cookies and pop to prior page
                  if (kDebugMode) {
                    print('User logged in successfully: $url');
                  }
                  await saveCookies(); // Save cookies after login
                  Navigator.pop(context);
                }

                removeHeaderFooter(controller);
                setState(() {
                  _isLoading = false;
                });
              },
              onReceivedError: (controller, request, error) {
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }

                setState(() {
                  _progress = progress / 100;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                if (kDebugMode) {
                  print(consoleMessage);
                }
              },

            ),
            if (_progress < 1.0 || _isLoading)
              Container(
                color: Colors.white,
                child:
                    Center(child: CircularProgressIndicator(value: _progress)),
              ),
          ],
        ));
  }
}
