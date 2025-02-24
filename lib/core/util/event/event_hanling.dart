import 'package:tdd_arc/core/util/coustom_ui/notification/error_notifier_controller.dart' show ErrorNotifierMutation, NotificationData, NotificationType;
import 'package:tdd_arc/core/util/store/store.dart';
import 'package:velocity_x/velocity_x.dart';

abstract class EventMutations<T> extends VxMutation<ProjectStore> {
  final Future<void> Function(
    ProjectStore store,
    Function({String? message, String? type}) onError,
    Function({required Map<String, dynamic> data, AppState? status}) state,
  ) call;
  AppState state = AppState.initial;
  T? event;

  EventMutations(this.event, {required this.call});

  // Show error toast notification
  void errorToast(String message) {
    next(() => ErrorNotifierMutation(NotificationData(NotificationType.errortoast, "Error:", message)));
  }

  // Show success toast notification
  void successToast(String message) {
    next(() => ErrorNotifierMutation(NotificationData(NotificationType.toastSuccses, "Success:", message)));
  }

  // Show warning toast notification
  void warningToast(String message) {
    next(() => ErrorNotifierMutation(NotificationData(NotificationType.toastWarning, "Warning:", message)));
  }

  // Perform the mutation call and handle success or error
  @override
  perform() async {
    try {
      await call(
        store!,
        // Error handling callback
        ({String? message, String? type}) {
          state = AppState.error;
          return onError(message: message, type: type);
        },
        // Success handling callback
        onSuccess,
      );
    } catch (e, s) {
      // Handle exceptions and show error toast
      onException(e, s);
    }
  }

  // Method to handle errors
  void onError({String? message, String? type});

  // Method to handle success
  void onSuccess({required Map<String, dynamic> data, AppState? status});

  // Handle exceptions that occur during the mutation process
  @override
  onException(dynamic e, StackTrace s) {
    errorToast(e.toString());
  }
}

// Enum to represent the state of the mutation
enum AppState { loading, success, initial, error }
