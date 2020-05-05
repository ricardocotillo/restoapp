import 'package:restaurante/models/Categoria.dart';
import 'package:restaurante/services/api.dart';

class CategoryService {
  Future<List<Categoria>> list() async {
    List<dynamic> json = await Http.get('/categories');
    return json.map((j) => Categoria.fromJson(j)).toList();
  }
}