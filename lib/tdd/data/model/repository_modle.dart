
import 'modle_entities.dart';

class RepositoryModel extends Model{
  @override
  RepositoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['messge'];
    data = json['data'];
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['messge'] = msg;
    data['data'] = this.data;
    return data;
  }
  
  @override
  // TODO: implement props
  List<Object?> get props =>[data];

}