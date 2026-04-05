import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../widgets/macros_circular_progress.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('CAL-TRACK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Menu pop-up pour se déconnecter
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.surfaceColor,
                  title: const Text('Paramètres', style: TextStyle(color: Colors.white)),
                  content: const Text('Souhaitez-vous vous déconnecter de votre session ?', style: TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(authNotifierProvider.notifier).logout();
                      },
                      child: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
                    ),
                  ],
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
                          value: calories / 2500, // Objectif fixe simulé à 2500
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
                          const Text(
                            '/2500 kcal',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
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
                  target: 180,
                  color: AppTheme.proteinColor,
                ),
                MacrosCircularProgress(
                  label: 'GLUCIDES',
                  current: carbs,
                  target: 280,
                  color: AppTheme.carbsColor,
                ),
                MacrosCircularProgress(
                  label: 'LIPIDES',
                  current: fat,
                  target: 80,
                  color: AppTheme.fatColor,
                ),
              ],
            ),
            
            const SizedBox(height: 48),

            // Bouton Scanner Repas
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Naviguer vers la vue Caméra (CameraCaptureScreen)
                /* Logique de simulation: on va simuler qu'un repas est scanné */
                ref.read(dailyCaloriesProvider.notifier).state += 450;
                ref.read(dailyProteinProvider.notifier).state += 30;
                ref.read(dailyCarbsProvider.notifier).state += 45;
                ref.read(dailyFatProvider.notifier).state += 15;
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Repas analysé avec succès ! (Simulation)'),
                    backgroundColor: AppTheme.neonGreen,
                  )
                );
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
