abstract class Database<T> {
  Future<List<T>> get();
  Future<T?> getById(int id);
  Future<int?> insert(T element);
  Future<int?> delete(int id);
}