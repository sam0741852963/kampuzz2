import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

Future<void> main(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  pod.webServer.addRoute(FlutterRoute(Directory('web')));

  // Start the server.
  await pod.start();
}
