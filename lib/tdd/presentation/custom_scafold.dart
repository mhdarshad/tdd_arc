import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tdd_arc/core/util/events-notifiers/error_notifier_container.dart';

class PScaffold extends StatefulWidget {
  final Widget? drawer;

  final BottomNavigationBar? bottomNavigationBar;

  const PScaffold({
    super.key,
    required this.body,
    this.displayLogoHead = false,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
  });

  final Widget body;
  final bool displayLogoHead;
  final PreferredSizeWidget? appBar;
  @override
  State<PScaffold> createState() => _PScafoldState();
}

class _PScafoldState extends State<PScaffold> {
  @override
  Widget build(BuildContext context) {
    // Navigation.bottemNavBuilder((context,currentIndex)=>Container());
    // Navigation.sideNavBuilder((context,currentIndex)=>Container());
    // Navigation.webNavBuilder((context,currentIndex)=>Container());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.appBar,
      drawer: Navigation.buildSideNav(context,0),
      bottomNavigationBar: Navigation.buildBottomNav(context,0),
      // backgroundColor: context.theme.backgroundColor,
      body: CustomNotifier(
        child: CustomNotifier(
          child: SafeArea(
            top: true,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Navigation.buildWebNav(context,0),
                Expanded(child: widget.body)],
            ),
          ),
        ),
      ),
    );
  }
}
 typedef BuilderParams = Widget Function(BuildContext context,int currentIndex,);

class Navigation {
  static BuilderParams buildWebNav = (context, currentIndex) => SizedBox.shrink();
  static BuilderParams buildSideNav = (context, currentIndex) => SizedBox.shrink();
  static BuilderParams buildBottomNav = (context, currentIndex) => SizedBox.shrink();

  static void webNavBuilder(BuilderParams builder) {
    buildWebNav = kIsWeb ? builder : (context, currentIndex) => SizedBox.shrink();
  }

  static void sideNavBuilder(BuilderParams builder) {
    buildSideNav = !kIsWeb ? builder : (context, currentIndex) => SizedBox.shrink();
  }

  static void bottomNavBuilder(BuilderParams builder) {
    buildBottomNav = !kIsWeb ? builder : (context, currentIndex) => SizedBox.shrink();
  }
}
