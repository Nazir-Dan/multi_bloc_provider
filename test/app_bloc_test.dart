import 'dart:typed_data' show Uint8List;
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_bloc_provider/bloc/app_bloc.dart';
import 'package:multi_bloc_provider/bloc/app_state.dart';
import 'package:multi_bloc_provider/bloc/bloc_events.dart';

extension ToList on String {
  Uint8List toUin8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUin8List();
final text2Data = 'Bar'.toUin8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'initial state of the bloc should be empty',
    build: () => AppBloc(
      urls: [],
    ),
    verify: (bloc) => expect(
      bloc.state,
      const AppState.empty(),
    ),
  );

  //load valid data and compare the states
  blocTest<AppBloc, AppState>(
    'test the ability to load a url',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (bloc) => bloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text1Data,
        error: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'throw an error in urlLoader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (bloc) => bloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        data: null,
        error: Errors.dummy,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'test the ability to load more than one url',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (bloc) {
      bloc.add(
        const LoadNextUrlEvent(),
      );
      bloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2Data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2Data,
        error: null,
      ),
    ],
  );
}
