import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_machine_test/data/photo_item.dart';
import 'package:flutter_machine_test/injection/injection.dart';
import 'package:flutter_machine_test/networking/network_repository.dart';
import 'package:flutter_machine_test/screens/detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_machine_test/main.dart';
import 'package:mockito/annotations.dart';

import 'flutter_test.dart';
import 'flutter_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  final dio = MockDio();
  setUpAll(() async {
    configureDependencies();

    getIt.allowReassignment = true;
    getIt.registerSingleton<Dio>(dio);
    mockApiData(dio);
  });

  group('- Flutter Machine test', () {
    testWidgets('- Functionality test', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      NetworkRepository repository = getIt<NetworkRepository>();
      final List<PhotoItem> items = await repository.getPhotos(); //getting data
      expect(
          find.text('accusamus ea aliquid et amet sequi nemo',
              skipOffstage: false),
          findsOneWidget); // checking if data is populated
      final item = items.firstWhere((e) => e.id == 5);
      final selectedItem = find.byKey(const Key('item-5'));
      await tester.tap(selectedItem); //tapping on a list item
      await tester.pump();
      expect(
          find.text(item.title), findsOneWidget); //checking if title is present
      expect(find.text('album #: ${item.albumId}', skipOffstage: false),
          findsOneWidget); //checking if description is present
    });

    testWidgets('- Cached network image test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DetailScreen(
            item: PhotoItem(
          albumId: 1,
          id: 11,
          title: 'test',
          url: 'https://via.placeholder.com/600/d32776',
          thumbnailUrl: 'https://via.placeholder.com/150/f66b97',
        )),
      ));
      await tester.pump();
      expect(find.byType(CachedNetworkImage),
          findsOneWidget); //checking if header image is present;
    });
  });
}
