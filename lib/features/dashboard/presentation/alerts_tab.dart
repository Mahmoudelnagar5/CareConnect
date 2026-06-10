import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class AlertsTab extends StatefulWidget {
  const AlertsTab({super.key});

  @override
  State<AlertsTab> createState() => _AlertsTabState();
}

enum _AlertType { booking, reminder, message, system }

class _AlertItem {
  const _AlertItem({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
  });

  final _AlertType type;
  final String title;
  final String body;
  final String time;
  final bool unread;
}

class _AlertsTabState extends State<AlertsTab> {
  late List<_AlertItem> _today;
  late List<_AlertItem> _earlier;

  @override
  void initState() {
    super.initState();
    _today = const [
      _AlertItem(
        type: _AlertType.booking,
        title: 'Booking confirmed',
        body: 'Sofia Reyes accepted your Post-Surgery Care request for tomorrow at 9:00 AM.',
        time: '12m ago',
        unread: true,
      ),
      _AlertItem(
        type: _AlertType.reminder,
        title: 'Visit reminder',
        body: 'Your IV Therapy visit with David Kim starts in 2 hours.',
        time: '1h ago',
        unread: true,
      ),
      _AlertItem(
        type: _AlertType.message,
        title: 'New message',
        body: 'Amelia Hart: "I\'ll arrive 10 minutes early to set up."',
        time: '3h ago',
        unread: false,
      ),
    ];
    _earlier = const [
      _AlertItem(
        type: _AlertType.system,
        title: 'Payment receipt',
        body: 'Your payment of \$96 for Pediatric Care was processed successfully.',
        time: 'Yesterday',
        unread: false,
      ),
      _AlertItem(
        type: _AlertType.booking,
        title: 'Visit completed',
        body: 'Marcus Lee marked your Pediatric Care visit as completed. Leave a review?',
        time: '5 days ago',
        unread: false,
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      _today = _today
          .map((a) => _AlertItem(
                type: a.type,
                title: a.title,
                body: a.body,
                time: a.time,
                unread: false,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasUnread = _today.any((a) => a.unread);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.huge,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Alerts', style: theme.textTheme.headlineSmall),
              ),
              if (hasUnread)
                TextButton(
                  onPressed: _markAllRead,
                  child: const Text('Mark all read'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Stay on top of your care schedule',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          _GroupLabel('Today'),
          const SizedBox(height: AppSpacing.sm),
          for (final a in _today) _AlertTile(item: a),
          const SizedBox(height: AppSpacing.lg),
          _GroupLabel('Earlier'),
          const SizedBox(height: AppSpacing.sm),
          for (final a in _earlier) _AlertTile(item: a),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        letterSpacing: 0.6,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.item});
  final _AlertItem item;

  ({IconData icon, Color color, Color bg}) get _visuals {
    switch (item.type) {
      case _AlertType.booking:
        return (icon: Icons.event_available_rounded, color: AppColors.success, bg: AppColors.successBg);
      case _AlertType.reminder:
        return (icon: Icons.access_time_rounded, color: AppColors.accentOrange, bg: AppColors.accentOrangeBg);
      case _AlertType.message:
        return (icon: Icons.chat_bubble_outline_rounded, color: AppColors.accentBlue, bg: AppColors.accentBlueBg);
      case _AlertType.system:
        return (icon: Icons.receipt_long_rounded, color: AppColors.accentPurple, bg: AppColors.accentPurpleBg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = _visuals;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: v.bg,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(v.icon, color: v.color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        item.time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (item.unread)
              Container(
                margin: const EdgeInsets.only(left: AppSpacing.sm, top: 4),
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
