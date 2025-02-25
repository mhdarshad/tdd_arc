
import 'package:equatable/equatable.dart';

abstract class Model  extends Equatable{

  fromJson(Map<String, dynamic> json) ;

  Map<String, dynamic> toJson();

}