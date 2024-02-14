import 'package:flutter_progetto/models/response.dart';

class Corso {
  final int id;
  final String nome;
  final String descrizione;
  final int docentiNum;

  const Corso({
    required this.id,
    required this.nome,
    required this.descrizione,
    required this.docentiNum,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'nome': nome, 'descrizione': descrizione};
  @override
  String toString() => nome;
  factory Corso.fromJson(Map<String, dynamic> json) {
    return Corso(
      id: json['id'],
      nome: json['nome'],
      descrizione: json['descrizione'] ?? '',
      docentiNum: json['docentiNum'] ?? 0,
    );
  }
}

class CorsoRequest {
  final String corso;
  final String? orderBy;
  final String? orderType;
  final String? searchColumn;
  final String? startAt;
  final String? endAt;
  const CorsoRequest(
      {this.corso = 'all',
      this.orderBy,
      this.orderType,
      this.searchColumn,
      this.startAt,
      this.endAt});

  Map<String, dynamic> toJson() => {
        'corso': corso,
        'order-by': orderBy ?? '',
        'order-type': orderType?? '',
        'search-column': searchColumn ?? '',
        'start-at': startAt ?? '',
        'end-at': endAt ?? '',
      };
}

class CorsoResponse extends Response {
  final List<dynamic> corsi;
  const CorsoResponse(
      {required this.corsi, required super.error, required super.success});
  factory CorsoResponse.fromJson(Map<String, dynamic> json) {
    return CorsoResponse(
        error: json['error'] ?? '',
        success: json['success'] ?? '',
        corsi: json['corsi']);
  }
}
