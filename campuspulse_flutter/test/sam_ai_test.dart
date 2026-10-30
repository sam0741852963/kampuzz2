import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campuspulse_flutter/features/sam_ai/domain/sam_engine.dart';
import 'package:campuspulse_flutter/features/sam_ai/controllers/sam_controller.dart';
import 'package:campuspulse_flutter/features/sam_ai/presentation/sam_copilot_screen.dart';
import 'package:campuspulse_flutter/features/auth/controllers/auth_controller.dart';
import 'package:campuspulse_flutter/core/theme/app_theme.dart';

void main() {
  group('Sam AI Campus Knowledge Engine Tests', () {
    final demoUser = kDemoUsers[0]; // Aarav Sharma

    test('Answers next class query with room location and faculty', () {
      final reply = SamEngine.processQuery('what is my next class?', demoUser);

      expect(reply.isUser, isFalse);
      expect(reply.text, contains('Design & Analysis of Algorithms Lab'));
      expect(reply.text, contains('CS Lab 3'));
      expect(reply.text, contains('Prof. R. Sen'));
      expect(reply.actions.any((a) => a.route == '/timetable'), isTrue);
    });

    test('Answers today schedule query with all 4 classes', () {
      final reply = SamEngine.processQuery('show me my schedule for today', demoUser);

      expect(reply.isUser, isFalse);
      expect(reply.text, contains('DBMS'));
      expect(reply.text, contains('Operating Systems'));
      expect(reply.text, contains('DAA Lab'));
      expect(reply.text, contains('Computer Networks'));
    });

    test('Bunk DBMS query calculates safe bunks accurately', () {
      final reply = SamEngine.processQuery('can i bunk dbms today?', demoUser);

      expect(reply.isUser, isFalse);
      expect(reply.text, contains('Yes, you can bunk DBMS today!'));
      expect(reply.text, contains('26/30'));
      expect(reply.actions.any((a) => a.route == '/bunk-meter'), isTrue);
    });

    test('Bunk DAA query warns critically against skipping', () {
      final reply = SamEngine.processQuery('can i bunk daa?', demoUser);

      expect(reply.isUser, isFalse);
      expect(reply.text, contains('DO NOT Bunk DAA'));
      expect(reply.text, contains('63.6%'));
    });

    test('Notes query recommends top handwritten DBMS notes', () {
      final reply = SamEngine.processQuery('where can i find handwritten notes?', demoUser);

      expect(reply.isUser, isFalse);
      expect(reply.text, contains('Sahab Raza'));
      expect(reply.text, contains('DBMS'));
      expect(reply.actions.any((a) => a.route == '/study'), isTrue);
    });

    test('Events query returns HackPulse 2026 hackathon details', () {
      final reply = SamEngine.processQuery('upcoming hackathons on campus', demoUser);

      expect(reply.isUser, isFalse);
      expect(reply.text, contains('HackPulse 2026'));
      expect(reply.actions.any((a) => a.route == '/home'), isTrue);
    });

    test('Empathetic exam stress advice provides practical tips', () {
      final reply = SamEngine.processQuery('i am feeling so stressed about exams', demoUser);

      expect(reply.isUser, isFalse);
      expect(reply.text, contains('Take a Deep Breath, Aarav'));
      expect(reply.text, contains('Pomodoro'));
    });
  });

  group('Sam AI Controller State Tests', () {
    test('Initializes with greeting and quick suggestions', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(samControllerProvider);
      expect(state.messages.length, equals(1));
      expect(state.messages.first.text, contains('I\'m **Sam**'));
      expect(state.quickSuggestions.isNotEmpty, isTrue);
    });

    test('Sending a message adds user query and receives Sam response', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(samControllerProvider.notifier).sendMessage('next lecture');

      final state = container.read(samControllerProvider);
      expect(state.messages.length, equals(3)); // Initial greeting + user msg + AI reply
      expect(state.messages[1].isUser, isTrue);
      expect(state.messages[1].text, equals('next lecture'));
      expect(state.messages[2].isUser, isFalse);
      expect(state.messages[2].text, contains('Design & Analysis of Algorithms'));
    });

    test('Clear chat resets back to initial greeting', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(samControllerProvider.notifier).sendMessage('bunk dbms');
      expect(container.read(samControllerProvider).messages.length, equals(3));

      container.read(samControllerProvider.notifier).clearChat();
      expect(container.read(samControllerProvider).messages.length, equals(1));
    });
  });

  testWidgets('SamCopilotScreen renders title, suggestions, and input', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SamCopilotScreen(),
        ),
      ),
    );

    expect(find.text('Sam AI Copilot'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('📅 Next class & room'), findsOneWidget);
    expect(find.text('⚠️ Can I bunk DBMS today?'), findsOneWidget);
  });
}
