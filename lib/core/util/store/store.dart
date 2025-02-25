
import 'package:velocity_x/velocity_x.dart' show VxState, VxStore;

abstract class ProjectStore extends VxStore{
ProjectStore get stored => (VxState.store as ProjectStore);
T on<T>() => stored as T;
}