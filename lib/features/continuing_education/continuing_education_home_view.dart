import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import 'course_card.dart';
import 'course_detail_view.dart';

class ContinuingEducationHomeView extends StatefulWidget {
  const ContinuingEducationHomeView({super.key});

  @override
  State<ContinuingEducationHomeView> createState() =>
      _ContinuingEducationHomeViewState();
}

class _ContinuingEducationHomeViewState
    extends State<ContinuingEducationHomeView> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Technical',
    'Safety',
    'Compliance',
    'HR',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = context.watch<AppDatabase>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Continuing Education'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            // Search and Filter Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search courses...',
                      hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      prefixIcon: Icon(Icons.search,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: theme.colorScheme.primary, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            selectedColor: theme.colorScheme.primary,
                            checkmarkColor: theme.colorScheme.onSurface,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            // Course List
            Expanded(
              child: StreamBuilder<List<ContinuingEducationCourse>>(
                stream: _selectedCategory == 'All'
                    ? db.watchAllCourses()
                    : db.watchCoursesByCategory(_selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: theme.colorScheme.error),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading courses',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_outlined,
                              size: 64,
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          Text(
                            'No courses available',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  var courses = snapshot.data!;

                  // Apply search filter
                  if (_searchQuery.isNotEmpty) {
                    courses = courses.where((course) {
                      return course.title
                              .toLowerCase()
                              .contains(_searchQuery) ||
                          (course.description
                                  ?.toLowerCase()
                                  .contains(_searchQuery) ??
                              false) ||
                          course.provider.toLowerCase().contains(_searchQuery);
                    }).toList();
                  }

                  if (courses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 64,
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          Text(
                            'No courses match your search',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CourseCard(
                          course: course,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  CourseDetailView(course: course),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
