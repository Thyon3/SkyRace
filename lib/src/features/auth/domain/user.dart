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

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json, {String? token}) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: token ?? json['token'],
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      preferences: preferences ?? this.preferences,
    );
  }
}
