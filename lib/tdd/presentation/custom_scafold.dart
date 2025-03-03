
import 'package:flutter/material.dart';
import 'package:tdd_arc/core/util/events-notifiers/error_notifier_container.dart';

class PScafold extends StatefulWidget {
  final Widget? drawer;

  final BottomNavigationBar? bottomNavigationBar;

  const PScafold({
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
  State<PScafold> createState() => _PScafoldState();
}

class _PScafoldState extends State<PScafold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: widget.appBar,
        drawer: widget.drawer,
        bottomNavigationBar: widget.bottomNavigationBar,
        // backgroundColor: context.theme.backgroundColor,
        body: CustomNotifier(
            child: CustomNotifier(child: SafeArea(child: widget.body))));
  }
}
