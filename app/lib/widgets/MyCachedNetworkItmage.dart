import 'package:app/core/app_export.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MyCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  MyCachedNetworkImage(
      {Key? key,
      required this.imageUrl,
      this.width,
      this.height,
      this.fit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
          width: width,
          height: height,
          child: CachedNetworkImage(
            fit: fit,
            cacheKey: imageUrl!,
            useOldImageOnUrlChange: true,
            fadeInDuration: const Duration(milliseconds: 0),
            fadeOutDuration: const Duration(milliseconds: 0),
            placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
            )),
            memCacheHeight: 500,
            errorWidget: (context, url, error) => errorImage(),
            imageUrl: imageUrl!,
          ));
    } catch (e) {
      return errorImage();
    }
  }

  Widget errorImage() {
    return Container(
        width: width,
        color: ColorsConstant.lightGreyBG,
        child: Image.asset(
          ImageConstant.imageNotFound,
          fit: BoxFit.fitWidth,
        ));
  }
}
