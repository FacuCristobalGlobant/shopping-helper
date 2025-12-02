abstract class DatabaseRepository<T> {
  List<T> get();
  T? getById(int id);
  Future<int?> insert(T element);
  Future<T?> delete(int id);
}