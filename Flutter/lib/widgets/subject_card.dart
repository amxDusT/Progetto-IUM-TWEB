import 'package:flutter/material.dart';
import 'package:flutter_progetto/models/corso.dart';
import 'package:flutter_progetto/pages/corso_page.dart';
import 'package:flutter_progetto/utils/global_variables.dart';
import 'package:get/get.dart';

class SubjectCard extends StatelessWidget {
  final Corso corso;
  const SubjectCard({super.key, required this.corso});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'HeroCorso${corso.nome}',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          title: Text(
            corso.nome,
          ),
          isThreeLine: true,
          subtitle: Text(
            corso.descrizione,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                //margin: const EdgeInsets.only(left: 8),
                //color: Colors.red,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: getColore(),
                ),
                height: 20,
                width: 60,
                child: Text(
                  corso.docentiNum > 0 ? 'available'.tr : 'unavailable'.tr,
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
              ),
            ],
          ),
          onTap: () => Get.to(() => CorsoPage(corso: corso),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 400)),
        ),
      ),
    );
  }

  Color getColore() {
    if (corso.docentiNum <= 0) {
      return disponibilitaOff;
    } else if (corso.docentiNum <= maxLimitDisponibilita) {
      return disponibilitaLow;
    }
    return disponibilitaOn;
  }
}
