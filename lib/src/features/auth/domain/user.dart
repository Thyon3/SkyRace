class UserPreferences {
  final String language;
  final String currency;
  final String theme;

  UserPreferences({
    required this.language,
    required this.currency,
    required this.theme,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'en',
      currency: json['currency'] ?? 'USD',
      theme: json['theme'] ?? 'light',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'currency': currency,
      'theme': theme,
    };
  }

  UserPreferences copyWith({
    String? language,
    String? currency,
    String? theme,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      theme: theme ?? this.theme,
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? token;
  final UserPreferences preferences;
  final int loyaltyPoints;
  final String loyaltyTier;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.preferences,
    this.loyaltyPoints = 0,
    this.loyaltyTier = 'Bronze',
  });

  factory User.fromJson(Map<String, dynamic> json, {String? token}) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: token ?? json['token'],
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
      loyaltyTier: json['loyaltyTier'] ?? 'Bronze',
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    UserPreferences? preferences,
    int? loyaltyPoints,
    String? loyaltyTier,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      preferences: preferences ?? this.preferences,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      loyaltyTier: loyaltyTier ?? this.loyaltyTier,
    );
  }
}
