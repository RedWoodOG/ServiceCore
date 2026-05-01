/// Settings Schema
/// Settings are state, not behavior.
/// User settings only toggle pre-defined options.
library;

enum ThemeSetting {
  light,
  dark,
  system,
}

enum AccentSetting {
  defaultAccent,
  variant1,
  variant2,
}

enum LogoVariantSetting {
  auto,
  light,
  dark,
}

class UserSettings {
  final ThemeSetting theme;
  final AccentSetting accent;
  final LogoVariantSetting logoVariant;

  const UserSettings({
    this.theme = ThemeSetting.dark,
    this.accent = AccentSetting.defaultAccent,
    this.logoVariant = LogoVariantSetting.auto,
  });

  UserSettings copyWith({
    ThemeSetting? theme,
    AccentSetting? accent,
    LogoVariantSetting? logoVariant,
  }) {
    return UserSettings(
      theme: theme ?? this.theme,
      accent: accent ?? this.accent,
      logoVariant: logoVariant ?? this.logoVariant,
    );
  }

  Map<String, dynamic> toJson() => {
        'theme': theme.name,
        'accent': accent.name,
        'logoVariant': logoVariant.name,
      };

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      theme: ThemeSetting.values.firstWhere(
        (e) => e.name == json['theme'],
        orElse: () => ThemeSetting.dark,
      ),
      accent: AccentSetting.values.firstWhere(
        (e) => e.name == json['accent'],
        orElse: () => AccentSetting.defaultAccent,
      ),
      logoVariant: LogoVariantSetting.values.firstWhere(
        (e) => e.name == json['logoVariant'],
        orElse: () => LogoVariantSetting.auto,
      ),
    );
  }
}
