import 'package:drift/drift.dart';
import 'package:fsc_portal/database/app_database.dart';
import '../models/portal_chat_models.dart' as model;
import 'dart:convert';

class PortalChatService {
  final AppDatabase _db;

  PortalChatService(this._db);

  Stream<List<model.ChannelSummary>> watchChannels() {
    return _db.watchChannels().map((rows) {
      return rows.map((row) {
        return model.ChannelSummary(
          id: row.id,
          name: row.name,
          description: row.description,
          updatedAt: row.updatedAt,
          // TODO: Fetch last message
        );
      }).toList();
    });
  }

  Stream<List<model.ChatMessage>> watchMessages(String channelId) {
    return _db.watchMessages(channelId).map((rows) {
      return rows.map((row) {
        final attachments = (jsonDecode(row.attachmentsJson) as List)
            .map((e) => e.toString())
            .toList();

        final reactions =
            (jsonDecode(row.reactionsJson) as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            );

        return model.ChatMessage(
          id: row.id,
          channelId: row.channelId,
          senderId: row.senderId,
          senderName: row.senderName,
          content: row.content,
          createdAt: row.createdAt,
          attachments: attachments,
          reactions: reactions,
        );
      }).toList();
    });
  }

  Future<void> sendMessage(
    String channelId,
    String content,
    String senderId,
    String senderName,
  ) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    await _db.insertMessage(
      ChatMessagesCompanion(
        id: Value(id),
        channelId: Value(channelId),
        senderId: Value(senderId),
        senderName: Value(senderName),
        content: Value(content),
        createdAt: Value(now),
        isSynced: const Value(false),
      ),
    );

    // Update channel timestamp
    await _db
        .into(_db.chatChannels)
        .insertOnConflictUpdate(
          ChatChannelsCompanion(id: Value(channelId), updatedAt: Value(now)),
        );
  }

  Future<void> createChannel(String id, String name, String description) async {
    await _db.insertChannel(
      ChatChannelsCompanion(
        id: Value(id),
        name: Value(name),
        description: Value(description),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
