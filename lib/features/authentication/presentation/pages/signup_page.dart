import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedCountry = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      // Sign-up logic here
      print("Signing up ${_nameController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.80 * 255).round()),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Getting Started",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Seems you are new here, let's set up your profile.",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Current Address',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _zipController,
                                decoration: const InputDecoration(
                                  labelText: 'Zip Code',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Zip code required';
                                  }
                                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                                    return 'Only numbers allowed';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: _selectedCountry),
                                decoration: const InputDecoration(
                                  labelText: 'Country',
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                ),
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: false,
                                    onSelect: (Country country) {
                                      setState(() {
                                        _selectedCountry = country.name;
                                      });
                                    },
                                  );
                                },
                                validator: (value) {
                                  if (_selectedCountry.isEmpty) {
                                    return 'Select a country';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Minimum 6 characters required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.info_outline, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      "By creating an account, you agree to our ",
                                  children: [
                                    TextSpan(
                                      text: "Terms and Conditions",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _handleSignup,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.blue.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
