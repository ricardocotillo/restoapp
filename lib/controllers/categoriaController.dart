import 'package:restaurante/models/Categoria.dart';
import 'package:restaurante/services/categoryService.dart';

class CategoriaController {
  static final CategoryService _categoriaService = CategoryService();

  Future<List<Categoria>> list() async {
    return _categoriaService.list();
  }
}