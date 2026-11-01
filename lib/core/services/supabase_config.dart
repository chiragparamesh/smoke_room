/// Supabase keys are injected at build time, never committed:
///   flutter run -d chrome --dart-define-from-file=env.json
/// In CI they come from the SUPABASE_URL / SUPABASE_ANON_KEY repo secrets.
class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
