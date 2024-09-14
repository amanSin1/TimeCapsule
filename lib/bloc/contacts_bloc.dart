import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import './contacts_event.dart';
import './contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  ContactsBloc() : super(ContactsInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
  }

  // Handle loading contacts
  Future<void> _onLoadContacts(
      LoadContactsEvent event, Emitter<ContactsState> emit) async {
    emit(ContactsLoading());

    try {
      final existingContacts = await _getExistingContacts();
      final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
      final users = usersSnapshot.docs.where((user) =>
      user.id != currentUserId && !existingContacts.contains(user.id)).toList();

      emit(ContactsLoaded(users, existingContacts));
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  // Handle adding a contact
  Future<void> _onAddContact(
      AddContactEvent event, Emitter<ContactsState> emit) async {
    if (currentUserId == null) return;

    final contactDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('contacts')
        .doc(event.userId);

    final contactDoc = await contactDocRef.get();

    if (!contactDoc.exists) {
      await contactDocRef.set({
        'name': event.userName,
        'addedAt': FieldValue.serverTimestamp(),
      });

      final currentState = state as ContactsLoaded;
      final updatedUsers = currentState.users.where((user) => user.id != event.userId).toList();
      final updatedContacts = List<String>.from(currentState.existingContacts)..add(event.userId);

      emit(ContactsLoaded(updatedUsers, updatedContacts));
    } else {
      // Optionally handle when contact already exists
    }
  }

  // Helper method to get existing contacts
  Future<List<String>> _getExistingContacts() async {
    if (currentUserId == null) return [];

    final contactSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('contacts')
        .get();

    return contactSnapshot.docs.map((doc) => doc.id).toList();
  }
}
