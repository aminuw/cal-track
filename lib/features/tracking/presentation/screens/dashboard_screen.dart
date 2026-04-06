import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../profile/presentation/providers/profile_notifier.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../widgets/macros_circular_progress.dart';
import 'camera_capture_screen.dart';

// Petit provider temporaire pour simuler l'état local avant le raccordement Grok
final dailyCaloriesProvider = StateProvider<int>((ref) => 1850);
final dailyProteinProvider = StateProvider<int>((ref) => 120);
final dailyCarbsProvider = StateProvider<int>((ref) => 150);
final dailyFatProvider = StateProvider<int>((ref) => 50);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute de l'état
    final calories = ref.watch(dailyCaloriesProvider);
    final protein = ref.watch(dailyProteinProvider);
    final carbs = ref.watch(dailyCarbsProvider);
    final fat = ref.watch(dailyFatProvider);
    
    // Écoute du profil
    final profileState = ref.watch(profileProvider);
    final int targetCalories = profileState.value?.targetCalories ?? 2500;
    
    // Macros déduits sommairement de la cible calorique pour l'UI (Ratio 30/45/25)
    final targetProtein = (targetCalories * 0.3 / 4).round();
    final targetCarbs = (targetCalories * 0.45 / 4).round();
    final targetFat = (targetCalories * 0.25 / 9).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CAL-TRACK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Menu pop-up pour se déconnecter ou gérer profil
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.surfaceColor,
                  title: const Text('Menu', style: TextStyle(color: Colors.white)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       ListTile(
                         leading: const Icon(Icons.person, color: Colors.white),
                         title: const Text('Mon Profil', style: TextStyle(color: Colors.white)),
                         onTap: () {
                           Navigator.pop(context);
                           Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                         },
                       ),
                       const Divider(color: Colors.grey),
                       ListTile(
                         leading: const Icon(Icons.logout, color: Colors.red),
                         title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
                         onTap: () {
                           Navigator.pop(context);
                           ref.read(authNotifierProvider.notifier).logout();
                         },
                       ),
                    ]
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Aperçu du Jour',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            
            // Cartes Calories
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                   const Text(
                    'CALORIES',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: calories / targetCalories,
                          backgroundColor: Colors.grey[850],
                          color: AppTheme.neonOrange,
                          strokeWidth: 12,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '$calories',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/$targetCalories kcal',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Ligne Macros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MacrosCircularProgress(
                  label: 'PROTÉINES',
                  current: protein,
                  target: targetProtein,
                  color: AppTheme.proteinColor,
                ),
                MacrosCircularProgress(
                  label: 'GLUCIDES',
                  current: carbs,
                  target: targetCarbs,
                  color: AppTheme.carbsColor,
                ),
                MacrosCircularProgress(
                  label: 'LIPIDES',
                  current: fat,
                  target: targetFat,
                  color: AppTheme.fatColor,
                ),
              ],
            ),
            
            const SizedBox(height: 48),

            // Bouton Scanner Repas
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraCaptureScreen()));
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('SCANNER UN REPAS'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
