import 'package:flutter/material.dart';
import 'package:growwise_mobile_app/core/constants/app_colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool agreeTerms = false;
  bool isLoading = false;

  String passwordStrength = "";

  void checkPasswordStrength(String value) {
    if (value.length < 6) {
      passwordStrength = "Weak";
    } else if (value.length < 8) {
      passwordStrength = "Medium";
    } else {
      passwordStrength = "Strong";
    }
    setState(() {});
  }

  void register() async {
    FocusScope.of(context).unfocus();

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    if (!emailController.text.contains("@")) {
      _showError("Invalid email");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showError("Passwords do not match");
      return;
    }

    if (!agreeTerms) {
      _showError("Please accept terms");
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created successfully")),
    );

    
    await Future.delayed(const Duration(milliseconds: 800));

    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [

              /// IMAGE
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      "assets/images/auth-img.png",
                      fit: BoxFit.cover,
                    ),
                    Container(color: Colors.black.withOpacity(0.25)),

                    Positioned(
                      top: 10,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [

                    const Text(
                      "Sign Up for an Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Enter your details to continue",
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 28),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [

                          _field("Full Name", controller: nameController),

                          const SizedBox(height: 14),

                          _field("Email", controller: emailController),

                          const SizedBox(height: 14),

                          _field(
                            "Password",
                            controller: passwordController,
                            isPassword: true,
                            onChanged: checkPasswordStrength,
                          ),

                          if (passwordController.text.isNotEmpty)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  "Strength: $passwordStrength",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: passwordStrength == "Strong"
                                        ? Colors.green
                                        : passwordStrength == "Medium"
                                            ? Colors.orange
                                            : Colors.red,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 14),

                          _field(
                            "Confirm Password",
                            controller: confirmPasswordController,
                            isPassword: true,
                            isConfirm: true,
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Checkbox(
                                value: agreeTerms,
                                activeColor: AppColors.primary,
                                onChanged: (v) {
                                  setState(() => agreeTerms = v ?? false);
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "I agree to Terms & Conditions",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text("Sign Up"),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label, {
    required TextEditingController controller,
    bool isPassword = false,
    bool isConfirm = false,
    Function(String)? onChanged,
  }) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: TextField(
          controller: controller,
          obscureText: isPassword
              ? (isConfirm ? obscureConfirm : obscurePassword)
              : false,
          onChanged: onChanged,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xFFF4F7F6),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.4,
              ),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (isConfirm ? obscureConfirm : obscurePassword)
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isConfirm) {
                          obscureConfirm = !obscureConfirm;
                        } else {
                          obscurePassword = !obscurePassword;
                        }
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}