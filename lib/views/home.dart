import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurante/components/cartIcon.dart';
import 'package:restaurante/components/categoryPanel.dart';
import 'package:restaurante/controllers/auth.controller.dart';
import 'package:restaurante/controllers/categoriaController.dart';
import 'package:restaurante/models/categoria.dart';
import 'package:restaurante/views/cart.dart';
import 'package:restaurante/views/login.view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Image banner = Image.asset(
    'assets/img/imagen1.jpg',
    fit: BoxFit.cover,
  );

  final CategoriaController _categoriaController = CategoriaController();
  Future<List<Categoria>> _future;

  List<Categoria> categorias;

  @override
  void initState() {
    super.initState();
    _future = _categoriaController.list();
  }

  @override
  void didChangeDependencies() {
    precacheImage(banner.image, context);
    super.didChangeDependencies();
  }

  Future<void> _refreshData() async {
    setState(() {
      _future = _categoriaController.list();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Demo'),
          leading: CartIcon(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CartView())),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(FontAwesomeIcons.signOutAlt),
                onPressed: () {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('Estas por salir del aplicativo'),
                        content: Text('¿Seguro que deaseas salir?'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _logout();
                              },
                              child: Text('Aceptar')),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                            textColor: Colors.red,
                          ),
                        ],
                      ));
                })
          ],
        ),
        body: FutureBuilder(
            future: _future,
            builder:
                (BuildContext context, AsyncSnapshot<List<Categoria>> snap) {
              switch (snap.connectionState) {
                case ConnectionState.done:
                  categorias = snap.data;
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          banner,
                          categorias != null
                              ? CategoriaPanel(
                                  categorias: categorias
                                      .where((c) => c.items.length > 0)
                                      .toList(),
                                  expansionCallback: (int i, bool expanded) {
                                    setState(() {
                                      categorias[i].isExpanded = !expanded;
                                    });
                                  },
                                )
                              : null,
                        ].where((element) => element != null).toList(),
                      ),
                    ),
                  );
                  break;
                default:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }
            }));
  }

  void _logout() {
    final AuthController authController = AuthController();
    authController.logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()), (route) => false);
  }
}
