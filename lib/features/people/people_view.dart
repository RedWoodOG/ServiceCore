import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/glass_card.dart';
import '../../database/app_database.dart';
import 'user_card.dart';

class PeopleView extends StatefulWidget {
  const PeopleView({super.key});

  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: _buildUserList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'People',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  'Team Directory & Expertise',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              borderRadius: 12,
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search directory...',
                  hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                  icon: Icon(Icons.search,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<List<User>>(
      stream: context.read<AppDatabase>().watchAllUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data?.where((u) {
              final query = _searchQuery.toLowerCase();
              return u.fullName.toLowerCase().contains(query) ||
                  u.role.toLowerCase().contains(query) ||
                  (u.location?.toLowerCase().contains(query) ?? false);
            }).toList() ??
            [];

        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                const SizedBox(height: 16),
                Text(
                  'No team members found.',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 18),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 32),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return UserCard(user: users[index]);
          },
        );
      },
    );
  }
}
