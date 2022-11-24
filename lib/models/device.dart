class Device {
  late String uuid;
  late String authToken;


   Device({required this.uuid, required this.authToken});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(uuid: json["uuid"], authToken: json['auth_token']);
  }
}
