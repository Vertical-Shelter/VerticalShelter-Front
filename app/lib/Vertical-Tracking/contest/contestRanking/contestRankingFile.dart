import 'package:app/Vertical-Tracking/contest/contestRanking/ContestRankingController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/contest/userContestCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ContestRankingFile extends GetWidget<ContestRankingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.classement),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Obx(() => Column(children: [
              navBar(context),
              controller.loading.value == false
                  ? Flexible(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        padding: EdgeInsets.all(20.0),
                        shrinkWrap: true,
                        itemCount: controller.userContestResp.length,
                        itemBuilder: (BuildContext context, int index) {
                          return UserContestCard(
                            userContestResp: controller.userContestResp[index],
                            index: index,
                          );
                        },
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ])));
  }

  Widget navBar(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.transparent,
      selectedIndex: controller.index.value,
      indicatorColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      height: 50,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: [
        NavigationDestination(
            icon: Text(AppLocalizations.of(context)!.global,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
            selectedIcon: Text(AppLocalizations.of(context)!.global,
                style: Theme.of(context).textTheme.bodyMedium!),
            label: AppLocalizations.of(context)!.global),
        NavigationDestination(
            icon: Text(AppLocalizations.of(context)!.homme,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
            selectedIcon: Text(AppLocalizations.of(context)!.homme,
                style: Theme.of(context).textTheme.bodyMedium!),
            label: AppLocalizations.of(context)!.homme),
        NavigationDestination(
            icon: Text(AppLocalizations.of(context)!.femme,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
            selectedIcon: Text(AppLocalizations.of(context)!.femme,
                style: Theme.of(context).textTheme.bodyMedium!),
            label: AppLocalizations.of(context)!.femme),
      ],
      onDestinationSelected: (value) => controller.ChangeColumn(value),
    );
  }
}
