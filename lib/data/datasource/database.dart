abstract class Database<T> {
  Map<dynamic, T> get();

  T? getById(int id);

  Future<int?> insert(T element);

  Future<T?> delete(int id);
}
