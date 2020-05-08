import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/common/messages.dart';
import 'package:restaurante/components/mapContainer.dart';
import 'package:restaurante/providers/orderProvider.dart';

class AddressComponent extends StatefulWidget {
  final VoidCallback onConfirm;

  AddressComponent({this.onConfirm});

  @override
  _AddressComponentState createState() => _AddressComponentState();
}

class _AddressComponentState extends State<AddressComponent> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _addressFocusNode = FocusNode();

  final Geolocator _geolocator = Geolocator();
  final Completer<GoogleMapController> _mapController = Completer();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _interiorController = TextEditingController();

  bool addressNotFound = false;
  final String addressErrorText = 'No podemos encontrar tu dirección';

  String _address = '';
  bool _searched = false;
  bool _searching = false;

  CameraPosition _cameraPosition;

  List<Marker> _markers = [];

  List<Placemark> _placemarks;

  @override
  Widget build(BuildContext context) {
    final OrderProvider _orderProvider = Provider.of<OrderProvider>(context);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            color: Colors.transparent,
          ),
          _cameraPosition != null
              ? MapContainer(
                  mapController: _mapController,
                  height: size.height - size.height / 2.5,
                  width: size.width,
                  initialCameraPosition: _cameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                    setState(() {
                      _searched = true;
                    });
                  },
                )
              : null,
          Positioned(
            bottom: 0.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              alignment: Alignment.topCenter,
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 17.0),
              width: size.width,
              height: _searched ? size.height / 2.5 + 25.0 : size.height,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 17.0,
                        height: 17.0,
                        child: _searching
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                              )
                            : null,
                      ),
                    ),
                    Text(
                      'Dinos tu ubicación',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    _textFormField(
                      focusNode: _addressFocusNode,
                      validator: _addressValidator,
                      errorText: addressNotFound ? addressErrorText : null,
                      controller: _addressController,
                      label: 'Dirección',
                      icon: Icons.room,
                      textInputAction: TextInputAction.search,
                      onEditingComplete: _searchAddress,
                    ),
                    _placemarks != null && !_searched
                        ? ListView.separated(
                            separatorBuilder: (BuildContext context, int i) =>
                                Divider(
                                  height: 9.0,
                                ),
                            shrinkWrap: true,
                            itemCount: _placemarks.length,
                            itemBuilder: (BuildContext context, int i) =>
                                ListTile(
                                    onTap: () {
                                      _listTileOnTap(
                                          '${_placemarks[i].thoroughfare} ${_placemarks[i].subThoroughfare}, ${_placemarks[i].locality}, ${_placemarks[i].administrativeArea}',
                                          _placemarks[i].position);
                                    },
                                    dense: true,
                                    title: Text(
                                        '${_placemarks[i].thoroughfare} ${_placemarks[i].subThoroughfare}, ${_placemarks[i].locality}, ${_placemarks[i].administrativeArea}')))
                        : null,
                    _searched
                        ? _textFormField(
                            controller: _interiorController,
                            label: 'Interior',
                            icon: Icons.business,
                            textInputType: TextInputType.number)
                        : null,
                    Padding(padding: const EdgeInsets.all(5.0)),
                    _searched
                        ? RaisedButton(
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _orderProvider.saveAddress(
                                    _addressController.text,
                                    _interiorController.text);
                                widget.onConfirm();
                              }
                            },
                            child: Text('Confirmar'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                          )
                        : null,
                  ].where((w) => w != null).toList(),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _searched
                      ? BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0))
                      : null),
            ),
          )
        ].where((w) => w != null).toList(),
      ),
    );
  }

  void _searchAddress() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _searched = false;
      _searching = true;
      addressNotFound = false;
    });
    List<Placemark> placemarks = await _getAddresses(_addressController.text)
        .catchError((e) => print(e.toString()));
    setState(() {
      _searching = false;
    });
    if (placemarks != null) {
      setState(() {
        _placemarks = placemarks;
      });
    } else {
      setState(() {
        addressNotFound = true;
      });
    }
  }

  void _listTileOnTap(String address, Position position) {
    _addressController.text = address;
    setState(() {
      _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 17);
    });
  }

  String _addressValidator(String s) {
    if (s.isEmpty) {
      return FieldMessages.notEmpty;
    }
    return null;
  }

  Future<List<Placemark>> _getAddresses(String address) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromAddress(address, localeIdentifier: 'es_PE')
        .catchError((e) {
      print('error');
    });
    return placemarks;
  }

  Future<void> _goToAddress(LatLng position) async {
    CameraPosition _newCameraPosition =
        CameraPosition(target: position, zoom: 18);
    final GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Widget _textFormField(
      {TextEditingController controller,
      FocusNode focusNode,
      String Function(String) validator,
      String label,
      IconData icon,
      TextInputType textInputType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.done,
      VoidCallback onEditingComplete,
      String errorText,
      Function(String) onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 14.5),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        validator: validator,
        style: TextStyle(fontSize: 13.0),
        decoration: InputDecoration(
            errorText: errorText,
            labelText: label,
            icon: Icon(
              icon,
              size: 18.0,
            )),
      ),
    );
  }
}
