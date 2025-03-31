import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tdd_arc/core/util/events-notifiers/error_notifier_container.dart';

class PScaffold<T> extends StatefulWidget {
  final Widget? drawer;

  final BottomNavigationBar? bottomNavigationBar;

  const PScaffold({
    super.key,
    required this.body,
    this.displayLogoHead = false,
    this.appBar,
    this.drawer,
    this.currentPage,
    this.bottomNavigationBar,
  });

  final Widget body;
  final bool displayLogoHead;
  final T? currentPage;
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
      drawer: widget.currentPage!=null? NavigationMixin.buildSideNav(context, widget.currentPage):null,
      bottomNavigationBar:  widget.currentPage!=null?NavigationMixin.buildBottomNav(
        context,
        widget.currentPage,
      ):null,
      // backgroundColor: context.theme.backgroundColor,
      body: CustomNotifier(
        child: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if( widget.currentPage!=null)
              NavigationMixin.buildWebNav(context, widget.currentPage),
              Expanded(child: widget.body),
            ],
          ),
        ),
      ),
    );
  }
}

// Define a generic function type where `T` can be any type (e.g., int, String, Enum)
typedef BuilderParams<T> = Widget Function(BuildContext context, T currentPage);

mixin NavigationMixin {
  static BuilderParams<dynamic> buildWebNav =
      (context, currentPage) => SizedBox.shrink();
  static BuilderParams<dynamic> buildSideNav =
      (context, currentPage) => SizedBox.shrink();
  static BuilderParams<dynamic> buildBottomNav =
      (context, currentPage) => SizedBox.shrink();
// navigations<T>(Function(BuilderParams<T> builder) webNavBuilder,Function(BuilderParams<T> builder) sideNavBuilder,Function(BuilderParams<T> builder) bottomNavBuilder, ){
// webNavBuilder
// }

  static void webNavBuilder<T>(BuilderParams<T> builder) {
    buildWebNav =
        kIsWeb
            ? (context, currentPage) => builder(context, currentPage as T)
            : (context, currentPage) => SizedBox.shrink();
  }

  static void sideNavBuilder<T>(BuilderParams<T> builder) {
    buildSideNav =
        !kIsWeb
            ? (context, currentPage) => builder(context, currentPage as T)
            : (context, currentPage) => SizedBox.shrink();
  }

  static void bottomNavBuilder<T>(BuilderParams<T> builder) {
    buildBottomNav =
        !kIsWeb
            ? (context, currentPage) => builder(context, currentPage as T)
            : (context, currentPage) => SizedBox.shrink();
  }
}
