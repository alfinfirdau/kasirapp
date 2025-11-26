import 'package:flutter/material.dart';

class PaymentMethod {
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;
  final String? imagePath;

  const PaymentMethod({
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
    this.imagePath,
  });
}

class PaymentDialog extends StatefulWidget {
  final double total;
  final List<Map<String, dynamic>> cartItems;
  final Function(String) onPaymentComplete;

  const PaymentDialog({
    super.key,
    required this.total,
    required this.cartItems,
    required this.onPaymentComplete,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String? _selectedPaymentMethod;

  final List<PaymentMethod> _paymentMethods = [
    const PaymentMethod(
      name: 'cash',
      displayName: 'Tunai',
      icon: Icons.money,
      color: Colors.green,
    ),
    const PaymentMethod(
      name: 'dana',
      displayName: 'DANA',
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
    ),
    const PaymentMethod(
      name: 'gopay',
      displayName: 'GoPay',
      icon: Icons.payment,
      color: Colors.blueAccent,
    ),
    const PaymentMethod(
      name: 'qris',
      displayName: 'QRIS',
      icon: Icons.qr_code,
      color: Colors.purple,
    ),
    const PaymentMethod(
      name: 'bca',
      displayName: 'BCA',
      icon: Icons.account_balance,
      color: Colors.red,
    ),
    const PaymentMethod(
      name: 'mandiri',
      displayName: 'Mandiri',
      icon: Icons.account_balance,
      color: Colors.blue,
    ),
    const PaymentMethod(
      name: 'bni',
      displayName: 'BNI',
      icon: Icons.account_balance,
      color: Colors.orange,
    ),
    const PaymentMethod(
      name: 'bri',
      displayName: 'BRI',
      icon: Icons.account_balance,
      color: Colors.blueGrey,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _processPayment(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onPaymentComplete(method);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.payment,
                        size: 48,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Pilih Metode Pembayaran',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: Rp ${widget.total.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Payment Methods Grid
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: _paymentMethods.length,
                      itemBuilder: (context, index) {
                        final method = _paymentMethods[index];
                        final isSelected =
                            _selectedPaymentMethod == method.name;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? method.color
                                  : Theme.of(
                                      context,
                                    ).colorScheme.outline.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            color: isSelected
                                ? method.color.withOpacity(0.1)
                                : Theme.of(context).colorScheme.surface,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: method.color.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: InkWell(
                            onTap: _selectedPaymentMethod == null
                                ? () => _processPayment(method.name)
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isSelected &&
                                      _selectedPaymentMethod == method.name)
                                    const CircularProgressIndicator()
                                  else
                                    Icon(
                                      method.icon,
                                      size: 32,
                                      color: method.color,
                                    ),
                                  const SizedBox(height: 8),
                                  Text(
                                    method.displayName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Footer
                if (_selectedPaymentMethod != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Memproses pembayaran...',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
