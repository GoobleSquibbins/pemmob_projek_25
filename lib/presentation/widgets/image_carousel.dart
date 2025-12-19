import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_constants.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> imageUrls;
  final Function(int index)? onImageTap;
  final double? height;

  const ImageCarousel({
    super.key,
    required this.imageUrls,
    this.onImageTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return CarouselSlider.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index, realIndex) {
        final imageUrl = imageUrls[index];
        return GestureDetector(
          onTap: onImageTap != null ? () => onImageTap!(index) : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppConstants.surfaceColor,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppConstants.surfaceColor,
                child: const Icon(
                  Icons.error_outline,
                  color: AppConstants.textSecondaryColor,
                ),
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: height ?? 300,
        viewportFraction: 1.0,
        enableInfiniteScroll: imageUrls.length > 1,
        autoPlay: false,
        enlargeCenterPage: false,
      ),
    );
  }
}

