import 'package:flutter/material.dart';
import 'package:restaurante/components/cartIcon.dart';
import 'package:restaurante/controllers/categoriaController.dart';
import 'package:restaurante/models/Categoria.dart';
import 'package:restaurante/views/cart.dart';
import 'package:restaurante/views/detail.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CategoriaController _categoriaController = CategoriaController();
  Future<List<Categoria>> _future;

  @override
  void initState() {
    super.initState();
    _future = _categoriaController.list();
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
          actions: <Widget>[
            CartIcon(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CartView())),
            )
          ],
        ),
        body: FutureBuilder(
            future: _future,
            builder:
                (BuildContext context, AsyncSnapshot<List<Categoria>> snap) {
              switch (snap.connectionState) {
                case ConnectionState.done:
                  List<Categoria> categorias = snap.data;
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset('assets/img/imagen1.jpg'),
                          ExpansionPanelList(
                            expansionCallback: (int i, bool isExpanded) {
                              setState(() {
                                categorias[i].isExpanded = !isExpanded;
                              });
                            },
                            children: categorias
                                .map((c) => ExpansionPanel(
                                    isExpanded: c.isExpanded,
                                    headerBuilder: (BuildContext context,
                                            bool isExpaded) =>
                                        ListTile(
                                          title: Text(c.title),
                                        ),
                                    body: Column(
                                        children: <Widget>[
                                              c.image != null
                                                  ? Image.network(c.image)
                                                  : null,
                                            ].where((e) => e != null).toList() +
                                            c.items
                                                .map((item) => ListTile(
                                                      onTap: () => Navigator.of(
                                                              context)
                                                          .push(MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  DetailView(
                                                                      item:
                                                                          item))),
                                                      leading: SizedBox(
                                                        width: 35.0,
                                                        height: 35.0,
                                                        child: Image.network(
                                                            item.image),
                                                      ),
                                                      title: Text(item.title),
                                                      subtitle:
                                                          item.description !=
                                                                  null
                                                              ? Text(item
                                                                  .description)
                                                              : null,
                                                      trailing: Text(item.price
                                                          .toStringAsFixed(2)),
                                                    ))
                                                .toList())))
                                .toList(),
                          )
                        ],
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
}
