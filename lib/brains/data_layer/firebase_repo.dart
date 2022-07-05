import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:visits_prod/brains/cards_brain.dart';
import 'package:visits_prod/brains/templates_brain.dart';

class FirebaseRepo {
  static const String _storageFolder = 'cards';
  static final _cards = FirebaseFirestore.instance.collection('cards');
  static final _templates = FirebaseFirestore.instance.collection('templates');
  static final _storage =
      FirebaseStorage.instanceFor(bucket: "gs://my-cards-e6faa.appspot.com/");

  static Future<UserCredential> loginUser(String email, String pass) async {
    return await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
  }

  static Future<UserCredential> loginSilent() async {
    return await FirebaseAuth.instance.signInAnonymously();
  }

  static Future<UserCredential> registerUser(String email, String pass) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);
  }

  static User? getUser() {
    var result = FirebaseAuth.instance.currentUser;
    return result;
  }

  ///----------------------------------------------------------------------------

  static Future<Card> createCard({
    required File file,
    required List<Map> defFields,
    required List<Map> customFields,
    required String templateId,
  }) async {
    print("DONE!!!1");
    String pdfPass = await _uploadCard(file);
    print(pdfPass);
    await _cards.doc().set({
      "creator_uuid": FirebaseAuth.instance.currentUser?.uid,
      "defFields": defFields,
      "customFields": customFields,
      "pdfPass": pdfPass,
    });
    print("DONE!!!");
    return Card(
      defFields: [{}],
      customFields: [{}],
      pdfPass: pdfPass,
    );
  }

  static Future<String> _uploadCard(File file) async {
    File card = file;
    var ref = _storage.ref().child(
        '$_storageFolder/${file.path.substring(file.path.lastIndexOf("/") + 1)}');
    var response = ref.putFile(card);
    var url = await ref.getDownloadURL();
    print(url);
    print("DONE!!!2");
    return url;
  }

  static String _buildFileUrl(String bucket, String id) {
    return "https://storage.googleapis.com/$bucket$_storageFolder/$id";
  }

  ///----------------------------------------------------------------------------

  static Future<List<Template>> getAllTemplates() async {
    var response = await _templates.get();
    print(response.docs.first.data());

    List<Template> templates = [];
    for (var item in response.docs) {
      if (item.data()["active"] ?? false) {
        var temp = Template.fromMap(item.data(), item.id);
        temp.updatePreview();
        templates.add(temp);
      }
    }
    return templates;
  }

  ///----------------------------------------------------------------------------

  static Future<List<Card>> getAllMyCards() async {
    var response = await _cards
        .where('creator_uuid',
            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    print(response.docs.first.data());

    List<Card> templates = [];
    for (var item in response.docs) {
      templates.add(Card.fromMap(item.data()));
    }
    return templates;
  }
}
