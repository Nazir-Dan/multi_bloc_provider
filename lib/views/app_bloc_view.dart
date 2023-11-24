import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_provider/bloc/app_bloc.dart';
import 'package:multi_bloc_provider/bloc/app_state.dart';
import 'package:multi_bloc_provider/bloc/bloc_events.dart';
import 'package:multi_bloc_provider/extentions/stream/start_with.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({super.key});
  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, state) {
          if (state.error != null) {
            return const Text('Something went wrong. please try again later!');
          } else if (state.data != null) {
            return Image.memory(
              state.data!,
              fit: BoxFit.fitHeight,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
