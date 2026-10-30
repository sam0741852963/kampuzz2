import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Section 5.5: Communities (Clubs & Interest Groups)
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final Set<int> _joinedCommunities = {1};
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _communities = [
    {
      'id': 1,
      'name': 'Open Source & Hackathon Ninjas',
      'category': 'Tech',
      'members': 342,
      'description': 'Find teammates for Smart India Hackathon, MLH, and Google Summer of Code. Weekly reviews & mock pitches.',
      'icon': Icons.code_rounded,
      'color': AppColors.primary,
      'announcement': '📢 Mock pitch session tonight at 8 PM on Google Meet!',
    },
    {
      'id': 2,
      'name': 'Campus Musicians & Beatmakers',
      'category': 'Music',
      'members': 188,
      'description': 'Jam sessions, acoustic nights, guitar tabs exchange, and home studio production tips.',
      'icon': Icons.music_note_rounded,
      'color': AppColors.accent,
      'announcement': '🎸 OAT Jam session this Friday 6 PM!',
    },
    {
      'id': 3,
      'name': 'Robotics & Hardware Tinkers',
      'category': 'Tech',
      'members': 215,
      'description': 'Autonomous rovers, combat bots, drone telemetry, and PCB layout design discussions.',
      'icon': Icons.precision_manufacturing_rounded,
      'color': AppColors.secondary,
      'announcement': null,
    },
    {
      'id': 4,
      'name': 'Campus Gaming & Esports Hub',
      'category': 'Gaming',
      'members': 410,
      'description': 'Valorant inter-hostel tournament scrims, BGMI rooms, and chess blitz showdowns.',
      'icon': Icons.sports_esports_rounded,
      'color': const Color(0xFF8B5CF6),
      'announcement': '🏆 Inter-hostel Valorant Finals stream on Saturday!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _communities.where((c) {
      if (_selectedCategory == 'All') return true;
      return c['category'] == _selectedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Create Community',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create Community Modal opened')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search clubs, tech circles, music jams...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Tech', 'Music', 'Gaming', 'Dance', 'Design'].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (val) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Suggested for You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            // Community Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final comm = filtered[index];
                final commId = comm['id'] as int;
                final isJoined = _joinedCommunities.contains(commId);
                final color = comm['color'] as Color;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(comm['icon'] as IconData, color: color, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comm['name'],
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${comm['members']} members • ${comm['category']}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (isJoined) {
                                  _joinedCommunities.remove(commId);
                                } else {
                                  _joinedCommunities.add(commId);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isJoined ? Colors.grey[200] : AppColors.primary,
                              foregroundColor: isJoined ? Colors.black87 : Colors.white,
                              minimumSize: const Size(80, 36),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(isJoined ? 'Joined' : 'Join', style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        comm['description'],
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                      if (comm['announcement'] != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            comm['announcement'],
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
