abstract class BlocState<T> {}

class LoadingBlocState extends BlocState {}

class SuccessBlocState<T> extends BlocState {
  SuccessBlocState({required this.result});

  final T result;
}

class ErrorBlocState extends BlocState {}

class EmptyBlocState extends BlocState {}
