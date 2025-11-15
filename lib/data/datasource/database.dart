abstract class Database<T> {
  Future<Map<dynamic, T>> get();

  Future<T?> getById(int id);

  Future<int?> insert(T element);

  Future<int?> delete(int id);
}
