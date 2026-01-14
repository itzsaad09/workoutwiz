import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutwiz/models/user_profile.dart';
import 'package:workoutwiz/screens/main_screen.dart';

class SetupScreen extends StatefulWidget {
  final bool isEditing;
  const SetupScreen({super.key, this.isEditing = false});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _heightController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProfileProvider>(context, listen: false);
    _heightController = TextEditingController(
      text: widget.isEditing ? profile.height.toString() : '',
    );
    _ageController = TextEditingController(
      text: widget.isEditing ? profile.age.toString() : '',
    );
    _weightController = TextEditingController(
      text: widget.isEditing ? profile.weight.toString() : '',
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await Provider.of<UserProfileProvider>(
        context,
        listen: false,
      ).updateProfile(
        height: double.parse(_heightController.text),
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
      );

      if (mounted) {
        if (widget.isEditing) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mesh Gradient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [
                          const Color(0xFF020617),
                          const Color(0xFF1E1B4B),
                          const Color(0xFF312E81),
                        ]
                      : [
                          const Color(0xFFF1F5F9),
                          const Color(0xFFE2E8F0),
                          const Color(0xFFCBD5E1),
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.isEditing ? 'Update Profile' : 'Setup Profile',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Optimize your workout experience',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildGlassCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildInput(
                              label: 'Height',
                              suffix: 'cm',
                              icon: Icons.height,
                              controller: _heightController,
                            ),
                            const SizedBox(height: 24),
                            _buildInput(
                              label: 'Age',
                              suffix: 'yr',
                              icon: Icons.cake,
                              controller: _ageController,
                              isInteger: true,
                            ),
                            const SizedBox(height: 24),
                            _buildInput(
                              label: 'Weight',
                              suffix: 'kg',
                              icon: Icons.monitor_weight_outlined,
                              controller: _weightController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.isEditing ? 'Save Changes' : 'Get Started',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (widget.isEditing)
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String suffix,
    required IconData icon,
    required TextEditingController controller,
    bool isInteger = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixText: suffix,
            suffixStyle: const TextStyle(fontWeight: FontWeight.bold),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (double.tryParse(value) == null) return 'Invalid';
            return null;
          },
        ),
      ],
    );
  }
}
