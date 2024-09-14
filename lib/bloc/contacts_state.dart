import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<DocumentSnapshot> users;
  final List<String> existingContacts;

  const ContactsLoaded(this.users, this.existingContacts);

  @override
  List<Object> get props => [users, existingContacts];
}

class ContactsError extends ContactsState {
  final String message;

  const ContactsError(this.message);

  @override
  List<Object> get props => [message];
}
