import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

class AddContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contacts'),
      ),
      body: BlocProvider(
        create: (context) => ContactsBloc()..add(LoadContactsEvent()),
        child: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactsLoaded) {
              if (state.users.isEmpty) {
                return const Center(
                  child: Text('No users to add as contacts.'),
                );
              }

              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  final userId = user.id;
                  final userName = user['username'];

                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(

                      border: Border.all(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ListTile(
                      title: Text(
                        userName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: ElevatedButton(

                        onPressed: () {
                          context
                              .read<ContactsBloc>()
                              .add(AddContactEvent(userId, userName));
                        },
                        child: const Text('Add',style: TextStyle(color: Colors.yellow),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ContactsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown state.'));
            }
          },
        ),
      ),
    );
  }
}
