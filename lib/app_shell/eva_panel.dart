import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/app_database.dart';
import 'eva_state.dart';

import '../services/eva_service.dart';

/// EVA Panel - Full EVA surface when expanded
/// Right-anchored, persistent conversational assistant panel
class EvaPanel extends StatefulWidget {
  const EvaPanel({super.key});

  @override
  State<EvaPanel> createState() => _EvaPanelState();
}

class _EvaPanelState extends State<EvaPanel> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<EvaMessage> _messages = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Check for pending query after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPendingQuery();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _checkPendingQuery() {
    final evaState = context.read<EvaState>();
    final pendingQuery = evaState.consumePendingQuery();
    if (pendingQuery != null && mounted) {
      _controller.text = pendingQuery;
      // Auto-submit the query
      _handleSubmit(pendingQuery);
    }
  }

  Future<void> _handleSubmit(String value) async {
    if (value.trim().isEmpty || _isProcessing) return;

    final query = value.trim();
    _controller.clear();

    setState(() {
      _messages.add(EvaMessage(text: query, isUser: true));
      _isProcessing = true;
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      final db = context.read<AppDatabase>();
      final service = EvaService(db); // Create transiently or provider

      final response = await service.processQuery(query);

      if (!mounted) return;

      setState(() {
        _messages.add(EvaMessage(
          text: response.text,
          isUser: false,
          sources: response.sources,
        ));
        _isProcessing = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(EvaMessage(text: "Error: $e", isUser: false));
        _isProcessing = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final evaState = context.watch<EvaState>();

    return Container(
      width: 400, // Expanded width (360-420 range)
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor, width: 1),
              ),
            ),
            child: Row(
              children: [
                // EVA name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'EVA',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (evaState.isThinking) ...[
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Embedded Intelligence',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Collapse button
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  onPressed: () {
                    evaState.setExpanded(false);
                  },
                  tooltip: 'Collapse EVA',
                ),
              ],
            ),
          ),
          // Conversation Canvas (scrollable)
          Expanded(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: _buildConversationCanvas(context),
            ),
          ),
          // Input Bar (command style)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.dividerColor, width: 1),
              ),
            ),
            child: _buildInputBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCanvas(BuildContext context) {
    final theme = Theme.of(context);
    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'EVA is ready',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isProcessing ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                const SizedBox(width: 8),
                Text('EVA is thinking...',
                    style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.54))),
              ],
            ),
          );
        }

        final msg = _messages[index];
        return _buildMessageBubble(msg);
      },
    );
  }

  Widget _buildMessageBubble(EvaMessage msg) {
    final theme = Theme.of(context);
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: msg.isUser
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: msg.isUser ? null : Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                  color: msg.isUser
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface),
            ),
            if (msg.sources != null && msg.sources!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Divider(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.24),
                  height: 1),
              const SizedBox(height: 4),
              Text(
                'Sources:',
                style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              ...msg.sources!.map((s) => Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '• ${s.title}',
                      style: TextStyle(
                          color: theme.colorScheme.primary, fontSize: 10),
                    ),
                  )),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: _handleSubmit,
            decoration: InputDecoration(
              hintText: 'Ask EVA anything...',
              hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.send),
          color: theme.colorScheme.primary,
          onPressed: () => _handleSubmit(_controller.text),
          tooltip: 'Send message',
        ),
      ],
    );
  }
}

class EvaMessage {
  final String text;
  final bool isUser;
  final List<KnowledgeEntry>? sources;

  EvaMessage({required this.text, required this.isUser, this.sources});
}
