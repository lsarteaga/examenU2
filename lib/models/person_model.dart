import 'dart:convert';

PersonModel personModelFromJson(String str) =>
    PersonModel.fromJson(json.decode(str));

String personModelToJson(PersonModel data) => json.encode(data.toJson());

class PersonModel {
  PersonModel({
    this.time,
    this.id,
    this.cardId,
    this.name,
    this.surname,
    this.birthDate,
    this.discapacity,
  });

  DateTime time;
  String id;
  String cardId;
  String name;
  String surname;
  String birthDate;
  String discapacity;

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
        time: json["time"],
        id: json["_id"],
        cardId: json["cardId"],
        name: json["name"],
        surname: json["surname"],
        birthDate: json["birthDate"],
        discapacity: json["discapacity"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "_id": id,
        "cardId": cardId,
        "name": name,
        "surname": surname,
        "birthDate": birthDate,
        "discapacity": discapacity,
      };
}
