import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/common/avatar_widget.dart';
import '../../../data/dummy_data.dart';
import '../../../models/live_class_model.dart';

/// Live class screen for viewing and participating in live sessions
class LiveClassScreen extends StatefulWidget {
  const LiveClassScreen({super.key, this.liveClassId});

  final String? liveClassId;

  @override
  State<LiveClassScreen> createState() => _LiveClassScreenState();
}

class _LiveClassScreenState extends State<LiveClassScreen> {
  LiveClassModel? _liveClass;
  bool _isChatVisible = true;
  bool _isHandRaised = false;
  final _chatController = TextEditingController();
  final List<LiveChatMessage> _chatMessages = [];

  @override
  void initState() {
    super.initState();
    _loadLiveClass();
    _loadChatMessages();
  }

  void _loadLiveClass() {
    if (widget.liveClassId != null) {
      _liveClass = DummyData.liveClasses.firstWhere(
        (lc) => lc.id == widget.liveClassId,
        orElse: () => DummyData.liveClasses.first,
      );
    } else {
      _liveClass = DummyData.liveClasses.first;
    }
  }

  void _loadChatMessages() {
    _chatMessages.addAll([
      LiveChatMessage(
        id: '1',
        userName: 'Alice Johnson',
        message: 'This is so helpful!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      LiveChatMessage(
        id: '2',
        userName: 'Bob Smith',
        message: 'Can you explain that again?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      LiveChatMessage(
        id: '3',
        userName: 'Carol White',
        message: 'Thanks for the explanation!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ]);
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add(LiveChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: 'You',
        message: text,
        timestamp: DateTime.now(),
        isMe: true,
      ));
      _chatController.clear();
    });
  }

  void _toggleHand() {
    setState(() {
      _isHandRaised = !_isHandRaised;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isHandRaised
              ? 'Hand raised! The teacher will be notified.'
              : 'Hand lowered.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _leaveClass() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Class?'),
        content: const Text(
          'Are you sure you want to leave this live class? You can rejoin anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Leave',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_liveClass == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Video area
              _buildVideoArea(),
              // Controls
              _buildControls(),
              // Chat area
              if (_isChatVisible) _buildChatArea(),
            ],
          ),
          // Top overlay
          _buildTopOverlay(),
        ],
      ),
    );
  }

  Widget _buildVideoArea() {
    return Expanded(
      child: Container(
        color: AppColors.textPrimary,
        child: Stack(
          children: [
            // Video placeholder
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.videocam,
                      size: 50,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  const Text(
                    'Live Video Stream',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Live badge
            Positioned(
              top: 60,
              left: AppSizes.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    const Text(
                      AppStrings.live,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Viewer count
            Positioned(
              top: 60,
              right: AppSizes.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      '${_liveClass!.viewerCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      color: AppColors.darkSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: _isHandRaised ? Icons.back_hand : Icons.back_hand_outlined,
            label: 'Raise Hand',
            isActive: _isHandRaised,
            onTap: _toggleHand,
          ),
          _buildControlButton(
            icon: Icons.chat,
            label: 'Chat',
            isActive: _isChatVisible,
            onTap: () {
              setState(() {
                _isChatVisible = !_isChatVisible;
              });
            },
          ),
          _buildControlButton(
            icon: Icons.people,
            label: 'Participants',
            onTap: () {
              _showParticipantsSheet();
            },
          ),
          _buildControlButton(
            icon: Icons.exit_to_app,
            label: 'Leave',
            isDestructive: true,
            onTap: _leaveClass,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    Color color;
    if (isDestructive) {
      color = AppColors.error;
    } else if (isActive) {
      color = AppColors.primary;
    } else {
      color = Colors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      height: 250,
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          // Chat header
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isChatVisible = false;
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.sm),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                return _buildChatMessage(_chatMessages[index]);
              },
            ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Send a message...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: AppColors.darkBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.sm,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(LiveChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWidget(
            name: message.userName,
            size: 24,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.userName,
                  style: TextStyle(
                    color: message.isMe ? AppColors.primaryLight : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  message.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top,
          left: AppSizes.md,
          right: AppSizes.md,
          bottom: AppSizes.md,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _liveClass!.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _liveClass!.teacher?.name ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showParticipantsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            const Text(
              'Participants',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            // Teacher
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const AvatarWidget(
                name: 'Dr. Sarah Johnson',
                size: 40,
              ),
              title: const Text(
                'Dr. Sarah Johnson (Host)',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Text(
                  'Host',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const Divider(color: AppColors.border),
            // Participants list
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: AvatarWidget(
                      name: 'Student ${index + 1}',
                      size: 40,
                    ),
                    title: Text(
                      'Student ${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: index == 2
                        ? const Icon(
                            Icons.back_hand,
                            color: AppColors.warning,
                            size: 20,
                          )
                        : null,
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

/// Live chat message model
class LiveChatMessage {
  const LiveChatMessage({
    required this.id,
    required this.userName,
    required this.message,
    required this.timestamp,
    this.isMe = false,
  });

  final String id;
  final String userName;
  final String message;
  final DateTime timestamp;
  final bool isMe;
}
