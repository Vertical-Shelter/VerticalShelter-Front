import 'package:app/Vertical-Tracking/contest/ContestList/contestController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/contest/contestCard.dart';
import 'package:app/widgets/profil/profilImage.dart';

class ContestList extends GetWidget<ContestController> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Obx(() => Flexible(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              padding: EdgeInsets.all(20.0),
              shrinkWrap: true,
              itemCount: controller.contestList.length,
              itemBuilder: (BuildContext context, int index) {
                return ContestCard(
                  contestResp: controller.contestList[index],
                );
              },
            ),
          )),
    ]);
  }
}
