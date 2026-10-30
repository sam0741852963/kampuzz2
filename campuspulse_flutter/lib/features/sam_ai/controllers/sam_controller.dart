import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/sam_engine.dart';
import '../../auth/controllers/auth_controller.dart';

class SamState {
  final List<SamMessage> messages;
  final bool isTyping;
  final List<String> quickSuggestions;

  const SamState({
    required this.messages,
    this.isTyping = false,
    this.quickSuggestions = const [
      '📅 Next class & room',
      '⚠️ Can I bunk DBMS today?',
      '🗓️ Today\'s full timetable',
      '📚 Top DBMS handwritten notes',
      '🏆 Upcoming hackathons & fests',
      '🤝 How to find teammates for SIH?',
      '📊 Check overall attendance',
      '💡 Exam survival tips',
      '😄 Tell me a joke',
    ],
  });

  SamState copyWith({
    List<SamMessage>? messages,
    bool? isTyping,
    List<String>? quickSuggestions,
  }) {
    return SamState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      quickSuggestions: quickSuggestions ?? this.quickSuggestions,
    );
  }
}

class SamController extends StateNotifier<SamState> {
  final Ref _ref;

  SamController(this._ref) : super(const SamState(messages: [])) {
    _initGreeting();
  }

  void _initGreeting() {
    final user = _ref.read(authControllerProvider).currentUser;
    final firstName = user?.fullName.split(' ').first ?? 'Friend';

    final greeting = SamMessage(
      id: 'greeting',
      isUser: false,
      timestamp: DateTime.now(),
      text: 'Hey $firstName! 👋 I\'m **Sam**, your 24/7 AI Campus Copilot on **Kampuzz**.\n\n'
          'I\'m synced with your campus timetable, bunk-meter, study notes, and fests. Ask me anything or tap one of the quick suggestions below!',
      actions: const [
        SamAction(label: 'Next Lecture', icon: Icons.schedule_rounded, route: '/timetable'),
        SamAction(label: 'Safe Bunks', icon: Icons.calculate_rounded, route: '/bunk-meter'),
        SamAction(label: 'Study Hub', icon: Icons.menu_book_rounded, route: '/study'),
      ],
    );

    state = state.copyWith(messages: [greeting]);
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final user = _ref.read(authControllerProvider).currentUser;
    final userMsg = SamMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    // Realistic brief AI thinking delay (350ms)
    await Future.delayed(const Duration(milliseconds: 350));

    final aiReply = SamEngine.processQuery(trimmed, user);

    state = state.copyWith(
      messages: [...state.messages, aiReply],
      isTyping: false,
    );
  }

  void clearChat() {
    _initGreeting();
  }
}

final samControllerProvider = StateNotifierProvider<SamController, SamState>((ref) {
  return SamController(ref);
});
