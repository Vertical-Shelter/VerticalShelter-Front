import 'package:app/Vertical-Setting/contest/contestController.dart';
import 'package:app/core/app_export.dart';

class ContestManagementScreen extends GetWidget<ContestManagementController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.contest),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.vous_pourrez_creer_vos_contest_ici),
      ),
    );
  }
}
