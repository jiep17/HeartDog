// To parse this JSON data, do
//
//     final genericPulse = genericPulseFromJson(jsonString);

import 'dart:convert';

GenericPulse genericPulseFromJson(String str) => GenericPulse.fromJson(json.decode(str));

String genericPulseToJson(GenericPulse data) => json.encode(data.toJson());

class GenericPulse {
    bool success;
    int code;
    Pulse data;
    List<String> messages;

    GenericPulse({
        required this.success,
        required this.code,
        required this.data,
        required this.messages,
    });

    factory GenericPulse.fromJson(Map<String, dynamic> json) => GenericPulse(
        success: json["success"],
        code: json["code"],
        data: Pulse.fromJson(json["data"]),
        messages: List<String>.from(json["messages"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "data": data.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x)),
    };
}

class Pulse {
    String id;
    String dogId;
    int avg;
    double beatsPerMinute;
    int createdTime;

    Pulse({
        required this.id,
        required this.dogId,
        required this.avg,
        required this.beatsPerMinute,
        required this.createdTime,
    });

    factory Pulse.fromJson(Map<String, dynamic> json) => Pulse(
        id: json["id"],
        dogId: json["dog_id"],
        avg: json["avg"],
        beatsPerMinute: json["beats_per_minute"]?.toDouble(),
        createdTime: json["created_time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "dog_id": dogId,
        "avg": avg,
        "beats_per_minute": beatsPerMinute,
        "created_time": createdTime,
    };
}