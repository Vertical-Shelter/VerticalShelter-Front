import 'dart:io';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/SprayWall/sprayWallApi.dart';
import 'package:app/data/models/SprayWall/sprayWallReq.dart';
import 'package:app/data/models/SprayWall/sprayWallResp.dart';
import 'package:app/widgets/textFieldsWidget.dart';
import 'package:image_picker/image_picker.dart';

class SprayWallCardPopup extends StatefulWidget {
  ClimbingLocationResp climbingLocationResp;

  void Function(SprayWallResp sprayWallResp) onValidate;

  SprayWallResp? sprayWallResp;

  SprayWallCardPopup(
      {required this.climbingLocationResp,
      this.sprayWallResp,
      required this.onValidate});
  @override
  _SprayWallCardPopupState createState() => _SprayWallCardPopupState();
}

class _SprayWallCardPopupState extends State<SprayWallCardPopup> {
  File? imageFile;
  bool isInitWithData = false;
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.sprayWallResp != null) {
      titleController.text = widget.sprayWallResp!.name!;
      isInitWithData = true;
    }
  }

  void addSprayWall() {
    SprayWallReq sprayWallReq =
        SprayWallReq(imageFile: imageFile, name: titleController.text);
    if (isInitWithData) {
      update_spraywall(sprayWallReq, widget.climbingLocationResp.id,
          widget.sprayWallResp!.id!);
      widget.onValidate(SprayWallResp(
        id: widget.sprayWallResp!.id,
        climbingLocation_id: widget.sprayWallResp!.climbingLocation_id,
        image:
            imageFile == null ? widget.sprayWallResp!.image : imageFile!.path,
        name: titleController.text,
        annotations: widget.sprayWallResp!.annotations,
      ));
    } else {
      if (imageFile == null) {
        print("erreur y a pas d'image");
        return;
      }
      createSprayWall(sprayWallReq, widget.climbingLocationResp.id)
          .then((value) => widget.onValidate(value));
    }

    Get.back();
  }

  Future<void> getImages() async {
    final ImagePicker picker = ImagePicker();
    await showDialog<PickedFile>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(Get.context!)!.choisissez_une_option,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                var _image = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 50);
                if (_image != null) {
                  imageFile = File(_image.path);
                  setState(() {});
                }
              },
              child: Text(AppLocalizations.of(Get.context!)!.depuis_la_galerie,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                var _image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );

                if (_image != null) {
                  var _imageFile = new File(_image.path);
                  imageFile = _imageFile;
                  setState(() {});
                }
              },
              child: Text(
                AppLocalizations.of(Get.context!)!.prendre_une_photo,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.prendre_une_photo,
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 10),
          Expanded(
              child: Center(
                  child: InkWell(
            onTap: () async {
              await getImages();
            },
            child: isInitWithData == true
                ? Image.network(widget.sprayWallResp!.image!)
                : imageFile == null
                    ? Icon(
                        Icons.add,
                        size: 50,
                      )
                    : Image.file(
                        imageFile!,
                        fit: BoxFit.fitHeight,
                      ),
          ))),
          SizedBox(height: 10),
          Text(AppLocalizations.of(Get.context!)!.nom_mur,
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 10),
          TextFieldWidget(
            controller: titleController,
            hintText: '',
            validator: (a) => null,
          ),
          SizedBox(height: 10),
          Row(children: [
            Spacer(),
            InkWell(
                onTap: () {
                  addSprayWall();
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  alignment: Alignment.center,
                  child: Text(AppLocalizations.of(context)!.ajouter,
                      style: Theme.of(context).textTheme.bodyMedium!),
                ))
          ])
        ],
      ),
    );
  }
}
