import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flavr/app.dart';
import 'package:flavr/data/local/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env is committed as a placeholder; real key injected by CI)
  await dotenv.load(fileName: '.env');

  // Initialize Hive and open required boxes
  await HiveService.init();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
