import 'package:app/Vertical-Tracking/VSL/joinTeam/joinTeamController.dart';
import 'package:app/Vertical-Tracking/VSL/joinTeam/joinTeamScreen.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/guildCard.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SelectTeamscreen extends GetWidget<JoinTeamcontroller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Obx(() => controller.filteredList.isEmpty ?
          const Center(
            child: CircularProgressIndicator(),
          )
          :ListView.separated(
            itemCount: controller.filteredList.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) =>
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.ontap(index); 
              },
              child: 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GuildCard(
                    context: context,
                    guild: controller.filteredList[index],
                    climbingLocationMinimalResp: controller.findClimbingLocation(controller.filteredList[index]),
                    onPressed: () => controller.ontap(index),
                    ),
                )
            ), 
          ),
        )
      );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: ColorsConstantDarkTheme.background,
        surfaceTintColor: ColorsConstantDarkTheme.background,
        elevation: 0,
        title: 
        PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.updateSearchQuery(value);
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.recherche_guilde,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list),
                  onSelected: (value) {
                    controller.sortList(criteria: value);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'name',
                      child: Text(AppLocalizations.of(context)!.tri_par_nom),
                    ),
                    PopupMenuItem(
                      value: 'location',
                      child: Text(AppLocalizations.of(context)!.tri_par_location),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
