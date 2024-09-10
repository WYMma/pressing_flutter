
import 'package:laundry/model/LSOrder.dart';

class LSMissionModel {
  final int missionID;
  final String description;
  final int? equipeID;
  final String dateMission;
  final int commandeID;
  final String status;
  late final LSOrder? order;

  LSMissionModel({
    required this.missionID,
    required this.description,
    this.equipeID,
    required this.dateMission,
    required this.commandeID,
    required this.status,
  });

  factory LSMissionModel.fromJson(Map<String, dynamic> json) {
    return LSMissionModel(
      missionID: json['missionID'],
      description: json['description'],
      equipeID: json['equipeID'],
      dateMission: json['date_mission'],
      commandeID: json['commandeID'],
      status: json['status'],
    );
  }

  static List <LSMissionModel> MissionHistory = [];

  void setOrder(LSOrder order) {
    this.order = order;
  }

  Map<String, dynamic> toJson() {
    return {
      'missionID': missionID,
      'description': description,
      'equipeID': equipeID,
      'date_mission': dateMission,
      'commandeID': commandeID,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'LSMissionModel{missionID: $missionID, description: $description, equipeID: $equipeID, dateMission: $dateMission, commandeID: $commandeID, status: $status, order: $order}';
  }
}
