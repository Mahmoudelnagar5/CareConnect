import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class _Service {
  const _Service({
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.minHours,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String title;
  final String category;
  final String description;
  final int price;
  final int minHours;
  final IconData icon;
  final Color color;
  final Color background;
}

class ServicesTab extends StatefulWidget {
  const ServicesTab({super.key, required this.onBook});

  final ValueChanged<String> onBook;

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  static const _services = [
    _Service(
      title: 'General Nursing',
      category: 'GENERAL',
      description: 'Vital signs, wound care, and general health monitoring at home.',
      price: 50,
      minHours: 2,
      icon: Icons.medical_services_outlined,
      color: AppColors.secondary,
      background: AppColors.secondaryLight,
    ),
    _Service(
      title: 'Elderly Care',
      category: 'SPECIALIZED',
      description: 'Comprehensive daily assistance and medical care for seniors.',
      price: 120,
      minHours: 4,
      icon: Icons.favorite_border_rounded,
      color: AppColors.accentPink,
      background: AppColors.accentPinkBg,
    ),
    _Service(
      title: 'Pediatric Care',
      category: 'PEDIATRIC',
      description: 'Specialized care for infants and children at home.',
      price: 80,
      minHours: 3,
      icon: Icons.child_care_outlined,
      color: AppColors.accentBlue,
      background: AppColors.accentBlueBg,
    ),
    _Service(
      title: 'Post-Surgery Care',
      category: 'SPECIALIZED',
      description: 'Attentive recovery support and wound management after surgery.',
      price: 110,
      minHours: 4,
      icon: Icons.healing_outlined,
      color: AppColors.accentPurple,
      background: AppColors.accentPurpleBg,
    ),
    _Service(
      title: 'Physical Therapy',
      category: 'THERAPY',
      description: 'In-home mobility, strength, and rehabilitation sessions.',
      price: 90,
      minHours: 2,
      icon: Icons.accessibility_new_rounded,
      color: AppColors.accentOrange,
      background: AppColors.accentOrangeBg,
    ),
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _services
        .where((s) => s.title.toLowerCase().contains(_query.toLowerCase()) || s.category.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Our Services', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Find the right home care professional', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(hintText: 'Search services...', prefixIcon: Icon(Icons.search)),
                  ),
                ],
              ),
            ),
          ),
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No services match "$_query".', style: theme.textTheme.bodyMedium)),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.huge),
              sliver: SliverList.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) =>
                    _ServiceCard(service: filtered[index], onBook: () => widget.onBook(filtered[index].title)),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onBook});

  final _Service service;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(color: service.background, borderRadius: BorderRadius.circular(AppRadius.md)),
                child: Icon(service.icon, color: service.color, size: 26),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      service.category,
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Text('\$${service.price}', style: theme.textTheme.titleLarge?.copyWith(color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(service.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Icon(Icons.favorite_border_rounded, size: 16, color: AppColors.textTertiary),
              const SizedBox(width: AppSpacing.xs),
              Text('${service.minHours} hours min', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const Spacer(),
              ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.surface,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                child: const Text('Book Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
