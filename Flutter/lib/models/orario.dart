import 'package:flutter_progetto/models/docente.dart';
import 'package:flutter_progetto/models/response.dart';

class OrarioRequest {
  final int docenteId;
  final int giorno;
  OrarioRequest({
    required Docente docente,
    required this.giorno,
  }) : docenteId = docente.id;

  Map<String, dynamic> toJson() => {
        'docente': docenteId.toString(),
        'giorno': giorno.toString(),
      };
}

class OrarioResponse extends Response {
  final List<int> orari;
  const OrarioResponse(
      {required this.orari, required super.error, required super.success});
  factory OrarioResponse.fromJson(Map<String, dynamic> json) {
    return OrarioResponse(
        error: json['error'] ?? '',
        success: json['success'] ?? '',
        orari: json['orari'].cast<int>());
  }
}

class Orario {
  int orario;

  static const orariDisponibili = {
    1: '15-16',
    2: '16-17',
    3: '17-18',
    4: '18-19',
  };

  Orario({required this.orario}) {
    if (orario <= 0 || orario > 4) {
      throw Exception('Cannot select that orario');
    }
  }
  int get toNum => 14 + orario;
  String get start => '${14 + orario}:00';
  @override
  String toString() {
    return orariDisponibili[orario]!;
  }
  @override
  int get hashCode => orario.hashCode;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Orario &&
        other.orario == orario;
  }
}
