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

class _VisibleWidgetState extends State<ResponsiveWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double mobilemaxWidget = 600;
    double tabletmaxWidget = 1024;
    bool isMobile = screenWidth < mobilemaxWidget;
    bool isTablet =
        screenWidth >= mobilemaxWidget && screenWidth < mobilemaxWidget;
    bool isWeb = screenWidth >= mobilemaxWidget;

    // Determine visibility
    if ((isMobile && !widget.isMobile) ||
        (isTablet && !widget.isTab) ||
        (isWeb && !widget.isWeb)) {
      return SizedBox.shrink(); // Hide the widget
    }

    if (isTablet) {
      screenWidth = mobilemaxWidget;
    } else if (isMobile) {
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
