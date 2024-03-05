import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:n_n/Entity/termin.dart';


class CrudMethods {
  Future<List<Termin>> getData(String collectionsName) async {
    List<Termin> data = [];
    await FirebaseFirestore.instance
        .collection(collectionsName)
        .orderBy("word")
        .get()
        .then((snap) => snap.docs.forEach((element) {
              print(element.id);
              final newTermin = Termin.fromJson(element.data());
              data.add(newTermin);
            }));
    return data;
  }

  Future addTermin(
      {required String word,
      required String descriptions,
      required String collectionsName}) async {
    final doc = FirebaseFirestore.instance.collection(collectionsName).doc();

    final newTermin = Termin(word: word, descriptions: descriptions);
    final json = newTermin.toJson();

    await doc.set(json);
  }

  void delete(String id, String collectionName) async {
    await FirebaseFirestore.instance.collection(collectionName).doc(id).delete();
  }
}