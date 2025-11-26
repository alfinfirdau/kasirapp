import 'package:flutter/material.dart';
import 'dart:math';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;

  const LoginScreen({super.key, this.onThemeToggle});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Main animation controller
  late AnimationController _mainAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Logo animation controllers
  late AnimationController _logoAnimationController;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoScaleAnimation;

  // Staggered animations for form fields
  late AnimationController _staggerAnimationController;
  late List<Animation<double>> _fieldAnimations;

  // Button animation
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  // Background floating elements
  late List<AnimationController> _floatingControllers;
  late List<Animation<double>> _floatingAnimations;

  @override
  void initState() {
    super.initState();

    // Main animation
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _mainAnimationController,
            curve: Curves.elasticOut,
          ),
        );

    // Logo animations
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159)
        .animate(
          CurvedAnimation(
            parent: _logoAnimationController,
            curve: Curves.elasticOut,
          ),
        );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Staggered field animations
    _staggerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fieldAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerAnimationController,
          curve: Interval(index * 0.15, 1.0, curve: Curves.easeOut),
        ),
      );
    });

    // Button animation
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Floating background elements
    _floatingControllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(seconds: 3 + index),
        vsync: this,
      );
    });

    _floatingAnimations = _floatingControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 2 * 3.14159,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    }).toList();

    // Start floating animations
    for (var controller in _floatingControllers) {
      controller.repeat();
    }

    // Start animations sequentially
    _mainAnimationController.forward().then((_) {
      _logoAnimationController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        _staggerAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _logoAnimationController.dispose();
    _staggerAnimationController.dispose();
    _buttonAnimationController.dispose();
    for (var controller in _floatingControllers) {
      controller.dispose();
    }
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    // Animate button press
    await _buttonAnimationController.forward();
    await _buttonAnimationController.reverse();

    // Simple login logic - in real app, validate credentials
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan username dan password'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating background elements
              ...List.generate(5, (index) {
                return AnimatedBuilder(
                  animation: _floatingAnimations[index],
                  builder: (context, child) {
                    final screenSize = MediaQuery.of(context).size;
                    final centerX = screenSize.width / 2;
                    final centerY = screenSize.height / 2;
                    final radius = 150.0 + index * 50;
                    final x =
                        centerX +
                        radius * cos(_floatingAnimations[index].value + index);
                    final y =
                        centerY +
                        radius * sin(_floatingAnimations[index].value + index);

                    return Positioned(
                      left: x - 25,
                      top: y - 25,
                      child: Container(
                        width: 50 + index * 10.0,
                        height: 50 + index * 10.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),

              // Theme toggle button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: widget.onThemeToggle,
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.8),
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animated Logo
                              AnimatedBuilder(
                                animation: Listenable.merge([
                                  _logoRotationAnimation,
                                  _logoScaleAnimation,
                                ]),
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _logoRotationAnimation.value,
                                    child: Transform.scale(
                                      scale: _logoScaleAnimation.value,
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              Theme.of(
                                                context,
                                              ).colorScheme.primaryContainer,
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.3),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.store,
                                          size: 40,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),

                              // Animated Welcome Text
                              AnimatedBuilder(
                                animation: _fieldAnimations[0],
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _fieldAnimations[0].value,
                                    child: Transform.translate(
                                      offset: Offset(
                                        0,
                                        20 * (1 - _fieldAnimations[0].value),
                                      ),
                                      child: Text(
                                        'Selamat Datang',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),

                              // Animated Subtitle
                              AnimatedBuilder(
                                animation: _fieldAnimations[1],
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _fieldAnimations[1].value,
                                    child: Transform.translate(
                                      offset: Offset(
                                        0,
                                        20 * (1 - _fieldAnimations[1].value),
                                      ),
                                      child: Text(
                                        'Masuk ke Aplikasi Kasir',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 32),

                              // Animated Username Field
                              AnimatedBuilder(
                                animation: _fieldAnimations[2],
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _fieldAnimations[2].value,
                                    child: Transform.translate(
                                      offset: Offset(
                                        50 * (1 - _fieldAnimations[2].value),
                                        0,
                                      ),
                                      child: TextField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                          prefixIcon: const Icon(Icons.person),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                              // Animated Password Field
                              AnimatedBuilder(
                                animation: _fieldAnimations[3],
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _fieldAnimations[3].value,
                                    child: Transform.translate(
                                      offset: Offset(
                                        -50 * (1 - _fieldAnimations[3].value),
                                        0,
                                      ),
                                      child: TextField(
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          prefixIcon: const Icon(Icons.lock),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(0.8),
                                        ),
                                        obscureText: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 32),

                              // Animated Login Button
                              AnimatedBuilder(
                                animation: _buttonScaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _buttonScaleAnimation.value,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: _login,
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.3),
                                        ),
                                        child: const Text(
                                          'Masuk',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
          ),
        ),
      ),
    );
  }
}
