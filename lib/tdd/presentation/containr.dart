import 'package:flutter/material.dart' ;
import 'package:tdd_arc/core/util/store/store.dart';
import 'package:velocity_x/velocity_x.dart';

typedef VelocityStatus = VxStatus;
abstract class BaseContainer extends StatelessWidget {
  const BaseContainer({
    super.key, 
    required this.builder, 
    required this.mutations,
  });
  final Set<Type> mutations;  // Allow passing dynamic mutations

  final Widget Function(
      BuildContext context, ProjectStore store, VelocityStatus state) builder;

  // Abstract method to be implemented by subclasses to handle different states
 // Abstract method to be implemented by subclasses to handle different mutations' states
  void onMutation(
      BuildContext context, ProjectStore store, dynamic mutation, VelocityStatus status);

  @override
  Widget build(BuildContext context) {
    return VxConsumer<ProjectStore>(
      notifications: Map.fromEntries(
        mutations.map((mutation) {
          return MapEntry(mutation.runtimeType, (ctx, store, {status}) {
            onMutation(ctx, store as ProjectStore, mutation, status!); // Dynamic mutation handling
          });
        }),
      ),
      mutations: mutations, // Use the dynamic mutations set
      builder: (context, store, state) {
        // Handling different states in the abstract class
        return builder(context, store, state!);
      },
    );
  }
}