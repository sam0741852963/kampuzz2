import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/auth_user_menu.dart';

/// Section 5.1: Notes and Resources Hub (Hero Feature)
class StudyHubScreen extends StatefulWidget {
  const StudyHubScreen({super.key});

  @override
  State<StudyHubScreen> createState() => _StudyHubScreenState();
}

class _StudyHubScreenState extends State<StudyHubScreen> {
  String _selectedType = 'All';
  String _sortBy = 'rating'; // 'rating', 'newest', 'most_used'
  String? _selectedSubject;
  final Set<int> _followedResources = {};
  final Set<int> _bookmarkedResources = {};

  final List<String> _subjects = [
    'All Subjects',
    'Database Management Systems',
    'Operating Systems',
    'Design & Analysis of Algorithms',
    'Computer Networks',
  ];

  final List<Map<String, dynamic>> _resources = [
    {
      'id': 1,
      'title': 'DBMS Comprehensive Handwritten Notes (SQL + Normalization + B-Trees)',
      'uploaderName': 'Sahab Raza',
      'uploaderSgpa': 9.2,
      'uploaderSemester': 3,
      'subject': 'Database Management Systems',
      'type': 'pdf',
      'rating': 4.9,
      'ratingCount': 34,
      'followedCount': 128,
      'tags': ['SQL', 'Transactions', 'Normalization', 'Exam Prep'],
      'description': 'Master notes covering complete Unit 1-4 with past 5 years semester paper solutions. Includes transaction ACID properties and indexing.',
    },
    {
      'id': 2,
      'title': 'OS Concurrency & Virtual Memory Cheatsheet',
      'uploaderName': 'Aarav Sharma',
      'uploaderSgpa': 9.4,
      'uploaderSemester': 4,
      'subject': 'Operating Systems',
      'type': 'pdf',
      'rating': 4.8,
      'ratingCount': 22,
      'followedCount': 95,
      'tags': ['Deadlock', 'Paging', 'Concurrency', 'Formula Sheet'],
      'description': 'One-page summary of Semaphores, Mutexes, Deadlock avoidance (Banker\'s Algo), and Page replacement algorithms (LRU, FIFO, Optimal).',
    },
    {
      'id': 3,
      'title': 'Algorithms: Dynamic Programming & Graph Theory Lecture Companion',
      'uploaderName': 'Priya Nair',
      'uploaderSgpa': 9.7,
      'uploaderSemester': 4,
      'subject': 'Design & Analysis of Algorithms',
      'type': 'youtube',
      'rating': 4.95,
      'ratingCount': 48,
      'followedCount': 164,
      'tags': ['Dynamic Programming', 'Graphs', 'Dijkstra', 'Floyd Warshall'],
      'description': 'Annotated lecture notes from Prof. Naveen Garg\'s course + curated YouTube playlist for DP state visualization.',
    },
    {
      'id': 4,
      'title': 'Computer Networks OSI Model & TCP/IP Protocol Suite Mindmap',
      'uploaderName': 'Ananya Sengupta',
      'uploaderSgpa': 9.0,
      'uploaderSemester': 3,
      'subject': 'Computer Networks',
      'type': 'website',
      'rating': 4.75,
      'ratingCount': 18,
      'followedCount': 82,
      'tags': ['OSI Model', 'TCP/IP', 'Subnetting', 'Routing'],
      'description': 'Interactive visual mindmap with packet flow diagrams, subnetting tricks, and Wireshark capture examples.',
    },
  ];

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'youtube':
        return Icons.play_circle_fill_rounded;
      case 'website':
        return Icons.language_rounded;
      case 'handwritten':
        return Icons.draw_rounded;
      case 'book':
      default:
        return Icons.menu_book_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return AppColors.attendanceDanger;
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'website':
        return AppColors.secondary;
      case 'handwritten':
        return AppColors.attendanceWarning;
      case 'book':
      default:
        return AppColors.primary;
    }
  }

  void _openDetailModal(Map<String, dynamic> res) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(_getTypeIcon(res['type']), color: _getTypeColor(res['type']), size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      res['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Uploaded by ${res['uploaderName']} • SGPA ${res['uploaderSgpa']} (Sem ${res['uploaderSemester']})',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text('Description', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 6),
              Text(res['description'], style: const TextStyle(fontSize: 14, height: 1.5)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening resource document in viewer...')),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open & View Resource'),
              ),
              const SizedBox(height: 16),
              const Text('Discussion & Comments (2)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 10),
              _buildCommentItem('Priya Nair', 'These notes saved my midterm exam! The B-Tree step-by-step is so clear.'),
              _buildCommentItem('Sahab Raza (Uploader)', 'Glad it helped! Added 2026 PYQ solutions in Appendix B.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem(String author, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(author, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(comment, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    var filtered = _resources.where((r) {
      if (_selectedType != 'All' && r['type'].toString().toLowerCase() != _selectedType.toLowerCase()) {
        return false;
      }
      if (_selectedSubject != null && _selectedSubject != 'All Subjects' && r['subject'] != _selectedSubject) {
        return false;
      }
      return true;
    }).toList();

    if (_sortBy == 'rating') {
      filtered.sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
    } else if (_sortBy == 'most_used') {
      filtered.sort((a, b) => (b['followedCount'] as int).compareTo(a['followedCount'] as int));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Hub', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'My Saved Notes',
            onPressed: () {},
          ),
          const AuthUserAvatarButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Resource', style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload Resource Form opened')),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch & Year Context Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Filtered for: Computer Science • Year 3 (Sem 5)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Change', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Type Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'PDF', 'YouTube', 'Website', 'Handwritten', 'Book'].map((type) {
                  final isSelected = _selectedType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(type),
                      selectedColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedType = type);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Sorting & Subject Selection
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedSubject ?? _subjects.first,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: _subjects.map((sub) {
                          return DropdownMenuItem<String>(
                            value: sub,
                            child: Text(sub, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedSubject = val);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  initialValue: _sortBy,
                  onSelected: (val) => setState(() => _sortBy = val),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sort, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _sortBy == 'rating'
                              ? 'Top Rated'
                              : _sortBy == 'most_used'
                                  ? 'Most Used'
                                  : 'Newest',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 'rating', child: Text('Top Rated')),
                    PopupMenuItem(value: 'most_used', child: Text('Most Used')),
                    PopupMenuItem(value: 'newest', child: Text('Newest')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Resource Cards List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final res = filtered[index];
                final resId = res['id'] as int;
                final isFollowed = _followedResources.contains(resId);
                final followedCount = (res['followedCount'] as int) + (isFollowed ? 1 : 0);

                return InkWell(
                  onTap: () => _openDetailModal(res),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type Icon + Subject Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getTypeColor(res['type']).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getTypeIcon(res['type']),
                                color: _getTypeColor(res['type']),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                res['subject'],
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: AppColors.attendanceWarning, size: 18),
                                const SizedBox(width: 2),
                                Text(
                                  '${res['rating']}',
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                ),
                                Text(
                                  ' (${res['ratingCount']})',
                                  style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Title
                        Text(
                          res['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Uploader Info with SGPA & Self-declared badge
                        Row(
                          children: [
                            Text(
                              res['uploaderName'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.attendanceSafe.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'SGPA ${res['uploaderSgpa']} (Sem ${res['uploaderSemester']})',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.attendanceSafe,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '• self-declared',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Follow / Used Counter and Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Used by $followedCount students',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _bookmarkedResources.contains(resId) ? Icons.bookmark : Icons.bookmark_border,
                                    color: _bookmarkedResources.contains(resId) ? AppColors.secondary : AppColors.textSecondaryLight,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_bookmarkedResources.contains(resId)) {
                                        _bookmarkedResources.remove(resId);
                                      } else {
                                        _bookmarkedResources.add(resId);
                                      }
                                    });
                                  },
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (isFollowed) {
                                        _followedResources.remove(resId);
                                      } else {
                                        _followedResources.add(resId);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    isFollowed ? Icons.check_circle : Icons.add_circle_outline,
                                    size: 16,
                                    color: isFollowed ? AppColors.attendanceSafe : AppColors.primary,
                                  ),
                                  label: Text(
                                    isFollowed ? 'Followed' : 'I followed this',
                                    style: TextStyle(
                                      color: isFollowed ? AppColors.attendanceSafe : AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: isFollowed ? AppColors.attendanceSafe : AppColors.primary,
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
