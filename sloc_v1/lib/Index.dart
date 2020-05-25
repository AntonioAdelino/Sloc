import 'package:flutter/material.dart';
import 'package:Sloc/TelaBuscarGerente.dart';
import 'package:Sloc/TelaCadastroGerente.dart';
import 'package:Sloc/TelaCadastroVendedor.dart';
import 'TelaBuscarVendedor.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  Completer<GoogleMapController> _controllerMap = Completer();
  Set<Marker> _marcadores = {};
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-7.685516, -35.516136), zoom: 15);

  _carregarMarcadores() {
    Set<Marker> marcadoresLocal = {};

    Marker marcador = Marker(
        markerId: MarkerId("marcador"),
        position: LatLng(-7.685516, -35.516136),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: "Casa"),
        onTap: () {
          print("click feito");
        });

    marcadoresLocal.add(marcador);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 17);
      _movimentarCamera();
    });
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controllerMap.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    );
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      //atualiza a posição do marcador
      setState(() {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 17);
        _movimentarCamera();
      });
    });
  }

  @override
  void initState() {
    _recuperarLocalizacaoAtual();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sloc"),
        backgroundColor: Color(0xff315a7d),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              decoration: BoxDecoration(
                color: Color(0xff315a7d),
              ),
            ),
            ExpansionTile(
              leading: Icon(Icons.people),
              title: Text(
                "Cadastrar",
                style: TextStyle(fontSize: 16),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Gerente',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaCadastroGerente()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Vendedor',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaCadastroVendedor()));
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.search),
              title: Text(
                "Pesquisar",
                style: TextStyle(fontSize: 16),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Gerente',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaBuscarGetente()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Vendedor',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaBuscarVendedor()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              minMaxZoomPreference: MinMaxZoomPreference(15, 17),
              initialCameraPosition: _posicaoCamera,
              onMapCreated: (GoogleMapController controller) {
                _controllerMap.complete(controller);
              },
              myLocationEnabled: true,
              mapToolbarEnabled: false,
              markers: _marcadores,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search, color: Colors.white),
        backgroundColor: Color(0xff315a7d),
        onPressed: () {
          _carregarMarcadores();
        },
      ),
    );
  }
}
