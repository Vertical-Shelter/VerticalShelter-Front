import 'package:app/Vertical-Tracking/VSL/descriptionVSL/descriptionVSLController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/vsl/climbingLocationCard.dart';
import 'package:app/widgets/vsl/roleCard.dart';

class DescriptionVslScreen extends GetWidget<DescriptionVslController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          titleTextStyle: Theme.of(context).textTheme.labelLarge,
          title: Text(AppLocalizations.of(context)!.reglement),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: ListView(children: [
          SizedBox(
            height: 40,
          ),
          InkWell(
            child: Row(children: [
              Text(
                "Qu’est ce que c’est ?",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Spacer(),
              Icon(Icons.arrow_drop_down)
            ]),
            onTap: () {
              controller.quEstCeQueCest.value =
                  !controller.quEstCeQueCest.value;
            },
          ),
          quequeCest(context),
          SizedBox(
            height: 40,
          ),
          InkWell(
            child: Row(children: [
              Text(
                "Comment ça marche ?",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Spacer(),
              Icon(Icons.arrow_drop_down)
            ]),
            onTap: () {
              controller.commentCaMarche.value =
                  !controller.commentCaMarche.value;
            },
          ),
          commentCaMarche(context),
          SizedBox(
            height: 40,
          ),
          InkWell(
            child: Row(children: [
              Text(
                "Crée ton équipe",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Spacer(),
              Icon(Icons.arrow_drop_down)
            ]),
            onTap: () {
              controller.equipe.value = !controller.equipe.value;
            },
          ),
          equipe(context),
          SizedBox(
            height: 40,
          ),
          InkWell(
            child: Row(children: [
              Text(
                "Choisit ta salle",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Spacer(),
              Icon(Icons.arrow_drop_down)
            ]),
            onTap: () {
              controller.salle.value = !controller.salle.value;
            },
          ),
          choisitTaSalle(context),
          SizedBox(
            height: 40,
          ),
          InkWell(
            child: Row(children: [
              Text(
                "Rentre tes blocs",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Spacer(),
              Icon(Icons.arrow_drop_down)
            ]),
            onTap: () {
              controller.bloc.value = !controller.bloc.value;
            },
          ),
          rentreTesBlocs(context),
          SizedBox(
            height: 40,
          ),
          ButtonWidget(
            onPressed: controller.preRegister,
            child: Text(AppLocalizations.of(context)!.pre_inscription,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.surface)),
          ),
        ]));
  }

  Widget commentCaMarche(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.commentCaMarche.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Chaque qualification se déroulera sur les ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  children: [
                    TextSpan(
                        text:
                            "ouvertures régulière de ta salle pendant 4 mois !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Ton but : ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                        text:
                            "Rentrer le plus de blocs possible sur l’application pour gagner un max de points !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Attention, pour ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  children: [
                    TextSpan(
                        text: "éviter la triche ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    TextSpan(
                        text:
                            "nous demanderons de temps à autres une validation vidéo !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
          ],
        )));
  }

  Widget quequeCest(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.quEstCeQueCest.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text:
                      "Chaque salle organisera ses propres qualifications pour ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  children: [
                    TextSpan(
                        text: "élire la meilleure équipe ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    TextSpan(
                        text: "qui accédera à la ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                    TextSpan(
                        text: "grande finale le 5 juillet 2025 ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    TextSpan(
                        text: "à Paris !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Ouvert à tous les niveaux : ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                        text:
                            "débutants, intermédiaires ou experts, tout le monde peut participer !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Tirage au sort quotidien ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                        text: "avec des lots à gagner grâce à nos partenaires.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Cash prize de ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  children: [
                    TextSpan(
                        text: "10 000 €",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "T-shirt exclusif offert ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                        text: "pour toute inscription avant le 18 janvier !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
                text: TextSpan(
              text: "Tarif d’inscription : 49 €",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ))
          ],
        )));
  }

  Widget equipe(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.equipe.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Formez une équipe ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  children: [
                    TextSpan(
                        text: "mixte de 3 personnes ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    TextSpan(
                        text:
                            "et choisissez, chacun, le personnage qui correspond le mieux à ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                    TextSpan(
                        text: "votre style de grimpe et vos compétences ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RoleCard(
              title: AppLocalizations.of(context)!.role_ninja,
              description: AppLocalizations.of(context)!.description_ninja,
              point: AppLocalizations.of(context)!.point_ninja,
              image: 'assets/images/mascot_ninja.png',
              isSelected: false,
            ),
            SizedBox(
              height: 10,
            ),
            RoleCard(
              title: AppLocalizations.of(context)!.role_gorille,
              description: AppLocalizations.of(context)!.description_gorille,
              point: AppLocalizations.of(context)!.point_gorille,
              image: 'assets/images/mascot_gorille.png',
              isSelected: false,
            ),
            SizedBox(
              height: 10,
            ),
            RoleCard(
              title: AppLocalizations.of(context)!.role_gecko,
              description: AppLocalizations.of(context)!.description_gecko,
              point: AppLocalizations.of(context)!.point_gecko,
              image: 'assets/images/mascot_gecko.png',
              isSelected: false,
            ),
          ],
        )));
  }

  Widget choisitTaSalle(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.salle.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Choisis ta salle avec soin, car ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                        text:
                            "tu ne pourras pas la changer une fois inscrit ! ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Important : ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                        text:
                            "Seuls les blocs validés dans cette salle compteront pour la VSL !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 70,
                width: double.infinity,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                    itemBuilder: (context, index) => ClimbingLocationCard(
                          isActive: true,
                          climbingLocationResp:
                              controller.vsl.listClimbingLocation[index],
                          onTap: () => null,
                        ),
                    itemCount: controller.vsl.listClimbingLocation.length))
          ],
        )));
  }

  Widget rentreTesBlocs(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.bloc.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Rentre le ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  children: [
                    TextSpan(
                        text: "plus de blocs possible ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    TextSpan(
                        text: "sur l’application pour ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                    TextSpan(
                        text: "gagner un max de points !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Voici les règles de scoring : ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Gagne 2 fois plus de points",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                        text:
                            " en rentrant des blocs correspondant à ton personnage !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Gagne 2 fois moins de points ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                        text:
                            "en rentrant des blocs ne correspondant pas à ton personnage !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: "Et ceux, ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  children: [
                    TextSpan(
                        text:
                            "pendant toute la durée de la compétition, soit 4 mois !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  ]),
            ),
          ],
        )));
  }
}
