// To parse this JSON data, do
//
//     final genericTemperature = genericTemperatureFromJson(jsonString);

import 'dart:convert';

GenericTemperature genericTemperatureFromJson(String str) => GenericTemperature.fromJson(json.decode(str));

String genericTemperatureToJson(GenericTemperature data) => json.encode(data.toJson());

class GenericTemperature {
    bool success;
    int code;
    Temperature data;
    List<String> messages;

    GenericTemperature({
        required this.success,
        required this.code,
        required this.data,
        required this.messages,
    });

    factory GenericTemperature.fromJson(Map<String, dynamic> json) => GenericTemperature(
        success: json["success"],
        code: json["code"],
        data: Temperature.fromJson(json["data"]),
        messages: List<String>.from(json["messages"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "data": data.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x)),
    };
}

class Temperature {
    String id;
    String dogId;
    double temp;
    int createdTime;

    Temperature({
        required this.id,
        required this.dogId,
        required this.temp,
        required this.createdTime,
    });

    factory Temperature.fromJson(Map<String, dynamic> json) => Temperature(
        id: json["id"],
        dogId: json["dog_id"],
        temp: json["temp"]?.toDouble(),
        createdTime: json["created_time"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "dog_id": dogId,
        "temp": temp,
        "created_time": createdTime,
    };
}