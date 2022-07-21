abstract class EntityService<T> {
  Future<List<T>> list();
  Future<T?> byId(String id);
  Future<T> create(T doc);
  Future<T> update(T doc);
  Future<int> delete(String id);
}
