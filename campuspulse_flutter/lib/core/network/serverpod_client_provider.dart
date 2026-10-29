import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campuspulse_client/campuspulse_client.dart';

/// Serverpod client instance provider.
/// Defaults to local development server (http://localhost:8080/),
/// or connects to Serverpod Cloud in production.
final clientProvider = Provider<Client>((ref) {
  final client = Client(
    'http://localhost:8080/',
  );
  return client;
});
