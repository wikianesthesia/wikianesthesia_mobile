import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wikianesthesia_mobile/Home/search_wiki_bar.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:wikianesthesia_mobile/Home/wiki_api.dart';
import 'package:wikianesthesia_mobile/main.dart';

class LogoutPage extends ConsumerStatefulWidget {
  const LogoutPage({super.key});

  @override
  ConsumerState<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends ConsumerState<LogoutPage> {
  final GlobalKey webViewKey = GlobalKey();
  final CookieManager cookiesManager = CookieManager.instance();

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

    // Setup Pull to Refresh Controller
    if (kIsWeb ||
        ![TargetPlatform.iOS, TargetPlatform.android]
            .contains(defaultTargetPlatform)) {
      pullToRefreshController = null;
    } else {
      pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(
          color: Colors.blue,
        ),
        onRefresh: () async {
          if (defaultTargetPlatform == TargetPlatform.android) {
            webViewController?.reload();
          } else if (defaultTargetPlatform == TargetPlatform.iOS) {
            webViewController?.loadUrl(
                urlRequest: URLRequest(url: await webViewController?.getUrl()));
          }
        },
      );
    }
  }

  void clearCookies() {
    // Clear Cookies from cookie jar
    wikiAPI.clearCookies(ref);

    // Update the Riverpod provider
    ref.read(wikiUserNameProvider.notifier).setUserName('');
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
                      'https://wikianesthesia.org/w/index.php?title=Special:UserLogout&returnto=Asdfasdf')),
              initialSettings: settings,
              pullToRefreshController: pullToRefreshController,
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
                if (url.toString().contains('wiki/Special:UserLogout')) {
                  // If the URL contains 'Special:UserLogout', it means the user is logged out.
                  // Save cookies and pop to prior page
                  if (kDebugMode) {
                    print('User logged out successfully: $url');
                  }
                  clearCookies(); // Clear cookies on logout
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
