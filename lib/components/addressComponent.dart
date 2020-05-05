import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurante/common/messages.dart';
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

  final CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-12.046374, -77.042793), zoom: 9);
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _addressFocusNode.addListener(() {
      print(_addressFocusNode.hasFocus);
      if (!_addressFocusNode.hasFocus &&
          !_searched &&
          _addressController.text.isNotEmpty) {
        searchAddress();
      }
    });
  }

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
          Container(
            height: size.height - size.height / 2.5,
            width: size.width,
            child: GoogleMap(
              onTap: (LatLng coo) async {
                setState(() {
                  addressNotFound = false;
                });
                if (_markers.length > 0) {
                  setState(() {
                    _markers.removeLast();
                    _markers.add(Marker(
                        markerId: MarkerId(coo.toString()),
                        icon: BitmapDescriptor.defaultMarker,
                        position: coo));
                  });
                  List<Placemark> placemarks = await _geolocator
                      .placemarkFromCoordinates(coo.latitude, coo.longitude,
                          localeIdentifier: 'es_PE');
                  if (placemarks.length > 0) {
                    Placemark placemark = placemarks.first;
                    _addressController.text =
                        '${placemark.thoroughfare} ${placemark.subThoroughfare}, ${placemark.locality}';
                  } else {
                    setState(() {
                      addressNotFound = true;
                    });
                  }
                }
              },
              initialCameraPosition: _cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              markers: Set<Marker>.from(_markers),
            ),
          ),
          Positioned(
            top: size.height - size.height / 2.5 - 25.0,
            child: Container(
              alignment: Alignment.topCenter,
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 17.0),
              width: size.width,
              height: size.height / 2.5 + 25.0,
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
                        onEditingComplete: _onEditingComplete),
                    _textFormField(
                        controller: _interiorController,
                        label: 'Interior',
                        icon: Icons.business,
                        textInputType: TextInputType.number),
                    Padding(padding: const EdgeInsets.all(5.0)),
                    RaisedButton(
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _orderProvider.saveAddress(_addressController.text,
                              _interiorController.text);
                          widget.onConfirm();
                        }
                      },
                      child: Text('Confirmar'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0))),
            ),
          )
        ],
      ),
    );
  }

  void _onEditingComplete() async {
    if (_address != _addressController.text) {
      setState(() {
        _searched = false;
      });
    } else {
      setState(() {
        _searched = true;
      });
    }
    FocusScope.of(context).unfocus();
  }

  void searchAddress() async {
    setState(() {
      _searching = true;
      addressNotFound = false;
    });
    Placemark placemark = await _getDestination(_addressController.text);
    setState(() {
      _searching = false;
    });
    if (placemark != null) {
      Position position = placemark.position;
      Marker marker = _getMarker(LatLng(position.latitude, position.longitude),
          placemark.name, BitmapDescriptor.defaultMarker);

      if (_markers.length > 0) {
        if (_markers.first.markerId.value != placemark.name) {
          setState(() {
            _markers[0] = marker;
          });
        }
      } else {
        setState(() {
          _markers.add(marker);
        });
      }
      await _goToAddress(LatLng(position.latitude, position.longitude));
    } else {
      setState(() {
        addressNotFound = true;
      });
    }
  }

  String _addressValidator(String s) {
    if (s.isEmpty) {
      return FieldMessages.notEmpty;
    }
    return null;
  }

  Marker _getMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    final MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
    );
    return marker;
  }

  Future<Placemark> _getDestination(String address) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromAddress(address, localeIdentifier: 'es_PE')
        .catchError((e) {
          print('error');
        });
    if (placemarks != null) {
      return placemarks.first;
    }
    return null;
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
