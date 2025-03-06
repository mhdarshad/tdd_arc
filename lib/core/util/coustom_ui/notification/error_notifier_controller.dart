import 'package:tdd_arc/core/util/store/store.dart' show ProjectStore;
import 'package:velocity_x/velocity_x.dart';

class ErrorNotifierMutation extends VxMutation<ProjectStore> {
  final NotificationData data;

  ErrorNotifierMutation(this.data);

  @override
  perform() {
    return store?.errorNotification = data; // ✅ Assign new data to a store property
  }
}

enum NotificationType {
  alertDialog,
  toastSuccses,
  toastWarning,
  errortoast,
  bottemSheet
}

class NotificationData {
  final NotificationType type;
  final String title;
  final String message; // Fixed typo: "messege" → "message"

  NotificationData(this.type, this.title, this.message);
}
