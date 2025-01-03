import 'dart:async';
import 'package:sdm/models/territory _wise_visits.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/territory_wise_visit_repository.dart';

class TerritoryWiseVisitBlock {
  late TerritoryWiseVisitRepository _territoryWiseVisitRepository;
  StreamController<ResponseList<TerritoryWiseVisits>>? _territoryWiseVisitController;

  // Sink to add data into the stream
  StreamSink<ResponseList<TerritoryWiseVisits>> get territoryWiseVisitSink =>
      _territoryWiseVisitController!.sink;

  // Stream to listen to data
  Stream<ResponseList<TerritoryWiseVisits>> get territoryWiseVisitStream =>
      _territoryWiseVisitController!.stream;

  TerritoryWiseVisitBlock() {
    _territoryWiseVisitController =
        StreamController<ResponseList<TerritoryWiseVisits>>.broadcast();  
    _territoryWiseVisitRepository = TerritoryWiseVisitRepository();
  }

  getTerritoryWiseVisits(String id, String fromDate, String toDate) async {
    territoryWiseVisitSink.add(ResponseList.loading('Loading Territory Wise Visits'));
    try {
      TerritoryWiseVisits res = await _territoryWiseVisitRepository.getTerritoryWiseVisits(id, fromDate, toDate);
      if (!_territoryWiseVisitController!.isClosed) {
        territoryWiseVisitSink.add(ResponseList.completed([res]));
      }
      print("GET TERRITORY WISE VISITS SUCCESS");
    } catch (e) {
      if (!_territoryWiseVisitController!.isClosed) {
        territoryWiseVisitSink.add(ResponseList.error(e.toString()));
      }
      print("GET TERRITORY WISE VISITS ERROR");
      print(e);
    }
  }

  dispose() {
    _territoryWiseVisitController?.close();
  }
}
