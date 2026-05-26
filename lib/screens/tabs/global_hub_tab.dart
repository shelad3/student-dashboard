import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/message_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/message_bubble.dart';

class GlobalHubTab extends StatefulWidget {
  const GlobalHubTab({super.key});

  @override
  State<GlobalHubTab> createState() => _GlobalHubTabState();
}

class _GlobalHubTabState extends State<GlobalHubTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _msgCtrl = TextEditingController();
  final _annCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _msgCtrl.dispose();
    _annCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    final auth = context.read<AuthProvider>();
    final chat = context.read<ChatProvider>();
    final user = auth.currentUser!;
    chat.addMessage(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: user.uid,
      senderName: user.fullName,
      senderRole: user.role.name,
      content: text,
      createdAt: DateTime.now(),
    ));
    _msgCtrl.clear();
  }

  void _postAnnouncement() {
    final text = _annCtrl.text.trim();
    if (text.isEmpty) return;
    final auth = context.read<AuthProvider>();
    final chat = context.read<ChatProvider>();
    final user = auth.currentUser!;
    chat.addAnnouncement(user.uid, user.fullName, text);
    _annCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final canAnnounce = auth.isTeacher || auth.isAdmin;

    return Column(
      children: [
        TabBar(
          controller: _tabCtrl,
          tabs: [
            Tab(text: 'Announcements'),
            Tab(text: 'Discussions'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _buildAnnouncementsTab(context, canAnnounce),
              _buildDiscussionsTab(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsTab(BuildContext context, bool canAnnounce) {
    final chat = context.watch<ChatProvider>();
    final announcements = chat.getAnnouncements();

    return Column(
      children: [
        if (canAnnounce)
          Container(
            padding: EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _annCtrl,
                    decoration: InputDecoration(
                      hintText: 'Post an announcement...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    maxLines: 2,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _postAnnouncement(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _postAnnouncement,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        Expanded(
          child: announcements.isEmpty
              ? Center(
                  child: Text('No announcements yet',
                      style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: announcements.length,
                  itemBuilder: (_, i) =>
                      AnnouncementCard(announcement: announcements[i]),
                ),
        ),
      ],
    );
  }

  Widget _buildDiscussionsTab(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final messages = chat.getMessages();

    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Text('No messages yet',
                      style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (_, i) =>
                      MessageBubble(message: messages[i]),
                ),
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendMessage,
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
