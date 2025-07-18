import 'package:app/Vertical-Tracking/VSL/joinTeam/joinTeamController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/climbingLocationMinimalist.dart';
import 'package:app/widgets/roleCard.dart';
import 'package:app/widgets/textFieldShaker/textFieldShakerWidget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class JoinTeamscreen extends GetWidget<JoinTeamcontroller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Obx(
          () => controller.index.value == 1
                ? informationPerso(context)
                : controller.index.value == 2
                    ? selectRole(context)
                    : recap(context),
        ),
        bottomNavigationBar: bottomBar(context));
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: ColorsConstantDarkTheme.background,
        foregroundColor: ColorsConstantDarkTheme.background,
        surfaceTintColor: ColorsConstantDarkTheme.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Obx(() => controller.index.value == 1
            ? Text(
                AppLocalizations.of(context)!.s_inscrire_vsl,
                style: Theme.of(context).textTheme.labelLarge,
              )
            : controller.index.value == 2
                ? Text(
                    AppLocalizations.of(context)!.mon_role_vsl,
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                  : Text(
                      "Recap",
                      style: Theme.of(context).textTheme.labelLarge,
                    )));
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
            borderColor: ColorsConstantDarkTheme.secondary,
          ),
          const SizedBox(height: 20),
          ShakeTextField(
            controller: controller.name,
            shakeController: controller.nameShake,
            hintText: AppLocalizations.of(context)!.prenom_vsl,
            borderColor: ColorsConstantDarkTheme.secondary,
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
              border: Border.all(color: ColorsConstantDarkTheme.secondary),
              color: ColorsConstantDarkTheme.purple,
              borderRadius: BorderRadius.circular(10))
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
          onTap: () => controller.guildSelected.value?.ninja == null?
                    controller.selectedRole.value = AppLocalizations.of(context)!.role_ninja : null,
          child:
          listRole(context, 'ninja'),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => controller.guildSelected.value?.hulk == null?
                    controller.selectedRole.value = AppLocalizations.of(context)!.role_gorille : null,
          child:
          listRole(context, 'gorille'),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => controller.guildSelected.value?.slabmaster == null?
                    controller.selectedRole.value = AppLocalizations.of(context)!.role_gecko : null,
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
          isDisable: controller.guildSelected.value?.ninja != null,
          selectedRole: controller.selectedRole
          );
    } else if (role == 'gorille') {
      return RoleCard(
          title: AppLocalizations.of(context)!.role_gorille,
          description: AppLocalizations.of(context)!.description_gorille,
          point: AppLocalizations.of(context)!.point_gorille,
          image: 'assets/images/mascot_gorille.png',
          isDisable: controller.guildSelected.value?.hulk != null,
          selectedRole: controller.selectedRole
          );
    } else {
      return RoleCard(
          title: AppLocalizations.of(context)!.role_gecko,
          description: AppLocalizations.of(context)!.description_gecko,
          point: AppLocalizations.of(context)!.point_gecko,
          image: 'assets/images/mascot_gecko.png',
          isDisable: controller.guildSelected.value?.slabmaster != null,
          selectedRole: controller.selectedRole
          );
    }
  }

  Widget recapInscription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: ColorsConstantDarkTheme.secondary,
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
                          color: ColorsConstantDarkTheme.secondary,
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
                          color: ColorsConstantDarkTheme.secondary,
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
                          color: ColorsConstantDarkTheme.secondary,
                          fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${AppLocalizations.of(context)!.mon_role_vsl} : ",
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
                      text: controller.guildSelected.value!.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorsConstantDarkTheme.secondary,
                          fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(AppLocalizations.of(context)!.team_photo_vsl,
        //       style: Theme.of(context).textTheme.labelMedium),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.salle_qualification,
              style: Theme.of(context).textTheme.labelMedium),
        ),
        getClimbingLocation(context)
      ],
    );
  }

  Widget getClimbingLocation(BuildContext context){
    return FutureBuilder<ClimbingLocationResp>(
      future: climbingLocation_get(controller.guildSelected.value!.climbingLocation_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Center(child: CircularProgressIndicator(color: ColorsConstantDarkTheme.secondary,)),
          );
        } else{
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 30,
              child: FittedBox(
                child: ClimbingLocationMinimalistWidget(context, snapshot.data!),
              ),
            ),
          );
        }
      }
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
                child: Text(
                  AppLocalizations.of(context)!.precedent,
                ),
              ),
              ButtonWidget(
                onPressed: () {
                  if (controller.checkTextfields()) {
                    controller.changeState(true);
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.suivant,
                ),
              ),
            ],
          ),
          Obx(
            () => FlutterStepIndicator(
                height: 20,
                positiveColor: ColorsConstantDarkTheme.secondary,
                progressColor: ColorsConstantDarkTheme.secondary,
                disableAutoScroll: false,
                list: [1, 2, 3],
                onChange: (i) {},
                page: controller.index.value - 1),
          )
        ],
      ),
    );
  }
}
