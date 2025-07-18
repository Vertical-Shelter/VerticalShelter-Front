import 'dart:convert';

import 'package:app/Vertical-Tracking/Gyms/boulder/boulderController.dart';
import 'package:app/core/app_export.dart';

class TabBarWidget extends StatefulWidget {
  List<dynamic> tabNames = [];
  void Function(String index) onTap;
  String? index;
  TabBarWidget({required this.tabNames, required this.onTap, this.index});

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      List tabNames = widget.tabNames.map((e) => e['name']!).toList();
      selectedIndex = tabNames.indexOf(widget.index!);
    }
    _tabController = TabController(
        initialIndex: selectedIndex,
        length: widget.tabNames.length,
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // BoulderController gymController = Get.find<BoulderController>();
    return TabBar(
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      controller: _tabController,
      indicatorColor: Theme.of(context).colorScheme.primary,
      labelColor: Theme.of(context).colorScheme.onSurface,
      dividerColor: Theme.of(context).colorScheme.primary,
      unselectedLabelColor: Colors.grey,
      tabs: List.generate(widget.tabNames.length, (index) {
        return Tab(
            child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 8.0,
                top: 5.0,
              ), //const EdgeInsets.all(8.0),
              child: Text(widget.tabNames[index]['name']!),
            ),
            Visibility(
                visible: widget.tabNames[index]['status'] == "active",
                child: const Positioned(
                    top: 0,
                    left: 12,
                    child: Text(
                      "En cours",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    )))
          ],
        ));
      }),
      onTap: (index) {
        widget.onTap(widget.tabNames[index]['name']!);
      },
    );
  }
}
