import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:visits_prod/brains/data_layer/firebase_repo.dart';

class CardsBrain extends ChangeNotifier {
  List<Card> myCards = [];

  Future<void> createCard({
    required File file,
    required List<Map> defFields,
    required List<Map> customFields,
    required String templateId,
  }) async {
    await FirebaseRepo.createCard(
      file: file,
      defFields: defFields,
      customFields: customFields,
      templateId: templateId,
    );
  }

  void getMyCards() async {
    myCards = await FirebaseRepo.getAllMyCards();
    notifyListeners();
    print(myCards);
  }
}

class Card {
  final List<Map> defFields;
  final List<Map> customFields;
  final String pdfPass;

  Card({
    required this.defFields,
    required this.customFields,
    required this.pdfPass,
  });

  factory Card.fromMap(Map data) {
    print(data["pdfPass"]);
    return Card(
      defFields: [],
      customFields: [],
      pdfPass: data["pdfPass"],
    );
  }
}
