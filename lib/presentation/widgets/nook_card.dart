import 'package:flutter/material.dart';
import '../../data/models/nook_model.dart';
import '../../core/constants/app_constants.dart';

class NookCard extends StatelessWidget {
  final NookModel nook;
  final VoidCallback onTap;

  const NookCard({
    super.key,
    required this.nook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.surfaceColor,
      margin: const EdgeInsets.all(AppConstants.spacingSmall),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusSmall,
                  ),
                ),
                child: Icon(
                  Icons.group,
                  size: 48,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              Text(
                nook.name,
                style: TextStyle(
                  color: AppConstants.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                nook.description,
                style: TextStyle(
                  color: AppConstants.textSecondaryColor,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

