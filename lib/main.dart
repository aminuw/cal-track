import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/tracking/presentation/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Implémentation réelle de Supabase
  await Supabase.initialize(
    url: 'https://drtihncyxynlwhrlxnrl.supabase.co',
    anonKey: 'sb_publishable_' + 'IKMmusNbE7v9my7Dyk6WEw_gGIKc94J',
  );

  runApp(
    // ProviderScope pour démarrer Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal-Track',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // On affiche directement le routeur d'authentification
      home: const AuthGate(),
    );
  }
}

// -------------------------------------------------------------
// L'AuthGate écoute le flux d'authentification de Supabase
// Il redirige automatiquement vers l'appli ou la page de Login !
// -------------------------------------------------------------
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // Écoute automatique des changements d'état JWT
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppTheme.neonOrange)),
          );
        }
        
        final session = snapshot.hasData ? snapshot.data!.session : null;
        
        // Si on a un JWT valide (connecté), on montre le Dashboard, sinon le Login
        if (session != null) {
          return const DashboardScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
}
