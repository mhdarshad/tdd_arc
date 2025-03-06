
import 'package:tdd_arc/core/util/coustom_ui/notification/error_notifier_controller.dart';
import 'package:velocity_x/velocity_x.dart' show VxState, VxStore;

abstract class ProjectStore extends VxStore{
  late NotificationData errorNotification;

  String? token;

static ProjectStore get stored => (VxState.store as ProjectStore);
T  on<T>() => stored as T;
}