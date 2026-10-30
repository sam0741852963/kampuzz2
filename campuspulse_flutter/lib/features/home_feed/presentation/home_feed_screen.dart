import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/campus_pulse_logo.dart';
import '../../../core/widgets/auth_user_menu.dart';

/// Section 5.4: Event Feed (Instagram-style)
/// - Vertically swipeable full-screen feed (PageView) of upcoming events
/// - Live countdown to registration deadline (days:hours:minutes:seconds; turns red under 24h)
/// - "Registration closed" after deadline
/// - Register button, Save/Remind button, View details
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  late Timer _timer;
  final Set<int> _registeredEvents = {};
  final Set<int> _savedEvents = {};

  final List<Map<String, dynamic>> _events = [
    {
      'id': 1,
      'title': 'HackPulse 2026: 36-Hr National Hackathon',
      'club': 'DevClub IITD',
      'posterUrl': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800',
      'date': 'Nov 5, 2026 • 9:00 AM',
      'venue': 'LHC Seminar Hall, IIT Delhi',
      'description': 'Solve problems in Web3, AI, and Campus Life. ₹3 Lakhs cash pool + direct internship interviews.',
      'deadline': DateTime.now().add(const Duration(hours: 14, minutes: 22, seconds: 40)),
      'tags': ['Hackathon', 'Coding', 'Cash Prize', 'AI'],
      'participants': 214,
      'capacity': 250,
    },
    {
      'id': 2,
      'title': 'Acoustic Night & Open Mic Under Stars',
      'club': 'Music & Cultural Society',
      'posterUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
      'date': 'Nov 8, 2026 • 6:30 PM',
      'venue': 'Open Air Theatre (OAT)',
      'description': 'Unplugged guitar riffs, soothing vocals, and spoken poetry. Free artisanal coffee & snacks!',
      'deadline': DateTime.now().add(const Duration(days: 3, hours: 8, minutes: 10)),
      'tags': ['Music', 'Open Mic', 'Night Life', 'Acoustic'],
      'participants': 380,
      'capacity': 500,
    },
    {
      'id': 3,
      'title': 'RoboWars 2026: Combat Robotics Championship',
      'club': 'Robotics Club',
      'posterUrl': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800',
      'date': 'Nov 12, 2026 • 11:00 AM',
      'venue': 'SAC Indoor Sports Complex',
      'description': '15kg and 30kg combat bots battle in an armored arena. Live sparks, pneumatic flippers, and spinning blades!',
      'deadline': DateTime.now().add(const Duration(days: 5, hours: 2)),
      'tags': ['Robotics', 'Hardware', 'Battle'],
      'participants': 142,
      'capacity': 200,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatCountdown(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return 'Registration closed';

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    if (days > 0) {
      return '${days}d ${hStr}h ${mStr}m ${sStr}s';
    }
    return '${hStr}h ${mStr}m ${sStr}s';
  }

  bool _isUnder24Hours(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    return !diff.isNegative && diff.inHours < 24;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CampusPulseLogo(size: 28, showGlow: false),
            SizedBox(width: 10),
            Text('Kampuzz', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Bunk-Meter',
            icon: const Icon(Icons.calculate_outlined, color: AppColors.primary),
            onPressed: () => context.push('/bunk-meter'),
          ),
          IconButton(
            tooltip: 'Timetable',
            icon: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
            onPressed: () => context.push('/timetable'),
          ),
          const AuthUserAvatarButton(),
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          final eventId = event['id'] as int;
          final deadline = event['deadline'] as DateTime;
          final isUnder24 = _isUnder24Hours(deadline);
          final isClosed = deadline.difference(DateTime.now()).isNegative;
          final isRegistered = _registeredEvents.contains(eventId);
          final isSaved = _savedEvents.contains(eventId);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(event['posterUrl']),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.4, 0.9],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Countdown Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isClosed
                          ? Colors.grey[800]
                          : isUnder24
                              ? AppColors.attendanceDanger
                              : AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: (isUnder24 ? AppColors.attendanceDanger : AppColors.primary).withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isClosed ? Icons.lock_clock : Icons.timer_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatCountdown(deadline),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Event Title & Club
                  Text(
                    event['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Organized by ${event['club']}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Venue & Date Pills
                  Row(
                    children: [
                      const Icon(Icons.event_outlined, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        event['date'],
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event['venue'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    event['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tag Chips
                  Wrap(
                    spacing: 8,
                    children: (event['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isClosed
                              ? null
                              : () {
                                  setState(() {
                                    if (isRegistered) {
                                      _registeredEvents.remove(eventId);
                                    } else {
                                      _registeredEvents.add(eventId);
                                    }
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isRegistered
                                            ? 'Cancelled registration'
                                            : 'Successfully registered! Pass saved to My Events.',
                                      ),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRegistered ? AppColors.attendanceSafe : AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isClosed
                                ? 'Closed'
                                : isRegistered
                                    ? '✓ Registered (${event['participants'] + 1})'
                                    : 'Register Now (${event['participants']}/${event['capacity']})',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          padding: const EdgeInsets.all(12),
                        ),
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? AppColors.secondary : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isSaved) {
                              _savedEvents.remove(eventId);
                            } else {
                              _savedEvents.add(eventId);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
