import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_proxy/shelf_proxy.dart';

import 'package:wikianesthesia_mobile/Offline/asset_maps.dart';

// TODO: Implement HTTPS

class OfflineServer {
  /// Starts a local HTTP server to enable offline access to WikiAnesthesia resources.
  
  late final int port;
  late final Cascade cascade;
  late final HttpServer server;

  static const Map<String,String> fileTypes = {
    '.html': 'text/html',
    '.css': 'text/css',
    '.js': 'application/javascript',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.woff': 'font/woff',
    '.woff2': 'font/woff2',
    '.ttf': 'font/ttf',
    '.ico': 'image/x-icon',
    '.svg': 'image/svg+xml',
    '.json': 'application/json',
  };

  late final shelf_router.Router _router;

  Future<int> findPort() async {
    /// Finds open port between 8080 and 8200
    // for (var p = 8080; p < 8200; p++) {
    //   try {
    //     final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, p);
    //     await server.close();
    //     return p;
    //   } catch (e) {
    //     // Port is in use, try next
    //     continue;
    //   }
    // }
    // throw Exception('No available ports found');
    return 8080; // For simplicity, just use 8080 for now
  }

  Future<String> start() async {
    /// Starts the offline server and returns the base URL
    
    port = await findPort();

    _router = shelf_router.Router()
      ..get('/load.php', _loadHandler)
      ..get('/w/load.php', _loadHandler)
      ..post('/w/api.php', _apiHandler)
      ..post('/api.php', _apiHandler);

    cascade = Cascade()
      .add(_router.call) // Router for specific paths
      .add(_staticFileHandler); // Default static file handler
      //.add(proxyHandler('https://wikianesthesia.org')); // If can't be found in offline assets, proxy to online site

    server = await shelf_io.serve(logRequests().addHandler(cascade.handler), InternetAddress.loopbackIPv4, port);

    if (kDebugMode) {
      print('Offline server running on http://localhost:${server.port}');
    }

    return 'http://localhost:$port';
  }

  Future<Response> _loadHandler(Request request) async {
    /// Handler for /w/load.php requests (MediaWiki loader)
    final String query = request.url.query;
    final String target = loadPHPMap[query] ?? '';
    if (kDebugMode) {
      print('Load Handler: ${request.url}');
      print('Query: $query');
      print('Mapped target: $target');
    }

    if (target.isEmpty) {
      return Response.notFound('Resource not found');
    }

    String extension = target.contains('.') ? target.substring(target.lastIndexOf('.')) : '';

    String content = '';
    try {
      // Check if the asset exists
      content = await rootBundle.loadString('assets/Offline/Assets/Loader/$target');
    } catch (e) {
      return Response.notFound('Resource not found');
    }

    if (kDebugMode) {
      print('Load.php request: $target');
      print('Extension: $extension');
    }

    return Response.ok(
      content,
      headers: {
        'Content-Type': fileTypes[extension] ?? 'application/octet-stream'
      },
    );
  }

  Future<Response> _apiHandler(Request request) async {
    /// Handler for /w/api.php requests (MediaWiki API)
    
    final String body = await request.readAsString();

    String response = apiMap[body] ?? '';

    if (response.isEmpty) {
      return Response.notFound('API action not found');
    }

    // Replace port numbers in the response if needed
    if (port != 8080) {
      response = response.replaceAll(':8080', ':$port');
    }
    
    return Response.ok(
      response,
      headers: {
        'Content-Type': 'application/json'
      },
    );
  }

  Future<Response> _staticFileHandler(Request request) async {
    /// First search for a static file in the assets. If not found, then return 404.
    
    final String path = request.url.path;
    final String target = 'assets/Offline/$path';



    if (kDebugMode) {
      print('Static file request: $target');
    }

    if (target.isEmpty) {
      return Response.notFound('Resource not found');
    }

    String extension = target.contains('.') ? target.substring(target.lastIndexOf('.')) : '';

    String content = '';
    try {
      // Check if the asset exists
      content = await rootBundle.loadString(target);
    } catch (e) {
      return Response.notFound('Resource not found');
    }

    return Response.ok(
      content,
      headers: {
        'Content-Type': fileTypes[extension] ?? 'application/octet-stream'
      },
    );
  }

  Future<void> stop() async {
    /// Stops the offline server
    await server.close(force: true);
    if (kDebugMode) {
      print('Offline server stopped');
    }
  }

}