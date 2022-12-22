import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_machine_test/blocs/home_bloc.dart';
import 'package:flutter_machine_test/blocs/home_state.dart';
import 'package:flutter_machine_test/data/photo_item.dart';
import 'package:flutter_machine_test/injection/injection.dart';
import 'package:flutter_machine_test/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
      ),
      body: BlocProvider(
        create: (_) => getIt<HomeBloc>(),
        child: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return state.when(nada: () {
                return _loading;
              }, loading: () {
                return _loading;
              }, funPhotos: (fact) {
                return _photosList(fact, context);
              }, error: (error) {
                return _error(error);
              });
            },
          ),
        ),
      ),
    );
  }

  Center _error(String error) {
    return Center(
      child: Text(error),
    );
  }

  Widget _photosList(List<PhotoItem> photos, BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = photos[index];
        return Card(
          key: Key('item-${item.id}'),
          elevation: 3,
          child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(item: item),
                  ),
                );
              },
              leading: Hero(
                  tag: "SelectedItem-${item.id}",
                  child: CachedNetworkImage(
                    imageUrl: item.thumbnailUrl,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )),
              title: Text(item.title),
              dense: true,
              visualDensity: const VisualDensity(vertical: 4)),
        );
      },
      itemCount: photos.length,
    );
  }

  Widget get _loading => const Center(
        child: CircularProgressIndicator(),
      );
}
