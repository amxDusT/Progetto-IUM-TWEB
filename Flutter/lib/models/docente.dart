import 'package:flutter_progetto/models/corso.dart';
import 'package:flutter_progetto/models/response.dart';

class Docente {
  final int id;
  final String nome;
  final String cognome;

  const Docente({required this.id, required this.nome, required this.cognome});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'cognome': cognome
      };
  @override
  String toString() => nome;
  factory Docente.fromJson(Map<String, dynamic> json) {
    return Docente(
        id: json['id'],
        nome: json['nome'],
        cognome: json['cognome']);
  }
}

class DocenteRequest {
  final int corsoId;
  DocenteRequest({
    required Corso corso
  }) : corsoId = corso.id;

  Map<String, dynamic> toJson() => {
        'corso': corsoId.toString(),
      };
}

class DocenteResponse extends Response{
  final List<dynamic> docenti;
  const DocenteResponse(
      {required this.docenti, required super.error, required super.success});
  factory DocenteResponse.fromJson(Map<String, dynamic> json) {
    return DocenteResponse(
        error: json['error'] ?? '',
        success: json['success'] ?? '',
        docenti: json['docenti']);
  }
}
