import 'dart:async';
import 'package:sdm/models/Bdnotification.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/bdnotification_repository.dart';

class BdnotificationBlock {
  late BdnotificationRepository _bdnotificationRepository;
  StreamController? _bdnotification_controller;               

  StreamSink<ResponseList<Bdnotification>> get bdnotificationSink =>
      _bdnotification_controller!.sink as StreamSink<ResponseList<Bdnotification>>;
   StreamSink<ResponseList<Bdnotification>> get bdnotificationStream =>
      _bdnotification_controller!.sink as StreamSink<ResponseList<Bdnotification>>;

  BdnotificationBlock(){
    _bdnotification_controller = StreamController<ResponseList<Bdnotification>>.broadcast();
    _bdnotificationRepository = BdnotificationRepository();
    
  }

  getBdnotification(String yterritory_nummer) async {
    try {
      List<Bdnotification> res = await _bdnotificationRepository.getBdnotification(yterritory_nummer);
      if (_bdnotification_controller?.isClosed ?? true) return;
      bdnotificationSink.add(ResponseList.completed(res));
      print("Retrive Birthday Details Successfully !!");
    } catch (e) {
      if (_bdnotification_controller?.isClosed ?? true) return;
      bdnotificationSink.add(ResponseList.error(e.toString()));
      print("Brithday ERROR");
      print(e);
    }
  }

  Future<void> getOrganizationsForTerritory(String territoryNumber) async{
    
  }

  dispose() {
    _bdnotification_controller?.close();
  }

}
