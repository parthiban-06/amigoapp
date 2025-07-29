import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class VisaCacheNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const VisaCacheNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 160,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheManager: CustomCacheManager.instance,
        // Custom caching
        placeholder: (context, url) => placeholder ?? _defaultShimmerLoader(),
        errorWidget: (context, url, error) => GestureDetector(
          onTap: () {
            CachedNetworkImage.evictFromCache(url); // Tap to retry
          },
          child: errorWidget ?? _defaultErrorWidget(),
        ),
      ),
    );
  }

  // Shimmer placeholder
  Widget _defaultShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey,
      ),
    );
  }

  // Default error widget
  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
      ),
    );
  }

  // Utility: Preload image
  static void preload(BuildContext context, String imageUrl) {
    precacheImage(CachedNetworkImageProvider(imageUrl), context);
  }
}

class CustomCacheManager {
  static final BaseCacheManager instance = CacheManager(
    Config(
      'visaImageCache',
      stalePeriod: const Duration(days: 7), // keep cache for 7 days
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: 'visa_cache'),
      fileService: HttpFileService(),
    ),
  );
}
