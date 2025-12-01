import 'package:flutter/material.dart';
import 'dart:math';
import 'product_list_screen.dart';
import 'product_create_screen.dart';
import 'pos_screen.dart';
import 'transaction_history_screen.dart';
import 'ai_recommendation_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  // Title animation
  late AnimationController _titleAnimationController;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;

  // Floating background elements
  late List<AnimationController> _floatingControllers;
  late List<Animation<double>> _floatingAnimations;

  // Card hover animations
  late Map<int, AnimationController> _cardHoverControllers;
  late Map<int, Animation<double>> _cardScaleAnimations;

  // Loading animation for navigation
  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingRotationAnimation;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Daftar Produk',
      'subtitle': 'Kelola inventaris produk',
      'icon': Icons.inventory,
      'color': Colors.blue,
      'screen': const ProductListScreen(),
    },
    {
      'title': 'Buat Produk Baru',
      'subtitle': 'Tambahkan produk ke katalog',
      'icon': Icons.add_box,
      'color': Colors.green,
      'screen': const ProductCreateScreen(),
    },
    {
      'title': 'POS (Kasir)',
      'subtitle': 'Proses transaksi penjualan',
      'icon': Icons.point_of_sale,
      'color': Colors.orange,
      'screen': const POSScreen(),
    },
    {
      'title': 'Riwayat Transaksi',
      'subtitle': 'Lihat semua transaksi',
      'icon': Icons.history,
      'color': Colors.purple,
      'screen': const TransactionHistoryScreen(),
    },
    {
      'title': 'Rekomendasi AI',
      'subtitle': 'Saran cerdas untuk bisnis',
      'icon': Icons.smart_toy,
      'color': Colors.teal,
      'screen': const AIRecommendationScreen(),
    },
  ];

  @override
  void initState() {
    super.initState();

    // Main staggered animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animations = List.generate(
      _menuItems.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.elasticOut),
        ),
      ),
    );

    // Title animation
    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleAnimationController, curve: Curves.easeIn),
    );

    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _titleAnimationController,
            curve: Curves.elasticOut,
          ),
        );

    // Floating background elements
    _floatingControllers = List.generate(6, (index) {
      return AnimationController(
        duration: Duration(seconds: 4 + index),
        vsync: this,
      );
    });

    _floatingAnimations = _floatingControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 2 * pi,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    }).toList();

    // Card hover animations
    _cardHoverControllers = {};
    _cardScaleAnimations = {};

    for (int i = 0; i < _menuItems.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
      _cardHoverControllers[i] = controller;
      _cardScaleAnimations[i] = Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }

    // Loading animation
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _loadingRotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.linear,
      ),
    );

    // Start animations
    _animationController.forward();
    _titleAnimationController.forward();

    for (var controller in _floatingControllers) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleAnimationController.dispose();
    _loadingAnimationController.dispose();
    for (var controller in _floatingControllers) {
      controller.dispose();
    }
    for (var controller in _cardHoverControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _navigateToScreen(Widget screen) async {
    // Start loading animation
    _loadingAnimationController.repeat();

    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: AnimatedBuilder(
          animation: _loadingRotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _loadingRotationAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.store,
                  size: 40,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            );
          },
        ),
      ),
    );

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Stop loading and navigate
    _loadingAnimationController.stop();
    Navigator.of(context).pop(); // Close loading dialog

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
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
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating background elements
            ...List.generate(6, (index) {
              return AnimatedBuilder(
                animation: _floatingAnimations[index],
                builder: (context, child) {
                  final screenSize = MediaQuery.of(context).size;
                  final centerX = screenSize.width / 2;
                  final centerY = screenSize.height / 2;
                  final radius = 200.0 + index * 60;
                  final x =
                      centerX +
                      radius *
                          cos(_floatingAnimations[index].value + index * 0.5);
                  final y =
                      centerY +
                      radius *
                          sin(_floatingAnimations[index].value + index * 0.5);

                  return Positioned(
                    left: x - 30,
                    top: y - 30,
                    child: Container(
                      width: 60 + index * 15.0,
                      height: 60 + index * 15.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.05),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated title
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _titleFadeAnimation,
                      _titleSlideAnimation,
                    ]),
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _titleFadeAnimation,
                        child: SlideTransition(
                          position: _titleSlideAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.1),
                                  Theme.of(
                                    context,
                                  ).colorScheme.secondary.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.waving_hand,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Selamat Datang di Kasir App',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pilih menu yang ingin Anda akses untuk mengelola bisnis Anda dengan mudah',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _menuItems.length,
                      itemBuilder: (context, index) {
                        final item = _menuItems[index];
                        return AnimatedBuilder(
                          animation: _animations[index],
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                50 * (1 - _animations[index].value),
                              ),
                              child: Opacity(
                                opacity: _animations[index].value,
                                child: Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    onTap: () =>
                                        _navigateToScreen(item['screen']),
                                    borderRadius: BorderRadius.circular(16),
                                    splashColor: item['color'].withOpacity(0.1),
                                    highlightColor: item['color'].withOpacity(
                                      0.05,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: item['color'].withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              item['icon'],
                                              size: 32,
                                              color: item['color'],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['title'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  item['subtitle'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
