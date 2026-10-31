import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    throw ArgumentError(
      'Usage: dart tool/build_flutter_web.dart <Serverpod Cloud API URL>',
    );
  }

  final apiUrl = Uri.parse(args.single);
  if (apiUrl.scheme != 'https' || !apiUrl.hasAuthority) {
    throw ArgumentError.value(
      args.single,
      'apiUrl',
      'Must be an absolute HTTPS URL.',
    );
  }

  final serverDirectory = Directory.current;
  final flutterDirectory = Directory.fromUri(
    serverDirectory.parent.uri.resolve('campuspulse_flutter/'),
  );
  if (!File.fromUri(serverDirectory.uri.resolve('scloud.yaml')).existsSync() ||
      !File.fromUri(
        flutterDirectory.uri.resolve('pubspec.yaml'),
      ).existsSync()) {
    throw StateError(
      'Run this script from campuspulse_server in the Kampuzz repository.',
    );
  }

  final webDirectory = Directory.fromUri(serverDirectory.uri.resolve('web/'));
  final result = await Process.run(
    'flutter',
    [
      'build',
      'web',
      '--release',
      '--base-href',
      '/',
      '--dart-define=SERVERPOD_API_URL=$apiUrl',
      '--output',
      webDirectory.path,
    ],
    workingDirectory: flutterDirectory.path,
    runInShell: Platform.isWindows,
  );

  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    exit(result.exitCode);
  }
}
