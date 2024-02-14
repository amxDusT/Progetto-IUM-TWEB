import 'package:flutter/material.dart';

const disponibilitaOff = Colors.redAccent;
const disponibilitaLow = Color.fromARGB(255, 167, 167, 74);
const disponibilitaOn = Color.fromARGB(255, 76, 175, 80);
const maxLimitDisponibilita = 1;

enum PrenotazioneState {
  active(1),
  done(2),
  deleted(3);

  final int num;
  const PrenotazioneState(this.num);

  int get getNum => num;
}

const prenotazioneState = {
  1: PrenotazioneState.active,
  2: PrenotazioneState.done,
  3: PrenotazioneState.deleted
};



// colori tema