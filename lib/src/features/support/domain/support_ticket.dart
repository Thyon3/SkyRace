class SupportTicket {
  final String id;
  final String userId;
  final String subject;
  final String message;
  final String status;
  final String priority;
  final String category;
  final List<TicketResponse> responses;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.message,
    required this.status,
    required this.priority,
    required this.category,
    required this.responses,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 'OPEN',
      priority: json['priority'] ?? 'MEDIUM',
      category: json['category'] ?? 'OTHER',
      responses: (json['responses'] as List? ?? [])
          .map((e) => TicketResponse.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class TicketResponse {
  final String senderRole;
  final String message;
  final DateTime createdAt;

  TicketResponse({
    required this.senderRole,
    required this.message,
    required this.createdAt,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(
      senderRole: json['senderRole'] ?? 'USER',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
