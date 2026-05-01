import 'package:flutter/material.dart';
import '../../database/app_database.dart';

class CourseCard extends StatelessWidget {
  final ContinuingEducationCourse course;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  String _getCategoryColor(String category) {
    switch (category) {
      case 'Technical':
        return '#4CAF50'; // Green
      case 'Safety':
        return '#FF9800'; // Orange
      case 'Compliance':
        return '#2196F3'; // Blue
      case 'HR':
        return '#9C27B0'; // Purple
      default:
        return '#757575'; // Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = _getCategoryColor(course.category);

    return Card(
      color: theme.colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Category Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(
                          int.parse(categoryColor.replaceFirst('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      course.category,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Duration Badge
                  if (course.durationHours != null)
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16,
                            color:
                                theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        const SizedBox(width: 4),
                        Text(
                          '${course.durationHours}h',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Course Title
              Text(
                course.title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Provider
              Row(
                children: [
                  Icon(Icons.business,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                  const SizedBox(width: 6),
                  Text(
                    course.provider,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (course.description != null &&
                  course.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  course.description!,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // External Link Indicator
              if (course.externalUrl != null && course.externalUrl!.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.open_in_new,
                        size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'External Link Available',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
