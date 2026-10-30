import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// LinkedIn-style profile screen meeting Section 4 requirements:
/// - Header banner with profile photo, name, college, branch, year, section
/// - Academic (SGPA by semester, marked "self-declared")
/// - Contributions: notes uploaded, average rating, quiz rank
/// - About bio, Skills chips, Interests chips
/// - GitHub, LinkedIn links and Edit Profile
class ProfileScreen extends StatefulWidget {
  final bool isPublicView;
  final Map<String, dynamic>? customUser;

  const ProfileScreen({
    super.key,
    this.isPublicView = false,
    this.customUser,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, dynamic> _user;

  @override
  void initState() {
    super.initState();
    _user = widget.customUser ?? {
      'fullName': 'Aarav Sharma',
      'email': 'aarav.sharma@iitd.ac.in',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
      'collegeName': 'IIT Delhi',
      'branchName': 'Computer Science & Engineering',
      'sectionName': 'CSE-3A',
      'year': 3,
      'semester': 5,
      'bio': 'Full-stack builder passionate about distributed systems and Flutter. Hackathon finalist & peer tutor for DBMS.',
      'interests': ['Tech', 'Coding', 'Gaming', 'Music', 'Robotics'],
      'skills': ['Flutter', 'Dart', 'Go', 'Docker', 'PostgreSQL', 'Redis'],
      'githubUrl': 'https://github.com/aarav-sharma',
      'linkedinUrl': 'https://linkedin.com/in/aarav-sharma',
      'role': 'student',
      'sgpa': {
        'Semester 1': 9.2,
        'Semester 2': 9.4,
        'Semester 3': 9.1,
        'Semester 4': 9.5,
      },
      'notesUploaded': 6,
      'averageRating': 4.9,
      'quizRank': 2,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sgpaMap = _user['sgpa'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPublicView ? 'Student Profile' : 'My Profile'),
        actions: [
          if (!widget.isPublicView)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Profile',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profile modal opened')),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Profile',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile link copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // LinkedIn-style Banner & Avatar Header
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryDark, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -45,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBackground : Colors.white,
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(_user['avatarUrl']),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 52),

            // Name & Academic Credentials
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _user['fullName'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _user['role'].toString().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_user['branchName']} • Year ${_user['year']} (${_user['sectionName']})',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, size: 16, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 4),
                      Text(
                        _user['collegeName'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contributions Row (Hero Stats)
                  Row(
                    children: [
                      _buildContributionCard(
                        icon: Icons.upload_file_rounded,
                        count: '${_user['notesUploaded']}',
                        label: 'Notes Uploaded',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      _buildContributionCard(
                        icon: Icons.star_rounded,
                        count: '${_user['averageRating']} ★',
                        label: 'Avg Rating',
                        color: AppColors.attendanceWarning,
                      ),
                      const SizedBox(width: 10),
                      _buildContributionCard(
                        icon: Icons.military_tech_rounded,
                        count: '#${_user['quizRank']}',
                        label: 'Quiz Rank',
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // About Section
                  _buildSectionHeader(Icons.info_outline, 'About'),
                  const SizedBox(height: 6),
                  Text(
                    _user['bio'],
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Academic (SGPA by semester)
                  Row(
                    children: [
                      _buildSectionHeader(Icons.grade_outlined, 'Academic Performance'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: const Text(
                          'Self-Declared',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: sgpaMap.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${entry.value} SGPA',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Skills Section
                  _buildSectionHeader(Icons.construction_outlined, 'Skills'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (_user['skills'] as List<String>).map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                        labelStyle: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Interests Section
                  _buildSectionHeader(Icons.favorite_outline, 'Interests'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (_user['interests'] as List<String>).map((interest) {
                      return Chip(
                        label: Text(interest),
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                        labelStyle: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Links Section
                  _buildSectionHeader(Icons.link, 'Links & Profiles'),
                  const SizedBox(height: 10),
                  _buildLinkTile(
                    icon: Icons.code,
                    title: 'GitHub Profile',
                    url: _user['githubUrl'],
                  ),
                  const SizedBox(height: 8),
                  _buildLinkTile(
                    icon: Icons.business,
                    title: 'LinkedIn Profile',
                    url: _user['linkedinUrl'],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildContributionCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              count,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required String url,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  url,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondaryLight),
        ],
      ),
    );
  }
}
