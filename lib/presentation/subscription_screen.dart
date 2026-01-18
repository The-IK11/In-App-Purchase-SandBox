import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedPlanIndex = 1; // Default to yearly (best value)

  late AnimationController _badgeAnimationController;
  late Animation<double> _badgeScaleAnimation;

  @override
  void initState() {
    super.initState();
    _badgeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _badgeScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _badgeAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _badgeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _badgeAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _badgeAnimationController.dispose();
    super.dispose();
  }

  void _onBadgeTap() {
    _badgeAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Premium Badge
                _buildPremiumBadge(),
                const SizedBox(height: 32),

                // Features List
                _buildFeaturesList(),
                const SizedBox(height: 32),

                // Subscription Plans
                _buildSubscriptionPlans(),
                const SizedBox(height: 32),

                // Coin Packages
                _buildCoinPackagesSection(),
                const SizedBox(height: 32),

                // Subscribe Button
                _buildSubscribeButton(),
                const SizedBox(height: 16),

                // Terms
                _buildTermsText(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close, color: Colors.white70, size: 28),
        ),
        const Text(
          'Go Premium',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 48), // Balance the header
      ],
    );
  }

  Widget _buildPremiumBadge() {
    return GestureDetector(
      onTap: _onBadgeTap,
      child: AnimatedBuilder(
        animation: _badgeScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _badgeScaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.workspace_premium,
            size: 64,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': Icons.block, 'text': 'Remove all ads'},
      {'icon': Icons.download, 'text': 'Unlimited downloads'},
      {'icon': Icons.high_quality, 'text': 'HD quality content'},
      {'icon': Icons.support_agent, 'text': 'Priority support'},
      {'icon': Icons.new_releases, 'text': 'Early access to features'},
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D9FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: const Color(0xFF00D9FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                feature['text'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubscriptionPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Plan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Monthly Plan
        _buildPlanCard(
          index: 0,
          title: 'Monthly',
          price: '\$9.99',
          period: '/month',
          description: 'Billed monthly',
          badge: null,
        ),
        const SizedBox(height: 12),
        // Yearly Plan
        _buildPlanCard(
          index: 1,
          title: 'Yearly',
          price: '\$59.99',
          period: '/year',
          description: 'Billed annually (\$5/mo)',
          badge: 'SAVE 50%',
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required String period,
    required String description,
    String? badge,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF00D9FF) : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    const Color(0xFF00D9FF).withOpacity(0.15),
                    const Color(0xFF00D9FF).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
        ),
        child: Row(
          children: [
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF00D9FF) : Colors.white38,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00D9FF),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Plan details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinPackagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.monetization_on,
              color: Color(0xFFFFD700),
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Coin Packages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildCoinCard(
                coins: 100,
                price: '\$0.99',
                color: const Color(0xFFCD7F32), // Bronze
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCoinCard(
                coins: 500,
                price: '\$3.99',
                color: const Color(0xFFC0C0C0), // Silver
                bonus: '+50',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCoinCard(
                coins: 1200,
                price: '\$7.99',
                color: const Color(0xFFFFD700), // Gold
                bonus: '+200',
                isBestValue: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoinCard({
    required int coins,
    required String price,
    required Color color,
    String? bonus,
    bool isBestValue = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle coin purchase
        _showPurchaseDialog('$coins Coins', price);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          ),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          children: [
            if (isBestValue)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BEST VALUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.monetization_on, color: color, size: 40),
                if (bonus != null)
                  Positioned(
                    right: -12,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        bonus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$coins',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'coins',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeButton() {
    final planName = _selectedPlanIndex == 0 ? 'Monthly' : 'Yearly';
    final planPrice = _selectedPlanIndex == 0 ? '\$9.99' : '\$59.99';

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF00D9FF), Color(0xFF00A8CC)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D9FF).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle subscription
          _showPurchaseDialog('$planName Subscription', planPrice);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_launch, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Subscribe $planName - $planPrice',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Column(
      children: [
        Text(
          'Cancel anytime. Terms and conditions apply.',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Color(0xFF00D9FF),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(' • ', style: TextStyle(color: Colors.white38)),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Terms of Service',
                style: TextStyle(
                  color: Color(0xFF00D9FF),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPurchaseDialog(String item, String price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.shopping_cart, color: Color(0xFF00D9FF)),
            const SizedBox(width: 8),
            const Text(
              'Confirm Purchase',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          'Would you like to purchase $item for $price?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Processing purchase for $item...'),
                  backgroundColor: const Color(0xFF00D9FF),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Purchase',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
