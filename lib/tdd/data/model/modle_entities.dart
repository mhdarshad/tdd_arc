
abstract class ModelEntities  {
  bool? status;
  String? msg;
  dynamic data;
  dynamic flags;

  ModelEntities({this.status, this.msg, this.data, this.flags});

  ModelEntities.fromJson(Map<String, dynamic> json) ;

  Map<String, dynamic> toJson();

}