import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tdd_arc/core/util/events-notifiers/error_notifier_container.dart';
import 'package:tdd_arc/tdd/presentation/reponsive_widget.dart';

class PScaffold<T> extends StatefulWidget {
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
      drawer: !ScreenSize.isWeb&&  widget.drawer!=null? widget.drawer:null,
      bottomNavigationBar:  ScreenSize.isMobile?widget.bottomNavigationBar:null,
      // backgroundColor: context.theme.backgroundColor,
      body: CustomNotifier(
        child: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if( ScreenSize.isWeb&&  widget.drawer!=null)
              widget.drawer!,
              Expanded(child: widget.body),
            ],
          ),
        ),
      ),
    );
  }
}
