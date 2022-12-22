import 'package:flutter_machine_test/data/photo_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState.nada() = Nada;

  factory HomeState.loading() = Loading;

  factory HomeState.funPhotos(List<PhotoItem> photos) = FunPhotos;

  factory HomeState.error(String error) = Error;
}
