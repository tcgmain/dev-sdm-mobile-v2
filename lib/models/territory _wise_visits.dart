class TerritoryWiseVisits {
  TerritoryWiseVisits(
    {
      this.id,
      this.fromdate,
      this.todate,
      this.table,
    }
  );
  
  
  String? id;
  String? fromdate;
  String? todate;
  List<TTData>? table;
 

  factory TerritoryWiseVisits.fromJson(Map<String, dynamic> json) {
    return TerritoryWiseVisits(
      id: json["id"],
      fromdate: json["fromdate"],
      todate: json["todate"],
      table: (json["table"] as List<dynamic>?)?.map((item) => TTData.fromJson(item as Map<String, dynamic>)).toList(),
     );
  }

   Map<String, dynamic> toJson() => {
    "id": id,
    "fromdate": fromdate,
    "todate": todate,
    "table": table?.map((item) => item.toJson()).toList(),
  };

}

class TTData {
  TTData({
    this.tterritoryname,
    this.temployeename,
    this.tnoofvisit,
  });

  String? tterritoryname;
  String? temployeename;
  String? tnoofvisit;

  factory TTData.fromJson(Map<String, dynamic> json) {
    return TTData(
      tterritoryname: json["tterritoryname"],
      temployeename: json["temployeename"],
      tnoofvisit: json["tnoofvisit"],
    );
  }

  Map<String, dynamic> toJson() => {
    "tterritoryname": tterritoryname,
    "temployeename": temployeename,
    "tnoofvisit": tnoofvisit,
  };
}