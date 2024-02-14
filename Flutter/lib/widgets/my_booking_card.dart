import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/my_bookings_controller.dart';
import 'package:flutter_progetto/models/prenotazione.dart';
import 'package:flutter_progetto/pages/booking_info_page.dart';
import 'package:flutter_progetto/utils/global_variables.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyBookingCard extends StatelessWidget {
  final Prenotazione prenotazione;
  //corsoNome: corso, orario: orarioNum, effettutato: false

  MyBookingCard({super.key, required this.prenotazione});
  final controller = Get.find<MyBookingsController>();
  DateTime getGiornoDate(int weekday) {
    final now = DateTime.now();
    int daysToAdd = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysToAdd));
  }

  Widget _getTextFromState() {
    if (prenotazione.state == PrenotazioneState.active) {
      return const SizedBox();
    } else if (prenotazione.state == PrenotazioneState.done) {
      return Text(
        'done'.tr,
        style: Get.textTheme.bodySmall!.copyWith(color: Colors.green),
      );
    }
    return Text(
      'cancelled'.tr,
      style: Get.textTheme.bodySmall!.copyWith(
        color: Colors.red,
      ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  Icon _getIconFromState() {
    if (prenotazione.state == PrenotazioneState.active) {
      return const Icon(
        Icons.schedule,
        color: Colors.grey,
      );
    } else if (prenotazione.state == PrenotazioneState.done) {
      return const Icon(
        Icons.done,
        color: Colors.green,
      );
    }
    return const Icon(
      Icons.close,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return prenotazione.state != PrenotazioneState.active
        ? _card()
        : Dismissible(
            key: Key(
                '${prenotazione.corso!.nome}.${prenotazione.giorno}-${prenotazione.orario.toString()}'),
            secondaryBackground: Container(
              color: Colors.green,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: Text('done'.tr),
            ),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: Text('cancel'.tr),
            ),
            confirmDismiss: (direction) async {
              bool response = false;
              // elimina
              if (direction == DismissDirection.startToEnd) {
                await controller.getDeleteDialog((){
                  Get.back();
                  response = true;
                });
                //print(response);
              }
              // effettuata
              else if (direction == DismissDirection.endToStart) {
                await controller.getDoneDialog((){
                  Get.back();
                  response = true;
                });
              }
              return response;
            },
            onDismissed: (direction) {
              if(direction == DismissDirection.startToEnd){
                controller.changePrenotazioneState(
                        prenotazione, PrenotazioneState.deleted);
              }else {
                controller.changePrenotazioneState(
                        prenotazione, PrenotazioneState.done);
              }},
            child: _card(),
          );
  }

  Widget _card() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              prenotazione.corso!.nome,
            ),
            Text(
              '${prenotazione.docente!.nome} ${prenotazione.docente!.cognome}',
              style: Get.textTheme.bodyMedium!.copyWith(color: Get.textTheme.bodySmall!.color),
            ),
          ],
        ),
        isThreeLine: false,
        subtitle: _getTextFromState(),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 40, child:_getIconFromState(),),
            
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(DateFormat('E', Get.locale?.languageCode)
                .format(getGiornoDate(prenotazione.giorno!))
                .toUpperCase()),
            Text(
              prenotazione.orario!.start,
              style: Get.textTheme.bodySmall!,
            ),
          ],
        ),
        onTap: () => Get.to(()=>BookingInfoPage(prenotazione: prenotazione)),
      ),
    );
  }
}
