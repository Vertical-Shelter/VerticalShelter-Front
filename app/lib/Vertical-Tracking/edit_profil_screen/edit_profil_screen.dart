import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/core/app_export.dart';
import 'package:app/Vertical-Tracking/edit_profil_screen/edit_profil_controller.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:app/widgets/textFieldsWidget.dart';

class VTEditProfilScreen extends GetWidget<VTEditProfilController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => controller.is_loading.value
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                body: Obx(() => controller.userResp.value == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: getPadding(all: 15),
                        child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: getPadding(bottom: 45, top: 25),
                                    child: Row(
                                      children: [
                                        BackButtonWidget(
                                          onPressed: controller.onTapBackButton,
                                        ),
                                        const SizedBox(
                                          width: 45,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.profil,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        )
                                      ],
                                    )),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SafeArea(
                                                  child: Container(
                                                    child: Wrap(
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading: const Icon(
                                                              Icons
                                                                  .photo_library),
                                                          title: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .galerie),
                                                          onTap: () {
                                                            controller.pickImage(
                                                                ImageSource
                                                                    .gallery);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: const Icon(
                                                              Icons.camera_alt),
                                                          title: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .camera),
                                                          onTap: () {
                                                            controller.pickImage(
                                                                ImageSource
                                                                    .camera);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Stack(
                                          children: [
                                            Padding(
                                                padding: getPadding(all: 2),
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: ClipOval(
                                                      child: Obx(() => controller
                                                                  .profile_image
                                                                  .value ==
                                                              null
                                                          ? CircularProgressIndicator()
                                                          : Image.file(
                                                              controller
                                                                  .profile_image
                                                                  .value!,
                                                              width: 100,
                                                              height: 100,
                                                              fit: BoxFit.cover,
                                                            )),
                                                    ))),
                                            const Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ))
                                          ],
                                        )),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Padding(
                                              padding: getPadding(all: 5),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .nom_d_utilisateur,
                                              )),
                                          TextFieldWidget(
                                              controller:
                                                  controller.usernameController,
                                              hintText: controller.userResp
                                                      .value!.username ??
                                                  AppLocalizations.of(context)!
                                                      .pas_de_nom,
                                              validator:
                                                  controller.usernameValidator)
                                        ])),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Padding(
                                    padding: getPadding(all: 8),
                                    child: Text(
                                      '${AppLocalizations.of(context)!.description} :',
                                    )),
                                TextFieldWidget(
                                    controller:
                                        controller.descriptionController,
                                    hintText: controller
                                            .userResp.value!.description ??
                                        '',
                                    validator: controller.descriptionValidator),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: ButtonWidget(
                                      onPressed: () =>
                                          controller.onTapBackButton(),
                                      child: Text(AppLocalizations.of(context)!
                                          .annuler),
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                        child: ButtonWidget(
                                      onPressed: () =>
                                          controller.onPressedSave(),
                                      child: Text(AppLocalizations.of(context)!
                                          .sauvegarder),
                                    ))
                                  ],
                                )
                              ],
                            )))))));
  }
}
