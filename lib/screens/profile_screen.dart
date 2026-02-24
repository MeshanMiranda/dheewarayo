import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'base_screen.dart';
import '../theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: 'meshanmiranda@gmail.com',
  );
  final TextEditingController _usernameController = TextEditingController(
    text: 'meshan',
  );
  final TextEditingController _fullNameController = TextEditingController(
    text: 'Meshan Miranda',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '+94 764315233',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      title: l10n.profile,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/img/meshan.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: primaryDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              l10n.email,
              _emailController,
              Icons.email_outlined,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              l10n.username,
              _usernameController,
              Icons.account_circle_outlined,
              TextInputType.text,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              l10n.fullName,
              _fullNameController,
              Icons.badge_outlined,
              TextInputType.name,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              l10n.phoneNumber,
              _phoneController,
              Icons.phone_outlined,
              TextInputType.phone,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Save logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.profileUpdatedSuccessfully)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.saveChanges,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    TextInputType keyboardType,
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryDark),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryDark, width: 2),
        ),
      ),
    );
  }
}
