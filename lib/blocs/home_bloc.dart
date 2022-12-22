import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_machine_test/blocs/home_events.dart';
import 'package:flutter_machine_test/blocs/home_state.dart';
import 'package:flutter_machine_test/networking/network_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeBloc extends Bloc<HomeEvents, HomeState> {
  final NetworkRepository repository;

  HomeBloc(this.repository) : super(HomeState.nada()) {
    on<LoadData>((event, emit) async {
      emit(HomeState.loading());
      await repository
          .getPhotos()
          .then((value) => emit(HomeState.funPhotos(value)))
          .onError(
              (error, stackTrace) => emit(HomeState.error(error.toString())));
    });
    add(HomeEvents.loadData());
  }
}
