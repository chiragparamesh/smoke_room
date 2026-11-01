/// App-wide constants.
class AppConstants {
  static const appName = 'Smoke Room';
  static const tagline = 'Take a break together. Or skip the cigarette.';

  /// Feature modules from the brief. Each one lives in `lib/features/<name>/`.
  static const modules = <AppModule>[
    AppModule('Age Gate', '18+ age gate'),
    AppModule('Room', 'One public room (themed rooms later)'),
    AppModule('Presence', 'Live presence count (Supabase Realtime)'),
    AppModule('Cigarette', 'Cigarette burn-down animation, drag and ash flick'),
    AppModule('Chat', 'Ephemeral chat that disappears when the cigarette ends'),
    AppModule('Quit Mode', 'Quit-mode counter: cigarettes avoided, money saved'),
    AppModule('Moderation', 'Profanity filter and report button'),
  ];
}

class AppModule {
  const AppModule(this.title, this.description);
  final String title;
  final String description;
}
