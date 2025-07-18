import 'package:app/Vertical-Tracking/MyStats/stats/myStatsController.dart';
import 'package:app/core/app_export.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class VTMyStatsScreen extends GetWidget<VTMyStatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(children: [
          RowFilter(context),
          SizedBox(height: height * 0.01),
          navBar(context),
          SizedBox(height: height * 0.01),
          Body(controller.index.value)
        ]));
  }

  Widget RowFilter(BuildContext context) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        // Add more decoration..
      ),
      hint: Text(
        controller.menus[0],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      items: controller.menus
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      onChanged: (value) {
        if (value == controller.menus[0]) {
          controller.getStatsAttribute("week");
          return;
        }
        if (value == controller.menus[1]) {
          controller.getStatsAttribute("month");
          return;
        }
        if (value == controller.menus[2]) {
          controller.getStatsAttribute("year");
          return;
        }
      },
      onSaved: (value) {
        // controller. = value.toString();
      },
      buttonStyleData: ButtonStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget Body(int? index) {
    index = index ?? controller.index.value;
    return Obx(() => controller.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : Expanded(
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                    padding: getPadding(top: 0.029 * height, left: 5, right: 5),
                    child: controller.pages[index!]))));
  }

  Widget navBar(BuildContext context) {
    return NavigationBar(
      height: height * 0.05,
      indicatorColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      selectedIndex: controller.index.value,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: [
        NavigationDestination(
            icon: Opacity(
                opacity: 0.5,
                child: Text(AppLocalizations.of(context)!.global,
                    style: Theme.of(context).textTheme.bodyMedium!)),
            selectedIcon: Text(AppLocalizations.of(context)!.global,
                style: Theme.of(context).textTheme.bodyMedium!),
            label: AppLocalizations.of(Get.context!)!.global),
        NavigationDestination(
            icon: Opacity(
                opacity: 0.5,
                child: Text(AppLocalizations.of(context)!.par_salles,
                    style: Theme.of(context).textTheme.bodyMedium!)),
            selectedIcon: Text(AppLocalizations.of(context)!.par_salles,
                style: Theme.of(context).textTheme.bodyMedium!),
            label: AppLocalizations.of(Get.context!)!.salles),
      ],
      onDestinationSelected: (value) => controller.changeNavBar(value),
    );
  }
}
