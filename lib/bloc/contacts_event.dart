import 'package:equatable/equatable.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class LoadContactsEvent extends ContactsEvent {}

class AddContactEvent extends ContactsEvent {
  final String userId;
  final String userName;

  const AddContactEvent(this.userId, this.userName);

  @override
  List<Object> get props => [userId, userName];
}
