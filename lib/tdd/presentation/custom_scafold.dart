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
    this.currentPageindex,
    this.bottomNavigationBar,
  });

  final Widget body;
  final bool displayLogoHead;
  final int? currentPageindex;
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
      drawer: NavigationMixin.buildSideNav(context,0),
      bottomNavigationBar: NavigationMixin.buildBottomNav(context,0),
      // backgroundColor: context.theme.backgroundColor,
      body: CustomNotifier(
        child: CustomNotifier(
          child: SafeArea(
            top: true,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavigationMixin.buildWebNav(context,0),
                Expanded(child: widget.body)],
            ),
          ),
        ),
      ),
    );
  }
}

// Define a generic function type where `T` can be any type (e.g., int, String, Enum)
typedef BuilderParams<T> = Widget Function(BuildContext context, T currentPage);

mixin NavigationMixin {
  static BuilderParams<dynamic> buildWebNav = (context, currentPage) => SizedBox.shrink();
  static BuilderParams<dynamic> buildSideNav = (context, currentPage) => SizedBox.shrink();
  static BuilderParams<dynamic> buildBottomNav = (context, currentPage) => SizedBox.shrink();

  static void webNavBuilder<T>(BuilderParams<T> builder) {
    buildWebNav = kIsWeb ? (context, currentPage) => builder(context, currentPage as T) : (context, currentPage) => SizedBox.shrink();
  }

  static void sideNavBuilder<T>(BuilderParams<T> builder) {
    buildSideNav = !kIsWeb ? (context, currentPage) => builder(context, currentPage as T) : (context, currentPage) => SizedBox.shrink();
  }

  static void bottomNavBuilder<T>(BuilderParams<T> builder) {
    buildBottomNav = !kIsWeb ? (context, currentPage) => builder(context, currentPage as T) : (context, currentPage) => SizedBox.shrink();
  }
}
