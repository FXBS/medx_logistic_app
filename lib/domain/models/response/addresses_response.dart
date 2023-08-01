
class AddressesResponse {
    
  final bool resp;
  final String msg;
  final List<ListAddress> listAddresses;

  AddressesResponse({
    required this.resp,
    required this.msg,
    required this.listAddresses,
  });

  factory AddressesResponse.fromJson(Map<String, dynamic> json) => AddressesResponse(
    resp: json["resp"],
    msg: json["msg"],
    listAddresses: json["listAddresses"] != null ? List<ListAddress>.from(json["listAddresses"].map((x) => ListAddress.fromJson(x))) : [],
  );

  // factory AddressesResponse.fromJson(Map<String, dynamic> json) => AddressesResponse(
  //   resp: json["resp"],
  //   msg: json["msg"],
  //   listAddresses: (json["listAddresses"] as List<dynamic>)
  //       .map((item) => ListAddress.fromJson(item))
  //       .toList(),
  // );

}

class ListAddress {
    
  final int id;
  final String street;
  final String reference;
  final String latitude;
  final String longitude;

  // final double  latitude;
  // final double  longitude;

  ListAddress({
    required this.id,
    required this.street,
    required this.reference,
    required this.latitude,
    required this.longitude
  });

//   factory ListAddress.fromJson(Map<String, dynamic> json) => ListAddress(
//     id: json["id"] ?? 0,
//     street: json["street"],
//     reference: json["reference"],
//     latitude: json["Latitude"],
//     longitude: json["longitude"]
//   );
// }
  factory ListAddress.fromJson(Map<String, dynamic> json) {
    return ListAddress(
      id: json['id'] ?? 0,
      street: json['street'] ?? '',
      reference: json['reference'] ?? '',
      latitude: json['Latitude'] ?? '',
      longitude: json['Longitude'] ?? '',
    );
  }
}