import 'package:app/Vertical-Tracking/news/NewsFile/newsFileController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class NewsDetailsScreen extends GetWidget<NewsDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Obx(() => controller.isLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Stack(children: [
                          GestureDetector(
                            onTap: () async => await showDialog(
                                context: context,
                                builder: ((context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Stack(children: [
                                      PhotoView(
                                        minScale:
                                            PhotoViewComputedScale.contained *
                                                1,
                                        maxScale:
                                            PhotoViewComputedScale.covered *
                                                1.8,
                                        basePosition: Alignment.center,
                                        backgroundDecoration:
                                            const BoxDecoration(
                                                color: Colors.transparent),
                                        imageProvider:
                                            CachedNetworkImageProvider(
                                                controller
                                                    .newsResp!.value.imageUrl!),
                                      ),
                                      Positioned(
                                          top: 10,
                                          right: 10,
                                          child: InkWell(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            180)),
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 10,
                                                    bottom: 10),
                                                child: Icon(Icons.close,
                                                    size: width * 0.04,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface)),
                                          ))
                                    ])))),
                            child: Container(
                                height: context.height * 0.35,
                                width: width,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      controller.newsResp.value.imageUrl ?? '',
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Positioned(
                              top: 5,
                              left: 5,
                              child: BackButtonWidget(
                                onPressed: () => controller.onBackPressed(),
                              )),
                          Positioned(
                              bottom: 5,
                              left: 5,
                              // height: 40,
                              child: Row(children: [
                                Container(
                                    constraints:
                                        BoxConstraints(maxWidth: width),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: EdgeInsets.only(
                                        left: 9, right: 9, top: 9, bottom: 9),
                                    // color: Colors.black,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            "${AppLocalizations.of(Get.context!)!.publie_le} ${controller.dayOfWeek.value} ${controller.dayMonth.value}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface)),
                                      ],
                                    )),
                                SizedBox(width: 5),
                              ])),
                        ]),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            controller.newsResp.value.title ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 30),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                              Text(controller.newsResp.value.description ?? ''),
                        ),
                      ]))));
  }
}
