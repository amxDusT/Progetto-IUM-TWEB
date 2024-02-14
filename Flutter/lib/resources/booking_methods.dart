import 'package:flutter_progetto/models/corso.dart';
import 'package:flutter_progetto/models/docente.dart';
import 'package:flutter_progetto/models/orario.dart';
import 'package:flutter_progetto/models/prenotazione.dart';
import 'package:flutter_progetto/models/response.dart' as prenotazione_response;
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:flutter_progetto/resources/session.dart';
import 'package:flutter_progetto/utils/error_codes.dart';
import 'dart:convert';

import 'package:flutter_progetto/utils/global_variables.dart';

class BookingMethods {
  final String corsoApi = "corso/api";
  final String docenteApi = "docente/api";
  final String orarioApi = "orari/api";
  final String prenotazioneApi = "prenotazione/api";

  Future<List<Corso>> getCorsi() async {
    final response =
        await Session.post(corsoApi, const CorsoRequest().toJson());

    if (response.statusCode != 200) {
      throw ErrorException(errNum: response.statusCode);
    }

    CorsoResponse corsoResponse =
        CorsoResponse.fromJson(json.decode(response.body));
    if (corsoResponse.error.isNotEmpty) {
      throw ErrorException(
          errNum: ErrorCodes.ERROR_SERVER.errNum, message: corsoResponse.error);
    }

    List<Corso> corsi = corsoResponse.corsi
        .map((corsoData) => Corso.fromJson(corsoData))
        .toList();
    return corsi;
  }

  Future<List<Corso>> searchCorso(String text) async {
    final response = await Session.post(
        corsoApi,
        CorsoRequest(
          searchColumn: 'nome',
          orderBy: 'nome',
          orderType: 'asc',
          startAt: text,
        ).toJson());

    if (response.statusCode != 200) {
      throw ErrorException(errNum: response.statusCode);
    }

    CorsoResponse corsoResponse =
        CorsoResponse.fromJson(json.decode(response.body));

    if (corsoResponse.error.isNotEmpty) {
      throw ErrorException(
          errNum: ErrorCodes.ERROR_SERVER.errNum, message: corsoResponse.error);
    }

    List<Corso> corsi = corsoResponse.corsi
        .map((corsoData) => Corso.fromJson(corsoData))
        .toList();
    return corsi;
  }

  Future<List<Docente>> getDocentiByCorso(Corso corso) async {
    final response =
        await Session.post(docenteApi, DocenteRequest(corso: corso).toJson());

    if (response.statusCode != 200) {
      throw ErrorException(errNum: response.statusCode);
    }
    DocenteResponse docenteResponse =
        DocenteResponse.fromJson(json.decode(response.body));

    if (docenteResponse.error.isNotEmpty) {
      throw ErrorException(
          errNum: ErrorCodes.ERROR_SERVER.errNum,
          message: docenteResponse.error);
    }

    List<Docente> docenti = docenteResponse.docenti
        .map((docenteData) => Docente.fromJson(docenteData))
        .toList();
    return docenti;
  }

  Future<List<Orario>> getOrarioByDocente(Docente docente, int weekday) async {
    final response = await Session.post(
        orarioApi, OrarioRequest(docente: docente, giorno: weekday).toJson());
    if (response.statusCode != 200) {
      throw ErrorException(errNum: response.statusCode);
    }
    OrarioResponse orarioResponse =
        OrarioResponse.fromJson(json.decode(response.body));
    if (orarioResponse.error.isNotEmpty) {
      throw ErrorException(
          errNum: ErrorCodes.ERROR_SERVER.errNum,
          message: orarioResponse.error);
    }
    List<Orario> orari = orarioResponse.orari
        .map((orarioData) => Orario(orario: orarioData))
        .toList();
    return orari;
  }

  Future<Prenotazione> setPrenotazione(
      Corso corso, Docente docente, int giorno, Orario orario) async {
    final response = await Session.post(
        prenotazioneApi,
        Prenotazione(
          corso: corso,
          docente: docente,
          giorno: giorno,
          orario: orario.orario,
        ).toJson());

    if (response.statusCode != 200) {
      throw ErrorException(errNum: response.statusCode);
    }
    PrenotazioneResponse prenotazioneResponse =
        PrenotazioneResponse.fromJson(json.decode(response.body));
    if (prenotazioneResponse.error.isNotEmpty) {
      throw ErrorException(
          errNum: ErrorCodes.ERROR_SERVER.errNum,
          message: prenotazioneResponse.error);
    }
    List<Prenotazione> prenotazioni = prenotazioneResponse.prenotazioni
        .map((prenotazioneData) => Prenotazione.fromJson(prenotazioneData))
        .toList();
    return prenotazioni[0];
  }

  Future<List<Prenotazione>> getPrenotazioni() async {
    final response = await Session.post(
        prenotazioneApi, Prenotazione(action: Actions.get).toJson());

    if (response.statusCode != 200) {
      throw ErrorException(errNum: response.statusCode);
    }

    PrenotazioneResponse prenotazioneResponse =
        PrenotazioneResponse.fromJson(json.decode(response.body));
    if (prenotazioneResponse.error.isNotEmpty) {
      throw ErrorException(
          errNum: ErrorCodes.ERROR_SERVER.errNum,
          message: prenotazioneResponse.error);
    }
    List<Prenotazione> prenotazioni = prenotazioneResponse.prenotazioni
        .map((prenotazioneData) => Prenotazione.fromJson(prenotazioneData))
        .toList();
    return prenotazioni;
  }

  void updatePrenotazione(
      Prenotazione prenotazione, PrenotazioneState state) async {
    if (prenotazione.id == null) {
      throw Exception("ID cannot be null");
    }
    Prenotazione p =
        Prenotazione(id: prenotazione.id, state: state, action: Actions.update);
    final response = await Session.post(prenotazioneApi, p.toJson());
    if (response.statusCode != 200) {
      throw ErrorException(errNum: response.statusCode);
    }
    prenotazione_response.Response prenotazioneResponse =
        prenotazione_response.Response.fromJson(json.decode(response.body));
    if (prenotazioneResponse.error.isNotEmpty) {
      throw ErrorException(
          errNum: ErrorCodes.ERROR_SERVER.errNum,
          message: prenotazioneResponse.error);
    }
  }
}
