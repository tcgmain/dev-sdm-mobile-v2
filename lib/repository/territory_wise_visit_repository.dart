import 'dart:convert';
import 'dart:async';

import 'package:sdm/models/territory _wise_visits.dart';
import 'package:sdm/networking/api_provider.dart';

class TerritoryWiseVisitRepository {
  final ApiProvider _provider = ApiProvider();
  String? accessToken;
  dynamic inputBody, requestHeaders;

  Future<TerritoryWiseVisits> getTerritoryWiseVisits(
    String id,
    String fromDate,
    String toDate,
  ) async {
    requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  
    Map<String, dynamic> inputBody = {
      "id": "(9722,77,0)",
      "fromdate": fromDate,
      "todate": toDate,
      "table": [
        {
          "tterritoryname": "",
          "temployeename": "",
          "tnoofvisit": "",
        }
      ]
    };

    final response = await _provider.post(
      "/territorywisevisit",
      jsonEncode(inputBody),
      requestHeaders,
    );   

    return TerritoryWiseVisits.fromJson(response);
  
}
}
