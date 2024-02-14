import 'package:flutter_progetto/models/corso.dart';
import 'package:flutter_progetto/models/docente.dart';
import 'package:flutter_progetto/models/orario.dart';
import 'package:flutter_progetto/models/response.dart';
import 'package:flutter_progetto/utils/global_variables.dart';

enum Actions { add, get, update;}

class Prenotazione {
  final int? id;
  final Corso? corso;
  final int? giorno;
  final Docente? docente;
  final Orario? orario;
  PrenotazioneState? state;
  final Actions? action;
  Prenotazione({
    this.id,
    this.corso,
    this.docente,
    this.giorno,
    int? orario,
    this.action = Actions.add,
    this.state = PrenotazioneState.active,
  }) : orario = Orario(orario: orario ?? 1);

  Map<String, dynamic> toJson() => {
        'id': id?.toString()?? '',
        'corso': corso?.id.toString() ?? '',
        'docente': docente?.id.toString() ?? '',
        'giorno': giorno?.toString() ?? '',
        'orario': orario?.orario.toString() ?? '',
        'stato': state?.getNum.toString() ?? '',
        'action': action?.name ?? Actions.add.name, 
      };

  factory Prenotazione.fromJson(Map<String, dynamic> json) {
    return Prenotazione(
      id: json['id'],
      corso: Corso.fromJson(json['corso']),
      docente: Docente.fromJson(json['docente']),
      giorno: json['giorno'],
      orario: json['orario'],
      state: prenotazioneState[json['stato']],
    );
  }
}

class PrenotazioneResponse extends Response {
  final List<dynamic> prenotazioni;
  const PrenotazioneResponse(
      {required this.prenotazioni,
      required super.error,
      required super.success});
  factory PrenotazioneResponse.fromJson(Map<String, dynamic> json) {
    return PrenotazioneResponse(
        error: json['error'] ?? '',
        success: json['success'] ?? '',
        prenotazioni: json['prenotazioni']);
  }
}
