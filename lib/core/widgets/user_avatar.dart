import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.imageProfile,
    required this.initials,
    this.radius = 26,
    this.onTap,
  });

  final String? imageProfile;
  final String initials;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primaryLight,
        backgroundImage: _resolveImage(),
        child: _resolveImage() == null
            ? Text(
                initials,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: radius * 0.7,
                ),
              )
            : null,
      ),
    );
  }

  ImageProvider? _resolveImage() {
    if (imageProfile == null) return null;
    if (imageProfile!.startsWith('http')) {
      return CachedNetworkImageProvider(imageProfile!);
    }
    if (imageProfile!.startsWith('data:image')) {
      final data = imageProfile!.split(',').last;
      return MemoryImage(base64Decode(data));
    }
    return null;
  }
}
