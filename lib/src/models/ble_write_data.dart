class BleWriteData {
  String? subject;
  String? ssid;
  String? password;
  String? uuid;
  bool? status;

  BleWriteData({this.subject, this.ssid, this.password,this.uuid,this.status});

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'ssid': ssid,
      'password': password,
      'uuid': uuid,
      'status': status
    };
  }
}
