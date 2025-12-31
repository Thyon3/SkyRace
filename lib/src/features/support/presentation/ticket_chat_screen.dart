import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../data/support_repository.dart';
import '../domain/support_ticket.dart';

class TicketChatScreen extends ConsumerStatefulWidget {
  final SupportTicket ticket;
  const TicketChatScreen({super.key, required this.ticket});

  @override
  ConsumerState<TicketChatScreen> createState() => _TicketChatScreenState();
}

class _TicketChatScreenState extends ConsumerState<TicketChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendResponse() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() => _isSending = true);

    try {
      final repository = ref.read(supportRepositoryProvider);
      final authRepository = ref.read(authRepositoryProvider);
      final token = await authRepository.getToken();

      if (token == null) throw Exception('Not authenticated');

      await repository.addResponse(token, widget.ticket.id, message);
      
      _messageController.clear();
      ref.refresh(userTicketsProvider);
      
      // Auto scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for updates to the specific ticket
    final ticketsAsync = ref.watch(userTicketsProvider);
    final ticket = ticketsAsync.when(
      data: (list) => list.firstWhere((t) => t.id == widget.ticket.id, orElse: () => widget.ticket),
      loading: () => widget.ticket,
      error: (_, __) => widget.ticket,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.subject, style: const TextStyle(fontSize: 16)),
            Text(ticket.status, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                _buildMessageBubble(
                  message: ticket.message,
                  timestamp: ticket.createdAt,
                  isMe: true,
                  isInitial: true,
                ),
                ...ticket.responses.map((resp) => _buildMessageBubble(
                  message: resp.message,
                  timestamp: resp.createdAt,
                  isMe: resp.senderRole == 'USER',
                )),
              ],
            ),
          ),
          if (ticket.status != 'CLOSED' && ticket.status != 'RESOLVED')
            _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required DateTime timestamp,
    required bool isMe,
    bool isInitial = false,
  }) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (isInitial)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(
                'TICKET OPENED',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight, letterSpacing: 1),
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.white : AppColors.textDark, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: isMe ? Colors.white.withOpacity(0.7) : AppColors.textLight, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                maxLines: null,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _isSending ? null : _sendResponse,
              icon: _isSending 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
