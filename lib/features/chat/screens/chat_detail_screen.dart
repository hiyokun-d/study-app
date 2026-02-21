import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/common/avatar_widget.dart';

/// Chat detail screen for messaging between users
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Load dummy messages
    _messages.addAll([
      ChatMessage(
        id: '1',
        text: 'Hi! I have a question about the calculus course.',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: '2',
        text: 'Hello! Of course, I\'d be happy to help. What would you like to know?',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      ),
      ChatMessage(
        id: '3',
        text: 'I\'m struggling with the integration by parts section. Can you explain it more simply?',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      ),
      ChatMessage(
        id: '4',
        text: 'Of course! Integration by parts is essentially the reverse of the product rule. Think of it as:\n\n∫u dv = uv - ∫v du\n\nThe key is choosing u and dv correctly. Would you like me to walk through an example?',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
      ),
      ChatMessage(
        id: '5',
        text: 'Yes please! That would be very helpful.',
        isMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      ChatMessage(
        id: '6',
        text: 'Great! Let\'s solve ∫x·e^x dx\n\nStep 1: Choose u = x (easier to differentiate)\nStep 2: Then dv = e^x dx\nStep 3: Find du = dx and v = e^x\n\nNow apply the formula:\n∫x·e^x dx = x·e^x - ∫e^x dx\n= x·e^x - e^x + C\n= e^x(x - 1) + C\n\nDoes this help?',
        isMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
    ]);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
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
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final showDate = index == 0 ||
                    !_isSameDay(
                      _messages[index - 1].timestamp,
                      message.timestamp,
                    );
                return Column(
                  children: [
                    if (showDate) _buildDateSeparator(message.timestamp),
                    _buildMessageBubble(message),
                  ],
                );
              },
            ),
          ),
          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      ),
      title: Row(
        children: [
          const AvatarWidget(
            name: 'Dr. Sarah Johnson',
            size: 40,
            isOnline: true,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dr. Sarah Johnson',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  AppStrings.online,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.videocam, color: AppColors.primary),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.call, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    String text;
    if (messageDate == today) {
      text = 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      text = 'Yesterday';
    } else {
      text = '${date.day}/${date.month}/${date.year}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.md),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: message.isMe ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppSizes.radiusLg),
                  topRight: const Radius.circular(AppSizes.radiusLg),
                  bottomLeft: Radius.circular(
                    message.isMe ? AppSizes.radiusLg : AppSizes.radiusSm,
                  ),
                  bottomRight: Radius.circular(
                    message.isMe ? AppSizes.radiusSm : AppSizes.radiusLg,
                  ),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: message.isMe ? Colors.white : AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.sm,
        bottom: MediaQuery.of(context).viewPadding.bottom + AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.attach_file,
              color: AppColors.textSecondary,
            ),
          ),
          // Text input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: AppStrings.typeMessage,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Chat message model
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
}
