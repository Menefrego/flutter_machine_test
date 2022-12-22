import 'package:dio/dio.dart';
import 'package:flutter_machine_test/data/photo_item.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class NetworkRepository {
  final Dio dio;

  NetworkRepository({required this.dio});

  Future<List<PhotoItem>> getPhotos() async {
    List<PhotoItem> photos = [];
    Response photosResponse =
        await dio.get('https://jsonplaceholder.typicode.com/photos');
    photos = photosFromResponse(photosResponse.data);
    return photos;
  }
}
