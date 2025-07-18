// import 'package:app/core/app_export.dart';
// import 'package:app/core/constants/colorConstant.dart';
// import 'package:app/widgets/bottomBar/bottomBarIcons.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// class BottomBar extends StatefulWidget {
//   final List<BottomBarItem> children;

//   final RxInt currentIndex;

//   const BottomBar({
//     required this.currentIndex,
//     required this.children,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _BottomBarState createState() => _BottomBarState();
// }

// class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
//   ScrollController scrollBottomBarController = ScrollController();
//   Duration duration = const Duration(milliseconds: 0);
//   double offset = 4.0;
//   Color barColor = ColorsConstant.neutral_tab;
//   BorderRadiusGeometry borderRadius = BorderRadius.circular(30);
//   late TabController tabController;
//   late List pages;
//   late int currentIndex;

//   void changePage(int index) {
//     setState(() {
//       currentIndex = index;
//       widget.currentIndex.value = index;
//       widget.currentIndex.refresh();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     currentIndex = widget.currentIndex.value;
//     tabController = TabController(
//         length: widget.children.length,
//         vsync: this,
//         animationDuration: Duration.zero,
//         initialIndex: currentIndex);
//     tabController.animation?.addListener(
//       () {
//         final value = tabController.animation!.value.round();
//         if (value != widget.currentIndex.value && mounted) {
//           changePage(value);
//         }
//       },
//     );

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height * 0.0806,
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: Theme.of(context).colorScheme.surface,
//             width: 1,
//           ),
//         ),
//       ),
//       padding: EdgeInsets.all(offset),
//       child: TabBar(
//           isScrollable: true,
//           indicator: BoxDecoration(
//             color: ColorsConstant.neutral_white,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           indicatorWeight: 1,
//           splashBorderRadius: BorderRadius.circular(30),
//           splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
//           indicatorColor: ColorsConstant.neutral_tab,
//           controller: tabController,
//           tabs: [
//             for (int i = 0; i < widget.children.length; i++)
//               InkWell(
//                 onTap: () {
//                   tabController.animateTo(i);
//                   changePage(i);
//                 },
//                 // child: currentIndex == i
//                 //     ? widget.children[i].activeIcon()
//                 //     : widget.children[i].inActiveIcon(),
//               ),
//           ]),
//     );
//   }
// }
