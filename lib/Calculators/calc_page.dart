import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wikianesthesia_mobile/Home/home_drawer.dart';
import 'package:wikianesthesia_mobile/Home/search_wiki_bar.dart';
import 'package:wikianesthesia_mobile/Wiki/account_widget.dart';

class CalcPage extends StatefulWidget {
  final String url;
  const CalcPage({super.key, required this.url});

  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllowFullscreen: true,
  );

  PullToRefreshController? pullToRefreshController;
  double _progress = 0; // For progress bar
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

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

  void removeHeaderFooter(InAppWebViewController controller) async {
    var result = await controller.evaluateJavascript(
      source: '''
        function waitForElement(selector, callback) {
          if (document.getElementById(selector)) {
            callback();
            return;
          }
          const observer = new MutationObserver(mutations => {
            if (document.getElementById(selector)) {
              callback();
              observer.disconnect();
            }
          });
          observer.observe(document.body, { childList: true, subtree: true });
        }
        
        var elements = document.getElementsByClassName("p-navbar not-collapsible");

        while(elements.length > 0){
          elements[0].parentNode.removeChild(elements[0]);
        }

        
        waitForElement("calculator-patients-patientInput", () => {
          console.log('-------------------');
          console.log('Found calculator-patients-patientInput');
          var header = document.getElementById("contentHeader");
          header.style.top = '0px';
          header.style.position = 'relative';
          var header = document.getElementById("contentHeader");
          header.id = 'newContentHeader';
        });

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
      endDrawer: const HomeDrawer(),
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
                  future: webViewController?.canGoBack() ?? Future.value(false),
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
                  future:
                      webViewController?.canGoForward() ?? Future.value(false),
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
                const AccountWidget(),
              ],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
            FocusScope.of(context).unfocus();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 7.0),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
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
              child: Center(child: CircularProgressIndicator(value: _progress)),
            )
        ],
      ),
    );
  }
}
