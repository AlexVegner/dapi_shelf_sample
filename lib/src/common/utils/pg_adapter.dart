abstract class PgAdapter<T> {
  Map<String, dynamic> toPg(T value);

  T fromPg(Map<String, dynamic> map);
}
