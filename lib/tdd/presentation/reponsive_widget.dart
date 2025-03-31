import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ResponsiveWidget extends StatefulWidget {
  final bool isMobile;
  final bool isWeb;
  final bool isTab;
  final double? maxWidth;
  final double? maxHeight;
  final Widget child;

  const ResponsiveWidget({
    super.key,
    this.isMobile = true,
    this.isWeb = true,
    this.isTab = true,
    this.maxWidth,
    this.maxHeight,
    required this.child,
  });

  @override
  State<ResponsiveWidget> createState() => _VisibleWidgetState();
}
extension ScreenSizer on num{
 double get  w => (this*MediaQuery.of(ScreenSize.navigatorKey.currentContext!).size.width)/100;
 double get  h => (this*MediaQuery.of(ScreenSize.navigatorKey.currentContext!).size.height)/100;
 double get sp => (this*MediaQuery.of(ScreenSize.navigatorKey.currentContext!).size.aspectRatio)/100;
}

class ScreenSize {
  static double mobilemaxWidget = 600;
  double tabletmaxWidget = 1024;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static bool isWeb =
      kIsWasm
          ? MediaQuery.of(navigatorKey.currentContext!).size.width >= mobilemaxWidget
          : false;
  static bool isMobile =
      MediaQuery.of(navigatorKey.currentContext!).size.width < mobilemaxWidget;
  static bool isTablet =
      MediaQuery.of(navigatorKey.currentContext!).size.width >= mobilemaxWidget &&
      MediaQuery.of(navigatorKey.currentContext!).size.width < mobilemaxWidget;
      static Orientation orientation =  MediaQuery.of(navigatorKey.currentContext!).orientation;
}

class _VisibleWidgetState extends State<ResponsiveWidget> {
  double mobilemaxWidget = 600;
  double tabletmaxWidget = 1024;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Determine visibility
    if ((ScreenSize.isMobile && !widget.isMobile) ||
        (ScreenSize.isTablet && !widget.isTab) ||
        (ScreenSize.isWeb && !widget.isWeb)) {
      return SizedBox.shrink(); // Hide the widget
    }

    if (ScreenSize.isTablet) {
      screenWidth = mobilemaxWidget;
    } else if (ScreenSize.isMobile) {
      screenWidth = mobilemaxWidget;
    }
    // Apply max width and height constraints
    double appliedWidth =
        widget.maxWidth != null
            ? (screenWidth > widget.maxWidth! ? widget.maxWidth! : screenWidth)
            : screenWidth;

    double appliedHeight =
        widget.maxHeight != null
            ? (screenHeight > widget.maxHeight!
                ? widget.maxHeight!
                : screenHeight)
            : screenHeight;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: appliedWidth,
          maxHeight: appliedHeight,
        ),
        child: widget.child,
      ),
    );
  }
}
