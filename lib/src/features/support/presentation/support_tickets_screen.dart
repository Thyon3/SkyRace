import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../data/support_repository.dart';
import '../domain/support_ticket.dart';
import 'create_ticket_screen.dart';
import 'ticket_chat_screen.dart';

class SupportTicketsScreen extends ConsumerWidget {
  const SupportTicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(userTicketsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Support Tickets'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => ref.refresh(userTicketsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ticketsAsync.when(
        data: (tickets) {
          if (tickets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.ConfirmationNumber_outlined, size: 64, color: AppColors.textLight.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('No tickets found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Need help? Create a new support ticket.', style: TextStyle(color: AppColors.textLight)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return _buildTicketCard(context, ticket);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(userTicketsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTicketScreen()),
          );
        },
        label: const Text('New Ticket'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, SupportTicket ticket) {
    Color statusColor;
    switch (ticket.status) {
      case 'OPEN': statusColor = AppColors.info; break;
      case 'IN_PROGRESS': statusColor = AppColors.warning; break;
      case 'RESOLVED': statusColor = AppColors.success; break;
      case 'CLOSED': statusColor = AppColors.textLight; break;
      default: statusColor = AppColors.textLight;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TicketChatScreen(ticket: ticket)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticket.status,
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  _formatDate(ticket.updatedAt),
                  style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ticket.subject,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 4),
            Text(
              ticket.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMedium, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.category_outlined, size: 14, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(ticket.category, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                const Spacer(),
                if (ticket.responses.isNotEmpty) ...[
                  const Icon(Icons.mode_comment_outlined, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('${ticket.responses.length} responses', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
