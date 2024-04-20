import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';

mixin CacheMixin<T> {
  Future<T?> loadFromCache(String key) async {
    final cachedData = await HydratedBloc.storage.read(key);
    if (cachedData != null) {
      return json.decode(cachedData) as T;
    }
    return null;
  }

  Future<void> saveToCache(String key, T data) async {
    final encodedData = json.encode(data);
    await HydratedBloc.storage.write(key, encodedData);
  }
}
