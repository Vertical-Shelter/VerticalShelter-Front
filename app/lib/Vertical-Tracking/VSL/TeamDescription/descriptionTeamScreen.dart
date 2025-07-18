import 'package:app/Vertical-Tracking/VSL/TeamDescription/decriptionTeamController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/VSL/UserVSLResp.dart';
import 'package:app/utils/VSLController.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class DescriptionTeamscreen extends GetWidget<DescriptionTeamcontroller> {
  @override
  Widget build(BuildContext context) {
    Vslcontroller vsl = Get.find<Vslcontroller>();
    //return QRCodeScannerPage();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Mon Équipe'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(vsl.myGuild!
                                .image_url!), // Replace with network image if necessary
                          ),
                          const SizedBox(width: 12),
                          Text(
                            vsl.myGuild!.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Block Out',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const Text(
                        'Rank : 2',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Member Details
            vsl.myGuild!.slabmaster != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Personne n'as le rôle de Gecko",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                      ),
                    ),
                  )
                : memberDetails(context, vsl.myGuild!.slabmaster,
                    AppLocalizations.of(context)!.role_gecko),

            vsl.myGuild!.hulk == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Personne n'as le rôle de Gorille",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                      ),
                    ),
                  )
                : memberDetails(context, vsl.myGuild!.hulk!,
                    AppLocalizations.of(context)!.role_gorille),

            vsl.myGuild!.ninja == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Personne n'as le rôle de Ninja",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                      ),
                    ),
                  )
                : memberDetails(context, vsl.myGuild!.ninja!,
                    AppLocalizations.of(context)!.role_ninja),

            Text(
              'Points d\'équipe : 94121',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget memberDetails(BuildContext context, UserVSLResp? user, String role) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                  'assets/images/user_avatar.png'), // Replace with network image
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user!.username!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 4),
                Text(
                  role,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  'Points',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            //  Spacer(),
          ],
        ),
        const SizedBox(height: 24),
        // // Recent Blocks Section
        // const Text(
        //   'Dernier Blocs Fait',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 16,
        //   ),
        // ),
        //     const SizedBox(height: 16),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: List.generate(
        //         5,
        //         (index) => Container(
        //           width: width * 0.15,
        //           height: width * 0.15,
        //           decoration: BoxDecoration(
        //             color: Theme.of(context).colorScheme.surfaceVariant,
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //           child: const Center(
        //             child: Icon(Icons.image, color: Colors.grey),
        //           ),
        //         ),
        //       ),
        //     ),
      ],
    );
  }
}
