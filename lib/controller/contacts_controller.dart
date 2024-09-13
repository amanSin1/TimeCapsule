import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsController extends GetxController {
  var selectedContacts = <String>{}.obs; // Set to store selected contact IDs

  void toggleContact(String contactId) {
    if (selectedContacts.contains(contactId)) {
      selectedContacts.remove(contactId);
    } else {
      selectedContacts.add(contactId);
    }
  }

  bool isContactSelected(String contactId) {
    return selectedContacts.contains(contactId);
  }
}
