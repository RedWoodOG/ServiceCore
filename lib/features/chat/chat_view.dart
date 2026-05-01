import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../providers/auth_provider.dart';
import 'services/portal_chat_service.dart';
import 'models/portal_chat_models.dart' as model;

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String? _selectedChannelId;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatService = context.read<PortalChatService>();

    return Scaffold(
      backgroundColor: Colors.transparent, // Inherit from PortalShell
      body: Row(
        children: [
          // Left Sidebar: Channels
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                  right: BorderSide(color: theme.dividerColor, width: 1)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: theme.dividerColor, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: theme.colorScheme.primary),
                      SizedBox(width: 10),
                      Text('Teams', style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
                // Channel List
                Expanded(
                  child: StreamBuilder<List<model.ChannelSummary>>(
                    stream: chatService.watchChannels(),
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
                                  color: theme.colorScheme.error, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading channels',
                                style:
                                    TextStyle(color: theme.colorScheme.error),
                              ),
                            ],
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final channels = snapshot.data!;
                      if (channels.isEmpty) {
                        // Create default channel if none exist
                        chatService.createChannel(
                            'general', 'General', 'Default channel');
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        itemCount: channels.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final channel = channels[index];
                          final isSelected = _selectedChannelId == channel.id;
                          return _ChannelItem(
                            channel: channel,
                            isSelected: isSelected,
                            onTap: () =>
                                setState(() => _selectedChannelId = channel.id),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Right Content: Messages
          Expanded(
            child: _selectedChannelId == null
                ? Center(
                    child: Text('Select a channel',
                        style: theme.textTheme.bodyMedium))
                : _MessageThread(channelId: _selectedChannelId!),
          ),
        ],
      ),
    );
  }
}

class _ChannelItem extends StatelessWidget {
  final model.ChannelSummary channel;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChannelItem({
    required this.channel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppLayout.radiusMD),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppLayout.radiusMD),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.tag,
                  size: 16,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  channel.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageThread extends StatefulWidget {
  final String channelId;
  const _MessageThread({required this.channelId});

  @override
  State<_MessageThread> createState() => _MessageThreadState();
}

class _MessageThreadState extends State<_MessageThread> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // LOGIN: Use current logged-in user from AuthProvider
    final authProvider = context.read<AuthProvider>();
    if (mounted) {
      setState(() {
        _currentUser = authProvider.currentUser;
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final service = context.read<PortalChatService>();
    final userId = _currentUser?.id.toString() ?? '1';
    final userName = _currentUser?.fullName ?? 'User';
    service.sendMessage(
        widget.channelId, _controller.text.trim(), userId, userName);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = context.read<PortalChatService>();

    return Column(
      children: [
        // Thread Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: theme.colorScheme.surface,
          child: Row(
            children: [
              Icon(Icons.tag,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text(widget.channelId, style: theme.textTheme.titleMedium),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: StreamBuilder<List<model.ChatMessage>>(
            stream: service.watchMessages(widget.channelId),
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
                          color: Theme.of(context).colorScheme.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading messages',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final messages = snapshot.data!;

              // Auto-scroll on initial load
              if (messages.isNotEmpty) _scrollToBottom();

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(24),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _MessageBubble(message: messages[index]);
                },
              );
            },
          ),
        ),

        // Input
        Container(
          padding: const EdgeInsets.all(20),
          color: theme.colorScheme.surface,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final model.ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle),
            child: Center(
              child: Text(
                (message.senderName ?? 'U')[0],
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(message.senderName ?? 'User',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(
                      '${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
