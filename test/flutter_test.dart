import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_machine_test/blocs/home_bloc.dart';
import 'package:flutter_machine_test/blocs/home_events.dart';
import 'package:flutter_machine_test/blocs/home_state.dart';
import 'package:flutter_machine_test/data/photo_item.dart';
import 'package:flutter_machine_test/injection/injection.dart';
import 'package:flutter_machine_test/networking/network_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'flutter_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  final dio = MockDio();
  late final List<PhotoItem> items;

  setUpAll(() async {
    configureDependencies();

    getIt.allowReassignment = true;
    getIt.registerSingleton<Dio>(dio);
    mockApiData(dio);
    NetworkRepository repository = getIt<NetworkRepository>();
    items = await repository.getPhotos();
  });

  group('- Logic methods test', () {
    group('- ApiService class methods test', () {
      test('- Get Method Success test', () async {
        NetworkRepository repository = getIt<NetworkRepository>();
        List<PhotoItem> items = await repository.getPhotos();
        expect(items, isNotNull);
        expect(items.length, 5000);
      });
    });
    group('- BloC test', () {
      blocTest<HomeBloc, HomeState>(
        'emits [] when nothing is added',
        build: () => getIt<HomeBloc>(),
        expect: () => <HomeState>[
          Loading(),
          FunPhotos(items),
        ],
      );
      blocTest<HomeBloc, HomeState>('emits [HomeState] when MyEvent is added',
          build: () => getIt<HomeBloc>(),
          act: (bloc) => bloc.add(HomeEvents.loadData()),
          expect: () => <HomeState>[
                Loading(),
                FunPhotos(items),
              ],
          verify: (_) {
            verify(() => getIt<NetworkRepository>().getPhotos()).called(2);
          });
    });
  });
}

void mockApiData(Dio dio) {
  final file = File('test/json/photos.json').readAsStringSync();
  final map = json.decode(file);
  final response = Response(
      statusCode: 200,
      requestOptions: RequestOptions(path: 'gfh', baseUrl: "fgh"),
      data: map);
  when(dio.get("https://jsonplaceholder.typicode.com/photos"))
      .thenAnswer((_) async => response);
}
