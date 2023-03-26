// To parse this JSON data, do
//
//     final getEventResponse = getEventResponseFromJson(jsonString);

import 'dart:convert';

List<GetEventResponse> getEventResponseFromJson(String str) => List<GetEventResponse>.from(json.decode(str).map((x) => GetEventResponse.fromJson(x)));

String getEventResponseToJson(List<GetEventResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetEventResponse {
    GetEventResponse({
        this.id,
        this.name,
        this.description,
        this.picture,
        this.startDate,
        this.endDate,
        this.ticket,
        this.address,
    });

    final int? id;
    final String? name;
    final String? description;
    final String? picture;
    final DateTime? startDate;
    final DateTime? endDate;
    final Ticket? ticket;
    final String? address;

    factory GetEventResponse.fromJson(Map<String, dynamic> json) => GetEventResponse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        picture: json["picture"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        ticket: json["ticket"] == null ? null : Ticket.fromJson(json["ticket"]),
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "picture": picture,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "ticket": ticket?.toJson(),
        "address": address,
    };
}

class Ticket {
    Ticket({
        this.id,
        this.ticketType,
        this.ticketPrice,
    });

    final int? id;
    final String? ticketType;
    final String? ticketPrice;

    factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        ticketType: json["ticket_type"],
        ticketPrice: json["ticket_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ticket_type": ticketType,
        "ticket_price": ticketPrice,
    };
}
