//import 'dart:ffi';

//import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:path/path.dart';

import 'package:personalnotesapp/constants/routes.dart';
//import 'package:personalnotesapp/services/auth/auth_service.dart';
import 'package:personalnotesapp/services/auth/bloc/auth_bloc.dart';
import 'package:personalnotesapp/services/auth/bloc/auth_event.dart';
import 'package:personalnotesapp/services/auth/bloc/auth_state.dart';
import 'package:personalnotesapp/services/auth/firebase_auth_provider.dart';

import 'package:personalnotesapp/views/login_view.dart';
import 'package:personalnotesapp/views/notes/create_update_note_view.dart.dart';
import 'package:personalnotesapp/views/register_view.dart';
import 'package:personalnotesapp/views/verify_email_view.dart';



import 'views/notes/notes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const Homepage(),
    ),
    routes: {
      loginRoute: (context) => const Loginview(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const notesview(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc,AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const notesview();
        } else if (state is AuthStateNeedsVerification) {
          return const verifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const Loginview();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
    /*return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final User = AuthService.firebase().currentUser;
            if (User != null) {
              if (User.isEmailVerified) {
                return const notesview();
              } else {
                return const verifyEmailView();
              }
            } else {
              return const Loginview();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
*/

/*
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('testing bloc'),
          actions: [],
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInValidNumber) ? state.InvalidValue : '';
            return Column(
              children: [
                Text('current value => ${state.value}'),
                Visibility(
                  child: Text('invalid input: $invalidValue'),
                  visible: state is CounterStateInValidNumber,
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'enter a number here',
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(DecreamentEvent(_controller.text));
                        },
                        child: const Text('-')),
                    TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(IncrementEvent(_controller.text));
                        },
                        child: const Text('+')),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInValidNumber extends CounterState {
  final String InvalidValue;

  CounterStateInValidNumber({
    required this.InvalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecreamentEvent extends CounterEvent {
  const DecreamentEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInValidNumber(
          InvalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(
          CounterStateValid(state.value + integer),
        );
      }
    });
    on<DecreamentEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInValidNumber(
          InvalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(
          CounterStateValid(state.value - integer),
        );
      }
    });
  }
}
*/