import 'package:flutter/material.dart';
import 'package:campuspulse_client/campuspulse_client.dart';
import '../../../core/utils/bunk_math.dart';

/// Action chip attached to Sam's response allowing 1-tap navigation
class SamAction {
  final String label;
  final IconData icon;
  final String route;

  const SamAction({
    required this.label,
    required this.icon,
    required this.route,
  });
}

/// Message model for Sam AI Copilot
class SamMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<SamAction> actions;

  const SamMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.actions = const [],
  });
}

/// Intelligent Campus Knowledge Engine powering Sam AI Copilot
class SamEngine {
  /// Generate smart, context-aware responses for general chat, timetable, bunk-meter, notes & campus fests
  static SamMessage processQuery(String input, UserProfile? user) {
    final query = input.trim().toLowerCase();
    final firstName = user?.fullName.split(' ').first ?? 'Friend';
    final now = DateTime.now();
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // 1. TIMETABLE & SCHEDULE QUERIES
    if (_matches(query, ['next class', 'next lecture', 'where to go', 'current class', 'what class'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '📍 **Your Next Lecture:**\n\n'
            '• **Design & Analysis of Algorithms Lab (CS503)**\n'
            '• **Time:** 11:30 AM – 01:00 PM\n'
            '• **Location:** CS Lab 3 (Computer Dept, 2nd Floor)\n'
            '• **Faculty:** Prof. R. Sen\n\n'
            '💡 *Tip: Don\'t forget your lab record book!*',
        actions: const [
          SamAction(label: 'Open Full Timetable', icon: Icons.calendar_today_rounded, route: '/timetable'),
          SamAction(label: 'Check Bunk-Meter', icon: Icons.calculate_rounded, route: '/bunk-meter'),
        ],
      );
    }

    if (_matches(query, ['today schedule', 'timetable', 'schedule', 'classes today', 'what classes', 'lectures today', 'classes'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '📅 **Today\'s Schedule for $firstName (${user?.sectionName ?? "CSE-3A"}):**\n\n'
            '1. **09:00 – 10:00 AM:** DBMS (CS501) • LHC-101 • Prof. V. Sharma\n'
            '2. **10:15 – 11:15 AM:** Operating Systems (CS502) • LHC-204 • Dr. Neha Gupta\n'
            '3. **11:30 – 01:00 PM:** DAA Lab (CS503) • CS Lab 3 • Prof. R. Sen *(Next up)*\n'
            '4. **02:00 – 03:00 PM:** Computer Networks (CS504) • LHC-102 • Dr. K. Iyer\n\n'
            'Total: 4 classes (3 lectures, 1 lab).',
        actions: const [
          SamAction(label: 'View Timetable Grid', icon: Icons.calendar_month_rounded, route: '/timetable'),
        ],
      );
    }

    // 2. BUNK & ATTENDANCE QUERIES
    if (_matches(query, ['bunk dbms', 'can i bunk dbms', 'dbms bunk', 'skip dbms'])) {
      final safeBunks = BunkMath.safeBunks(26, 30, 75.0);
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '✅ **Yes, you can bunk DBMS today!**\n\n'
            '• Current Attendance: **26/30 (86.7%)**\n'
            '• Safe Bunks Remaining: **$safeBunks classes**\n'
            '• If you bunk today, your attendance will become **26/31 (83.9%)**, which is still safely above the 75% institute threshold.\n\n'
            'Enjoy your break, but keep an eye on upcoming quizzes!',
        actions: const [
          SamAction(label: 'Bunk-Meter Simulator', icon: Icons.calculate_rounded, route: '/bunk-meter'),
        ],
      );
    }

    if (_matches(query, ['bunk daa', 'can i bunk daa', 'daa bunk', 'skip daa'])) {
      final recovery = BunkMath.recoveryClasses(14, 22, 75.0);
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '🚨 **Warning: DO NOT Bunk DAA!**\n\n'
            '• Current Attendance: **14/22 (63.6%)** ⚠️ Critical Red Alert!\n'
            '• You need to attend **$recovery consecutive lectures** without missing any to get back above the 75% safe zone.\n'
            '• Missing today will push your attendance down to **60.8%**, risking exam debarment!',
        actions: const [
          SamAction(label: 'Check Recovery in Bunk-Meter', icon: Icons.warning_amber_rounded, route: '/bunk-meter'),
        ],
      );
    }

    if (_matches(query, ['bunk os', 'can i bunk os', 'operating systems bunk'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '⚠️ **Careful! OS is right on the edge.**\n\n'
            '• Current Attendance: **21/28 (75.0%)**\n'
            '• Safe Bunks Remaining: **0 classes**\n'
            '• If you skip 1 lecture, your attendance drops to **72.4%** (Amber Alert). You must attend today\'s lecture to stay safe.',
        actions: const [
          SamAction(label: 'Open Bunk-Meter', icon: Icons.calculate_rounded, route: '/bunk-meter'),
        ],
      );
    }

    if (_matches(query, ['attendance', 'bunk meter', 'bunks', 'how many bunks', 'safe bunks'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '📊 **Your Attendance Overview:**\n\n'
            '• **Database Management:** 26/30 (86.7%) 🟢 2 Safe Bunks\n'
            '• **Operating Systems:** 21/28 (75.0%) 🟡 0 Safe Bunks (Borderline)\n'
            '• **Algorithms (DAA):** 14/22 (63.6%) 🔴 10 Recovery Classes Needed\n'
            '• **Computer Networks:** 19/20 (95.0%) 🟢 4 Safe Bunks\n\n'
            'Overall Average: **80.0%** (Safe across institute rules).',
        actions: const [
          SamAction(label: 'Launch What-If Simulator', icon: Icons.tune_rounded, route: '/bunk-meter'),
        ],
      );
    }

    // 3. STUDY NOTES & ACADEMIC HELP
    if (_matches(query, ['notes', 'dbms notes', 'study', 'handwritten notes', 'pyq', 'exam notes', 'cheatsheet'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '📚 **Top Recommended Notes in Study Hub:**\n\n'
            '1. **DBMS Comprehensive Handwritten Notes** (SQL + Normalization + B-Trees)\n'
            '   • Uploaded by: Sahab Raza (SGPA 9.2)\n'
            '   • Rating: ⭐ 4.9 (34 reviews) • 128 downloads\n'
            '2. **OS Concurrency & Virtual Memory Cheatsheet** (Banker\'s Algo & Semaphores)\n'
            '   • Uploaded by: Aarav Sharma (SGPA 9.4)\n'
            '   • Rating: ⭐ 4.8 • Quick 1-page formula guide',
        actions: const [
          SamAction(label: 'Browse Study Hub', icon: Icons.menu_book_rounded, route: '/study'),
        ],
      );
    }

    // 4. HACKATHONS, FESTS & EVENTS
    if (_matches(query, ['hackathon', 'fest', 'events', 'event', 'upcoming', 'competition', 'hackpulse', 'music'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '🏆 **Upcoming Flagship Campus Events:**\n\n'
            '1. **HackPulse 2026: 36-Hr National Hackathon**\n'
            '   • Dates: Nov 5 – Nov 6, 2026\n'
            '   • Prize Pool: ₹3,00,000 + Internship interviews\n'
            '   • Registration Closes in 14 hours! ⚡\n\n'
            '2. **Acoustic Night & Open Mic Under Stars**\n'
            '   • Nov 8, 2026 • 6:30 PM • Open Air Theatre (OAT)\n'
            '   • Free snacks & open poetry!\n\n'
            '3. **RoboWars 2026 (Combat Robotics)**\n'
            '   • Nov 12, 2026 • SAC Indoor Sports Complex',
        actions: const [
          SamAction(label: 'View Event Feed', icon: Icons.dynamic_feed_rounded, route: '/home'),
          SamAction(label: 'Find Teammates', icon: Icons.handshake_rounded, route: '/connect'),
        ],
      );
    }

    // 5. TEAMMATE DISCOVERY & CONNECT
    if (_matches(query, ['team', 'teammate', 'partner', 'connect', 'sih', 'find partner', 'group'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '🤝 **Finding Teammates with Sam AI:**\n\n'
            'In the **Connect** tab, you set your project goal (e.g. Smart India Hackathon or study group), pick desired skills (like Flutter, Python, or Embedded C), and Kampuzz matches you with compatible peers based on skills, batch, and SGPA.\n\n'
            'You can swipe candidate profile cards and connect with a 3-message pre-acceptance invite!',
        actions: const [
          SamAction(label: 'Launch Connect Wizard', icon: Icons.handshake_rounded, route: '/connect'),
        ],
      );
    }

    // 6. CAMPUS RENTALS & GEAR
    if (_matches(query, ['rent', 'calculator', 'drafter', 'borrow', 'buy', 'drafter', 'raspberry pi', 'lab coat'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '🛒 **Campus Peer-to-Peer Rental Marketplace:**\n\n'
            'Need gear for labs or midsems? Students list items at pocket-friendly daily rates:\n'
            '• **Casio fx-991EX Scientific Calculator:** ₹20/day (Nilgiri Hostel)\n'
            '• **Engineering Mini Drafter + Tube:** ₹25/day (Mech Block)\n'
            '• **White Lab Coat + Safety Goggles:** ₹15/day\n'
            '• **Raspberry Pi 4 (4GB):** ₹60/day\n\n'
            'You can also list your unused items to earn extra pocket money!',
        actions: const [
          SamAction(label: 'Open Campus Rental', icon: Icons.storefront_rounded, route: '/rent'),
        ],
      );
    }

    // 7. QUIZ ARENA & STUDY GAMES
    if (_matches(query, ['quiz', 'arena', 'battle', 'game', 'elo', 'compete', 'leaderboard'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '🎮 **Quiz Arena Battles:**\n\n'
            'Level up your technical prep through rapid gamified rounds:\n'
            '• **Solo Practice:** 5 adaptive questions with explanations\n'
            '• **1v1 Live Ranked Matchmaking:** Battle live with batchmates\n'
            '• **Leaderboard Podium:** Top 3 students get gold, silver, and bronze badges!\n\n'
            'Current Topics: DBMS, Operating Systems, Computer Networks, and DAA.',
        actions: const [
          SamAction(label: 'Play Quiz Battle', icon: Icons.sports_esports_rounded, route: '/arena'),
        ],
      );
    }

    // 8. EXAM PREP & MOTIVATION
    if (_matches(query, ['stress', 'stressed', 'tired', 'exam', 'midsem', 'tips', 'anxious', 'scared', 'fail'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '☕ **Take a Deep Breath, $firstName.**\n\n'
            'Engineering midsems can feel overwhelming, but remember:\n'
            '1. **Focus on high-yield units first:** SQL queries and Normalization in DBMS, Banker\'s Algorithm and Paging in OS.\n'
            '2. **Solve last 3 years PYQs:** 70% of exam patterns repeat with slight numerical changes.\n'
            '3. **Use the 25-5 Pomodoro:** 25 mins deep study, 5 mins walk or chai.\n'
            '4. Sleep at least 6 hours before the exam day—a rested brain debugs faster than a sleep-deprived one!\n\n'
            'You\'ve got this! Kampuzz is right here with notes and support.',
        actions: const [
          SamAction(label: 'Check Study Hub Notes', icon: Icons.menu_book_rounded, route: '/study'),
        ],
      );
    }

    // 9. HOSTEL LIFE & GENERAL CHIT-CHAT
    if (_matches(query, ['maggi', 'hostel', 'canteen', 'food', 'hungry', 'night canteen'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '🍜 **Hostel Survival Pro-Tips:**\n\n'
            '• **Elite Maggi Formula:** Fry garlic & green chili in hostel butter, add half a cheese slice with Maggi tastemaker, and don\'t over-boil the water!\n'
            '• **Late-Night Canteen:** SAC Night Canteen is open till 2:30 AM for hot parathas, cold coffee, and bun-omelette.\n'
            '• Need a quick study snack? Nilgiri & Kumaon hostel juice corners are open till midnight.',
        actions: const [
          SamAction(label: 'Check Campus Communities', icon: Icons.groups_rounded, route: '/community'),
        ],
      );
    }

    if (_matches(query, ['who are you', 'what are you', 'sam', 'what can you do', 'help', 'features'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '🤖 **I\'m Sam — your personal AI Copilot for Kampuzz!**\n\n'
            'Here is everything I can do for you 24/7:\n\n'
            '• 📅 **Timetable & Schedule:** Remind you of today\'s lectures, lab rooms, and professor details.\n'
            '• ⚠️ **Bunk-Meter Intelligence:** Calculate safe bunks and recovery lectures using real mathematical formulas.\n'
            '• 📚 **Study Hub Navigator:** Find handwritten notes, cheatsheets, and PYQs.\n'
            '• 🏆 **Hackathons & Fests:** Keep you updated on campus events, prizes, and deadlines.\n'
            '• 🤝 **Campus Teammate Discovery:** Help you form teams for hackathons.\n'
            '• 💬 **Campus Life Advice:** Motivational boosts, exam hacks, and hostel tips!',
        actions: const [
          SamAction(label: 'Today\'s Timetable', icon: Icons.calendar_today_rounded, route: '/timetable'),
          SamAction(label: 'Check Safe Bunks', icon: Icons.calculate_rounded, route: '/bunk-meter'),
        ],
      );
    }

    if (_matches(query, ['hi', 'hello', 'hey', 'namaste', 'wassup', 'sup', 'yo', 'good morning', 'good afternoon', 'good evening'])) {
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: 'Hey $firstName! 👋 Great to see you.\n\n'
            'How can I help you today? You can ask me about your next lecture, whether you can bunk DBMS, find study notes, or check upcoming hackathons!',
        actions: const [
          SamAction(label: 'Next Lecture?', icon: Icons.schedule_rounded, route: '/timetable'),
          SamAction(label: 'Can I Bunk Today?', icon: Icons.calculate_rounded, route: '/bunk-meter'),
        ],
      );
    }

    if (_matches(query, ['joke', 'funny', 'laugh', 'tell me a joke'])) {
      final jokes = [
        'Why do programmers prefer dark mode?\nBecause light attracts bugs! 🐛💡',
        'Why did the student eat their homework?\nBecause the professor said it was a piece of cake! 🍰',
        'There are 10 types of people in the world:\nThose who understand binary, and those who don\'t. 😂',
        'Why was the JavaScript developer sad?\nBecause they didn\'t Node how to Express themselves! 📦',
      ];
      final pickedJoke = jokes[DateTime.now().second % jokes.length];
      return SamMessage(
        id: id,
        isUser: false,
        timestamp: now,
        text: '😄 $pickedJoke',
        actions: const [
          SamAction(label: 'Play Quiz Arena', icon: Icons.sports_esports_rounded, route: '/arena'),
        ],
      );
    }

    // 10. DEFAULT INTELLIGENT CAMPUS ASSISTANT RESPONSE
    return SamMessage(
      id: id,
      isUser: false,
      timestamp: now,
      text: 'Thanks for reaching out, $firstName! 🎓\n\n'
          'I\'m specialized in Kampuzz campus life. Here are a few things you can ask me:\n\n'
          '• *"What is my next class and room?"*\n'
          '• *"Can I bunk DBMS today?"*\n'
          '• *"Show me today\'s full timetable"*\n'
          '• *"Where can I find handwritten DBMS notes?"*\n'
          '• *"Tell me about HackPulse 2026 hackathon"*\n'
          '• *"How do I find teammates for SIH?"*\n'
          '• *"How to rent a Casio calculator?"*',
      actions: const [
        SamAction(label: 'View Timetable', icon: Icons.calendar_today_rounded, route: '/timetable'),
        SamAction(label: 'Open Bunk-Meter', icon: Icons.calculate_rounded, route: '/bunk-meter'),
        SamAction(label: 'Browse Study Hub', icon: Icons.menu_book_rounded, route: '/study'),
      ],
    );
  }

  static bool _matches(String text, List<String> patterns) {
    for (final pattern in patterns) {
      if (text.contains(pattern)) return true;
    }
    return false;
  }
}
