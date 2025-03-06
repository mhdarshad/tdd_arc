import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:tdd_arc/core/util/store/store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'error_notifier_controller.dart';

class CustomNotifier extends StatelessWidget {
  const CustomNotifier({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VxNotifier(
      mutations: {
        ErrorNotifierMutation: (ctx, store, {status}) {
          final errorMutation = (store.store as ProjectStore).errorNotification;

          switch (errorMutation.type) {
            case NotificationType.alertDialog:
              _showAlertDialog(ctx, errorMutation.message);
              break;

            case NotificationType.toastSuccses:
              _showFlushbar(ctx, errorMutation.message, Colors.green, Icons.check_circle);
              break;

            case NotificationType.toastWarning:
              _showFlushbar(ctx, errorMutation.message, Colors.orange, Icons.warning);
              break;

            case NotificationType.errortoast:
              _showFlushbar(ctx, errorMutation.message, Colors.red, Icons.error);
              break;

            case NotificationType.bottemSheet:
              _showBottomSheet(ctx, errorMutation.message);
              break;
          }
        }
      },
      child: child,
    );
  }

  void _showFlushbar(BuildContext context, String message, Color color, IconData icon) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(icon, color: Colors.white),
    ).show(context);
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }
}
