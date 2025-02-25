
import 'package:equatable/equatable.dart';

abstract class Model  extends Equatable{
  bool? status;
  String? msg;
  dynamic data;
  dynamic flags;

  Model({this.status, this.msg, this.data, this.flags});

  Model.fromJson(Map<String, dynamic> json) ;

  Map<String, dynamic> toJson();

}