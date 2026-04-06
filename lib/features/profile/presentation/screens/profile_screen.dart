import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/profile_notifier.dart';
import '../../data/models/profile_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'M';
  double _activityLevel = 1.2; // Sédentaire par défaut

  @override
  void initState() {
    super.initState();
    // Charger les infos si elles existent déjà
    final profileState = ref.read(profileProvider);
    if (profileState.value != null) {
      final prof = profileState.value!;
      _weightController.text = prof.weight.toString();
      _heightController.text = prof.height.toString();
      _ageController.text = prof.age.toString();
      _selectedGender = prof.gender;
      _activityLevel = prof.activityLevel;
    }
  }

  void _saveProfile() async {
    try {
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);
      final age = int.parse(_ageController.text);

      final profile = ProfileModel.calculateGoals(
        weight: weight,
        height: height,
        age: age,
        gender: _selectedGender,
        activityLevel: _activityLevel,
      );

      await ref.read(profileProvider.notifier).saveProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil mis à jour ! Cible : ${profile.targetCalories} kcal'), backgroundColor: AppTheme.neonGreen),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir correctement les champs.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil Corporel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Poids (kg)', filled: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Taille (cm)', filled: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Âge', filled: true),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: 'M', child: Text('Homme')),
                DropdownMenuItem(value: 'F', child: Text('Femme')),
              ],
              onChanged: (val) => setState(() => _selectedGender = val!),
              decoration: const InputDecoration(labelText: 'Sexe', filled: true),
            ),
            const SizedBox(height: 24),
            Text('Niveau d\'activité (x$_activityLevel)', style: const TextStyle(color: Colors.white)),
            Slider(
              value: _activityLevel,
              min: 1.2,
              max: 2.0,
              divisions: 4,
              activeColor: AppTheme.neonOrange,
              onChanged: (val) => setState(() => _activityLevel = val),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('CALCULER & SAUVEGARDER'),
            )
          ],
        ),
      ),
    );
  }
}
