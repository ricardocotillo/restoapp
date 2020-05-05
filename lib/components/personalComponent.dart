import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/common/messages.dart';
import 'package:restaurante/providers/orderProvider.dart';
import 'package:validators/validators.dart';

class PersonalComponent extends StatefulWidget {
  final VoidCallback onConfirm;

  PersonalComponent({this.onConfirm});
  @override
  _PersonalComponentState createState() => _PersonalComponentState();
}

class _PersonalComponentState extends State<PersonalComponent> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextStyle _inputTextStyle = TextStyle(fontSize: 13.0);
  final TextStyle _titleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneControler = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final OrderProvider _orderProvider = Provider.of<OrderProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          width: size.width,
          height: size.height,
          color: Colors.transparent,
        ),
        Container(
          height: size.height / 3,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/imagen1.jpg'),
                  fit: BoxFit.cover)),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                )),
            alignment: Alignment.center,
            height: (size.height / 3) * 2 + 25,
            width: size.width,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Necesitamos algunos datos para completar tu pedido',
                      style: _titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: _nameValidator,
                      style: _inputTextStyle,
                      decoration: InputDecoration(
                        labelText: 'Nombre completo',
                        icon: Icon(Icons.person),
                      ),
                    ),
                    TextFormField(
                      validator: _phoneValidator,
                      controller: _phoneControler,
                      style: _inputTextStyle,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText: 'Ej. 971001097',
                          labelText: 'Teléfono',
                          icon: Icon(Icons.phone)),
                    ),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      style: _inputTextStyle,
                      decoration: InputDecoration(
                        hintText: '¿Tienes algunas intrucciones adicionales?',
                          labelText: 'Notas',
                          icon: Icon(FontAwesomeIcons.solidClipboard)),
                    ),
                    Padding(padding: const EdgeInsets.all(5.0)),
                    RaisedButton(
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState.validate()) {
                          _orderProvider.savePersonal(_nameController.text,
                              _phoneControler.text, _notesController.text);
                          widget.onConfirm();
                        }
                      },
                      child: Text('Confirmar'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }

  String _nameValidator(String s) {
    if (s.isEmpty) {
      return FieldMessages.notEmpty;
    }
    if (!isAlpha(s.replaceAll(new RegExp(r'\ '), ''))) {
      return FieldMessages.alpha;
    }
    return null;
  }

  String _phoneValidator(String s) {
    if (s.isEmpty) {
      return FieldMessages.notEmpty;
    }
    if (!isNumeric(s)) {
      return FieldMessages.numeric;
    }
    return null;
  }
}
