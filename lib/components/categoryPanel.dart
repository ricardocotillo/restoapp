import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurante/models/Categoria.dart';
import 'package:restaurante/views/detail.dart';

class CategoriaPanel extends StatefulWidget {
  final List<Categoria> categorias;
  final void Function(int, bool) expansionCallback;

  const CategoriaPanel({Key key, this.categorias, this.expansionCallback})
      : super(key: key);
  @override
  _CategoriaPanelState createState() => _CategoriaPanelState();
}

class _CategoriaPanelState extends State<CategoriaPanel> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        expansionCallback: widget.expansionCallback,
        children: widget.categorias
            .map((c) => ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool expanded) =>
                    ListTile(
                      dense: true,
                      title: Text(c.title),
                    ),
                isExpanded: c.isExpanded,
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                        c.image != null ? Image.network(c.image) : null
                      ].where((w) => w != null).toList() +
                      c.items
                          .map((item) => ListTile(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            DetailView(item: item))),
                                leading: SizedBox(
                                  width: 35.0,
                                  height: 35.0,
                                  child: Image.network(item.image),
                                ),
                                title: Text(item.title),
                                subtitle: item.description != null
                                    ? Text(item.description)
                                    : null,
                                trailing: Text(item.price.toStringAsFixed(2)),
                              ))
                          .toList(),
                )))
            .toList());
  }
}
