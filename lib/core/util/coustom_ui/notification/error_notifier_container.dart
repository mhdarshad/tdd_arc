import 'package:flutter/material.dart';
import 'package:tdd_arc/core/util/coustom_ui/ctoast.dart' show CToast;
import 'package:velocity_x/velocity_x.dart';
import 'error_notifier_controller.dart';

class CustomNotifier extends StatelessWidget {
  const CustomNotifier({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VxNotifier(
      mutations: {
        // Listening to the ErrorNotifierMutation
        ErrorNotifierMutation: (ctx, store, {status}) {
          final errorMutation = store as ErrorNotifierMutation;

          switch (errorMutation.data.type) {
            case NotificationType.alertDialog:
              // Show a dialog when an error occurs
              _showAlertDialog(ctx, errorMutation.data.messege);
              break;

            case NotificationType.toastSuccses:
              // Display success toast message
              CToast.toast(ctx, msg: errorMutation.data.messege).success;
              break;

            case NotificationType.toastWarning:
              // Display warning toast message
              CToast.toast(ctx, msg: errorMutation.data.messege).warning;
              break;

            case NotificationType.errortoast:
              // Display error toast message
              CToast.toast(ctx, msg: errorMutation.data.messege).error;
              break;

            case NotificationType.bottemSheet:
              // Display bottom sheet for additional information or actions
              _showBottomSheet(ctx, errorMutation.data.messege);
              break;
          }
        }
      },
      child: child,
    );
  }

  // Function to show an alert dialog
  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Notification"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a bottom sheet
  void _showBottomSheet(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }
}
