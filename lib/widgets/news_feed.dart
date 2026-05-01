import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import '../theme/app_theme.dart';

// Helper function to format time ago
String _formatTimeAgo(DateTime publishedAt) {
  final now = DateTime.now();
  final diff = now.difference(publishedAt);

  // Handle edge case: if publishedAt is in the future, return "just now"
  if (diff.isNegative) {
    return "just now";
  }

  if (diff.inMinutes < 60) {
    return "${diff.inMinutes}m ago";
  } else if (diff.inHours < 24) {
    return "${diff.inHours}h ago";
  } else if (diff.inDays < 7) {
    return "${diff.inDays}d ago";
  } else {
    return "${diff.inDays ~/ 7}w ago";
  }
}

// Helper to determine if image URL is network or asset
bool _isNetworkImage(String url) {
  return url.startsWith('http://') || url.startsWith('https://');
}

class NewsFeedWidget extends StatefulWidget {
  const NewsFeedWidget({super.key});

  @override
  State<NewsFeedWidget> createState() => _NewsFeedWidgetState();
}

class _NewsFeedWidgetState extends State<NewsFeedWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<List<IndustryBriefingData>>(
      stream: Provider.of<AppDatabase>(context, listen: false)
          .watchLatestIndustryBriefing(limit: 5),
      builder: (context, snapshot) {
        // Handle error state
        if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Industry Briefing",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Icon(Icons.rss_feed,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        size: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: theme.colorScheme.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Error loading news: ${snapshot.error}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final briefings = snapshot.data!;

        // Transform briefings to news items
        final news = briefings.asMap().entries.map((entry) {
          final briefing = entry.value;
          return _NewsItem(
            source: briefing.source,
            headline: briefing.title,
            imageUrl: briefing.previewImage ?? "assets/images/news_AV.png",
            timeAgo: _formatTimeAgo(briefing.publishedAt),
            isFeatured: entry.key == 0, // First item is featured
          );
        }).toList();

        if (news.isEmpty) {
          // Fallback: show empty state, but still render the section
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Industry Briefing",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Icon(Icons.rss_feed,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        size: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "No industry news available",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          );
        }

        final lastUpdate =
            briefings.isNotEmpty ? briefings.first.publishedAt : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Industry Briefing",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (lastUpdate != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          "• ${briefings.length} items • Updated ${_formatTimeAgo(lastUpdate)}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: AppTypography.fontSizeXS,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Icon(Icons.rss_feed,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 20),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                key: ValueKey(
                    briefings.length), // Triggers animation on count change
                height: 220, // Height of the scrollable area
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: news.length,
                  separatorBuilder: (ctx, i) => const SizedBox(width: 12),
                  itemBuilder: (ctx, i) {
                    final item = news[i];
                    // Featured item is wider
                    final double width = item.isFeatured ? 300 : 160;

                    return _buildNewsCard(context, item, width);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewsCard(BuildContext context, _NewsItem item, double width) {
    final theme = Theme.of(context);
    return Semantics(
      label: "News article: ${item.headline} from ${item.source}",
      button: true,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surface, // Fallback color
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Show full article dialog or navigation
              showDialog(
                context: context,
                builder: (context) {
                  final dialogTheme = Theme.of(context);
                  return AlertDialog(
                    backgroundColor: dialogTheme.colorScheme.surface,
                    title: Text(
                      item.source,
                      style: dialogTheme.textTheme.titleMedium?.copyWith(
                        color: dialogTheme.colorScheme.onSurface,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isNetworkImage(item.imageUrl))
                          Image.network(
                            item.imageUrl,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 150,
                              color: dialogTheme.colorScheme.surface,
                              child: Icon(
                                Icons.broken_image,
                                color: dialogTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                size: 48,
                              ),
                            ),
                          )
                        else
                          Image.asset(
                            item.imageUrl,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 150,
                              color: dialogTheme.colorScheme.surface,
                              child: Icon(
                                Icons.broken_image,
                                color: dialogTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                size: 48,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          item.headline,
                          style: dialogTheme.textTheme.titleMedium?.copyWith(
                            color: dialogTheme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Published ${item.timeAgo}',
                          style: dialogTheme.textTheme.bodyMedium?.copyWith(
                            color: dialogTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'CLOSE',
                          style: TextStyle(
                              color: dialogTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7)),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dialogTheme.colorScheme.primary,
                          foregroundColor: dialogTheme.colorScheme.onSurface,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Opening full article...",
                                style: TextStyle(
                                    color: dialogTheme.colorScheme.onSurface),
                              ),
                              backgroundColor: dialogTheme.colorScheme.surface,
                            ),
                          );
                        },
                        child: const Text('READ FULL STORY'),
                      )
                    ],
                  );
                },
              );
            },
            child: Stack(
              children: [
                // Background Image with Error Handling
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _isNetworkImage(item.imageUrl)
                      ? Image.network(
                          item.imageUrl,
                          width: width,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImageErrorFallback(context, width);
                          },
                        )
                      : Image.asset(
                          item.imageUrl,
                          width: width,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImageErrorFallback(context, width);
                          },
                        ),
                ),
                // Gradient Overlay (Crucial for readability)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.9),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                // Text Content
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          // Tiny Favicon placeholder
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "N",
                                style: TextStyle(
                                  fontSize: AppTypography.fontSizeXS,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.source,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                fontSize: AppTypography.fontSizeXS,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.timeAgo,
                            style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              fontSize: AppTypography.fontSizeXS,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.headline,
                        maxLines: item.isFeatured ? 4 : 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: item.isFeatured
                              ? AppTypography.fontSizeLG
                              : AppTypography.fontSizeMD,
                          fontWeight: AppTypography.weightSemiBold,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for image error fallback
  Widget _buildImageErrorFallback(BuildContext context, double width) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.newspaper,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          size: 48,
        ),
      ),
    );
  }
}

// Internal data class for display
class _NewsItem {
  final String source;
  final String headline;
  final String imageUrl;
  final String timeAgo;
  final bool isFeatured;

  _NewsItem({
    required this.source,
    required this.headline,
    required this.imageUrl,
    required this.timeAgo,
    this.isFeatured = false,
  });
}
