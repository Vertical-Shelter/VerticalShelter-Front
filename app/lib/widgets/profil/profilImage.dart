import 'package:app/data/models/gamingObject/baniereResp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/core/app_export.dart';
import 'package:cached_network_image/cached_network_image.dart';

class profileImage extends StatelessWidget {
  final double? size;
  final String? image;
  final BaniereResp? baniereImage;

  const profileImage({Key? key, this.image, this.size, this.baniereImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: size == null ? 20 : size! / 2 - 10, //coder sur le cul
            backgroundImage: image != null
                ? CachedNetworkImageProvider(
                    image!,
                    // fit: BoxFit.cover,
                  )
                : Image.asset(
                    ImageConstant.imageNotFound,
                    fit: BoxFit.cover,
                  ).image,

            backgroundColor: Color.fromARGB(255, 110, 110, 110),
          ),
          if (baniereImage != null)
            CachedNetworkImage(
                height: size ?? 45, imageUrl: baniereImage!.image!),
        ],
      );
    } catch (e) {
      return CircleAvatar(
        radius: size ?? 20,
        child: Image.asset(
          ImageConstant.LogoVerticalShelter,
          fit: BoxFit.cover,
        ),
        backgroundColor: Color.fromARGB(255, 110, 110, 110),
      );
    }
  }
}
