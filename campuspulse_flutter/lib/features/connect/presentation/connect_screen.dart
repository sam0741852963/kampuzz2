import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../profile/presentation/profile_screen.dart';

/// Section 5.6: Connect (Teammate & Partner Discovery with Swipe Posters)
class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _candidates = [
    {
      'id': 2,
      'fullName': 'Sahab Raza',
      'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'college': 'IIT Delhi',
      'branch': 'CSE',
      'year': 3,
      'matchPercentage': 94,
      'matchedSkills': ['Flutter', 'Dart', 'PostgreSQL'],
      'bio': 'OS & Kernel enthusiast. Teaching assistant for DAA & DBMS. Looking for 36-hr HackPulse hackathon teammates.',
      'interests': ['Coding', 'Tech', 'Design'],
      'skills': ['C++', 'Python', 'Linux', 'Operating Systems', 'Flutter'],
      'sgpa': {'Sem 1': 9.0, 'Sem 2': 9.3, 'Sem 3': 9.2, 'Sem 4': 9.6},
      'notesUploaded': 11,
      'averageRating': 4.9,
      'quizRank': 1,
    },
    {
      'id': 3,
      'fullName': 'Priya Nair',
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
      'college': 'IIT Delhi',
      'branch': 'CSE',
      'year': 3,
      'matchPercentage': 88,
      'matchedSkills': ['Algorithms', 'Java'],
      'bio': 'Competitive programmer (Guardian on LeetCode). Class Representative (CR). Fast prototyping partner.',
      'interests': ['Coding', 'Dance', 'Tech'],
      'skills': ['Algorithms', 'Java', 'Data Structures', 'C++'],
      'sgpa': {'Sem 1': 9.5, 'Sem 2': 9.6, 'Sem 3': 9.7, 'Sem 4': 9.8},
      'notesUploaded': 8,
      'averageRating': 4.8,
      'quizRank': 3,
    },
    {
      'id': 4,
      'fullName': 'Rohan Verma',
      'avatarUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      'college': 'IIT Delhi',
      'branch': 'ECE',
      'year': 2,
      'matchPercentage': 78,
      'matchedSkills': ['Embedded C', 'Hardware'],
      'bio': 'Robotics club coordinator. IoT tinkerer building custom telemetry drones and autonomous rovers.',
      'interests': ['Robotics', 'Tech', 'Sports'],
      'skills': ['Verilog', 'Arduino', 'Embedded C', 'MATLAB'],
      'sgpa': {'Sem 1': 8.7, 'Sem 2': 8.9},
      'notesUploaded': 4,
      'averageRating': 4.7,
      'quizRank': 5,
    },
  ];

  void _onSwipe(bool isInterested) {
    final candidate = _candidates[_currentIndex];
    if (isInterested) {
      _showConnectDialog(candidate);
    } else {
      setState(() {
        if (_currentIndex < _candidates.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
      });
    }
  }

  void _showConnectDialog(Map<String, dynamic> candidate) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Connect with ${candidate['fullName']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You can send up to 3 messages before request acceptance.',
                      style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Introduce yourself (e.g. "Hey, looking for a frontend builder for HackPulse...")',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                if (_currentIndex < _candidates.length - 1) {
                  _currentIndex++;
                } else {
                  _currentIndex = 0;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Connection request sent to ${candidate['fullName']}! Chat enabled.'),
                  backgroundColor: AppColors.attendanceSafe,
                ),
              );
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final candidate = _candidates[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Active Chats',
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Poster Style Swipe Card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: NetworkImage(candidate['avatarUrl']),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.95),
                      ],
                      stops: const [0.0, 0.5, 0.9],
                    ),
                  ),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Match Score Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.attendanceSafe,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bolt, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${candidate['matchPercentage']}% MATCH',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Candidate Name & College
                      Text(
                        candidate['fullName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${candidate['branch']} • Year ${candidate['year']} • ${candidate['college']}',
                        style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),

                      // Bio
                      Text(
                        candidate['bio'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Matching Skills Chips
                      const Text(
                        'MATCHING SKILLS',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: (candidate['matchedSkills'] as List<String>).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.7)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),

                      // View Details button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                  isPublicView: true,
                                  customUser: {
                                    'fullName': candidate['fullName'],
                                    'email': '${candidate['fullName'].toString().toLowerCase().replaceAll(" ", ".")}@iitd.ac.in',
                                    'avatarUrl': candidate['avatarUrl'],
                                    'collegeName': candidate['college'],
                                    'branchName': candidate['branch'],
                                    'sectionName': 'CSE-3A',
                                    'year': candidate['year'],
                                    'semester': 5,
                                    'bio': candidate['bio'],
                                    'interests': candidate['interests'],
                                    'skills': candidate['skills'],
                                    'githubUrl': 'https://github.com',
                                    'linkedinUrl': 'https://linkedin.com',
                                    'role': 'student',
                                    'sgpa': candidate['sgpa'],
                                    'notesUploaded': candidate['notesUploaded'],
                                    'averageRating': candidate['averageRating'],
                                    'quizRank': candidate['quizRank'],
                                  },
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('View Full LinkedIn Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Swipe Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'skip_btn',
                  backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                  foregroundColor: AppColors.attendanceDanger,
                  elevation: 3,
                  onPressed: () => _onSwipe(false),
                  child: const Icon(Icons.close, size: 28),
                ),
                FloatingActionButton.extended(
                  heroTag: 'connect_btn',
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  onPressed: () => _onSwipe(true),
                  icon: const Icon(Icons.handshake_rounded),
                  label: const Text('Connect Now', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
