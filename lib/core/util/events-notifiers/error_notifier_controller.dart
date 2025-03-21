import 'package:tdd_arc/core/util/store/store.dart';
import 'package:velocity_x/velocity_x.dart';

class ErrorNotifierMutation extends VxMutation<ProjectStore>  {
  late NotificationData _data,data;
  ErrorNotifierMutation(this._data);
  @override
  perform() async {
    data = _data;
  }
}
enum NotificationType{
 alertDialog,
  toast_succses,
  toast_warning,
  toast_error,
  bottemSheet
}
class NotificationData{
  final NotificationType type;
  final String title;
  final String messege;

  NotificationData(this.type, this.title, this.messege);
}