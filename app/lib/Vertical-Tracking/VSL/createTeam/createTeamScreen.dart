import 'package:app/Vertical-Tracking/VSL/createTeam/createTeamController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/climbingLocationMinimalist.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:app/widgets/textFieldShaker/textFieldShakerWidget.dart';
import 'package:app/widgets/vsl/roleCard.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:image_picker/image_picker.dart';

class CreateTeamscreen extends GetWidget<CreateTeamcontroller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Obx(
          () => controller.index.value == 1
              ? informationEquipe(context)
              : controller.index.value == 2
                  ? informationPerso(context)
                  : controller.index.value == 3
                      ? selectRole(context)
                      : recap(context),
        ),
        bottomNavigationBar: bottomBar(context));
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Obx(() => controller.index.value == 1
            ? Text(
                AppLocalizations.of(context)!.create_team_title,
                style: Theme.of(context).textTheme.labelLarge,
              )
            : controller.index.value == 2
                ? Text(
                    AppLocalizations.of(context)!.s_inscrire_vsl,
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                : controller.index.value == 3
                    ? Text(
                        AppLocalizations.of(context)!.mon_role_vsl,
                        style: Theme.of(context).textTheme.labelLarge,
                      )
                    : Text(
                        "Recap",
                        style: Theme.of(context).textTheme.labelLarge,
                      )));
  }

  Widget informationEquipe(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ShakeTextField(
            controller: controller.guildName,
            shakeController: controller.guildNameShake,
            hintText: AppLocalizations.of(context)!.team_name_vsl,
            borderColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(
            "${AppLocalizations.of(context)!.team_photo_vsl} *",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 10),
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
                                leading: const Icon(Icons.photo_library),
                                title:
                                    Text(AppLocalizations.of(context)!.galerie),
                                onTap: () {
                                  controller.pickImage(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title:
                                    Text(AppLocalizations.of(context)!.camera),
                                onTap: () {
                                  controller.pickImage(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: controller.image_guild.value == null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(
                            Icons.add,
                          ))
                      : Stack(
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  controller.image_guild.value!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                ))
                          ],
                        ))),
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.choisit_ta_salle,
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 10),
          Expanded(
              child: ListWheelScrollView(
                  perspective: 0.0015,
                  itemExtent: 70,
                  onSelectedItemChanged: (index) {
                    controller.climbingLocationSelected.value =
                        controller.climbingGymList[index];
                  },
                  children: [
                for (int index = 0;
                    index < controller.climbingGymList.length;
                    index++)
                  ClimbingLocationMinimalistWidget(
                    context,
                    controller.climbingGymList[index],
                    onPressed: () => controller.climbingLocationSelected.value =
                        controller.climbingGymList[index],
                    isSelected: controller.climbingLocationSelected.value ==
                        controller.climbingGymList[index],
                  )
              ]))
        ],
      ),
    );
  }

  Widget informationPerso(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ShakeTextField(
            controller: controller.lastname,
            shakeController: controller.lastnameShake,
            hintText: AppLocalizations.of(context)!.nom_vsl,
            borderColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          ShakeTextField(
            controller: controller.name,
            shakeController: controller.nameShake,
            hintText: AppLocalizations.of(context)!.prenom_vsl,
            borderColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            "${AppLocalizations.of(context)!.sexe_vsl} *",
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
                children: [
                  Text(AppLocalizations.of(context)!.homme,
                      style: Theme.of(context).textTheme.bodyMedium!),
                  Checkbox(
                    value: controller.isMale.value,
                    onChanged: (value) {
                      if (value != null && value) {
                        controller.isMale.value = true;
                      }
                    },
                  ),
                  Spacer(),
                  Text(AppLocalizations.of(context)!.femme,
                      style: Theme.of(context).textTheme.bodyMedium!),
                  Checkbox(
                    value: !controller.isMale.value,
                    onChanged: (value) {
                      if (value != null && value) {
                        controller.isMale.value = false;
                      }
                    },
                  ),
                ],
              )),
          const SizedBox(height: 20),
          Text(
            "${AppLocalizations.of(context)!.age_vsl} *",
          ),
          Expanded(
            child: ListWheelScrollView(
                perspective: 0.0015,
                onSelectedItemChanged: (value) => controller.age.value = value,
                itemExtent: 50,
                children: [
                  for (int i = 0; i < 100; i++)
                    agePicker(i == controller.age.value, context, i)
                ]),
          )
        ],
      ),
    );
  }

  Widget agePicker(bool isSelect, BuildContext context, int age) {
    return Container(
      width: width,
      decoration: isSelect
          ? BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20))
          : null,
      alignment: Alignment.center,
      child: Text(
        age.toString(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget selectRole(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.team_role_vsl,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.selectedRole.value = AppLocalizations.of(context)!.role_ninja;
          },
          child: 
          listRole(context, 'ninja'),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            controller.selectedRole.value = AppLocalizations.of(context)!.role_gorille;
          },
          child:
          listRole(context, 'gorille'),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            controller.selectedRole.value = AppLocalizations.of(context)!.role_gecko;
          },
          child:
          listRole(context, 'gecko'),
        )
      ],
    );
  }

  Widget listRole(BuildContext context, String role) {
    if (role == 'ninja') {
      return RoleCard(
        title: AppLocalizations.of(context)!.role_ninja,
        description: AppLocalizations.of(context)!.description_ninja,
        point: AppLocalizations.of(context)!.point_ninja,
        image: 'assets/images/mascot_ninja.png',
        isSelected: controller.selectedRole.value ==
            AppLocalizations.of(context)!.role_ninja,
        onTap: () => controller.selectedRole.value =
            AppLocalizations.of(context)!.role_ninja,
      );
    } else if (role == 'gorille') {
      return RoleCard(
        title: AppLocalizations.of(context)!.role_gorille,
        description: AppLocalizations.of(context)!.description_gorille,
        point: AppLocalizations.of(context)!.point_gorille,
        image: 'assets/images/mascot_gorille.png',
        isSelected: controller.selectedRole.value ==
            AppLocalizations.of(context)!.role_gorille,
        onTap: () => controller.selectedRole.value =
            AppLocalizations.of(context)!.role_gorille,
      );
    } else {
      return RoleCard(
        title: AppLocalizations.of(context)!.role_gecko,
        description: AppLocalizations.of(context)!.description_gecko,
        point: AppLocalizations.of(context)!.point_gecko,
        image: 'assets/images/mascot_gecko.png',
        isSelected: controller.selectedRole.value ==
            AppLocalizations.of(context)!.role_gecko,
        onTap: () => controller.selectedRole.value =
            AppLocalizations.of(context)!.role_gecko,
      );
    }
  }

  Widget recapInscription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.mon_inscription,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
                text: "${AppLocalizations.of(context)!.nom} : ",
                style: Theme.of(context).textTheme.labelMedium,
                children: [
                  TextSpan(
                      text: controller.lastname.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
                text: "${AppLocalizations.of(context)!.prenom} : ",
                style: Theme.of(context).textTheme.labelMedium,
                children: [
                  TextSpan(
                      text: controller.name.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
                text: "${AppLocalizations.of(context)!.age_vsl} : ",
                style: Theme.of(context).textTheme.labelMedium,
                children: [
                  TextSpan(
                      text: controller.age.value.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.mon_role_vsl + " : ",
              style: Theme.of(context).textTheme.labelMedium),
        ),
        Obx(
          () {
            if (controller.selectedRole.value ==
                AppLocalizations.of(context)!.role_ninja) {
              return listRole(context, 'ninja');
            } else if (controller.selectedRole.value ==
                AppLocalizations.of(context)!.role_gorille) {
              return listRole(context, 'gorille');
            } else {
              return listRole(context, 'gecko');
            }
          },
        ),
      ],
    );
  }

  Widget recap(BuildContext context) {
    return ListView(
      children: [
        recapCreationGuilde(context),
        SizedBox(
          height: 10,
        ),
        recapInscription(context),
      ],
    );
  }

  // Widget equipeCree(BuildContext context) {
  //   //create the last widget where we congratulate the user for creating a team
  //   // should display the word "Félicitation" and a button to go back to the home page

  // }

  Widget recapCreationGuilde(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context)!.mon_equipe_vsl,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
                text: "${AppLocalizations.of(context)!.team_name_vsl} : ",
                style: Theme.of(context).textTheme.labelMedium,
                children: [
                  TextSpan(
                      text: controller.guildName.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.team_photo_vsl,
              style: Theme.of(context).textTheme.labelMedium),
        ),
        if (controller.image_guild.value != null)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                controller.image_guild.value!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        //Ma salle
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.salle_qualification,
              style: Theme.of(context).textTheme.labelMedium),
        ),
        if (controller.climbingLocationSelected.value != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClimbingLocationMinimalistWidget(
              context,
              controller.climbingLocationSelected.value!,
              onPressed: () {},
              isSelected: true,
            ),
          ),
      ],
    );
  }

  Widget bottomBar(BuildContext context) {
    return BottomAppBar(
      height: 120,
      color: ColorsConstantDarkTheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonWidget(
                onPressed: () {
                  controller.changeState(false);
                },
                child: Text(AppLocalizations.of(context)!.precedent, style : Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.surface)),
              ),
              ButtonWidget(
                onPressed: () {
                  if (controller.checkTextfields()) {
                    controller.changeState(true);
                  }
                },
                child: Text(AppLocalizations.of(context)!.suivant, style : Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.surface)),
              ),
            ],
          ),
          Obx(
            () => FlutterStepIndicator(
                height: 20,
                positiveColor: Theme.of(context).colorScheme.primary,
                progressColor: Theme.of(context).colorScheme.primary,
                disableAutoScroll: false,
                list: [1, 2, 3, 4],
                onChange: (i) {},
                page: controller.index.value - 1),
          )
        ],
      ),
    );
  }
}
