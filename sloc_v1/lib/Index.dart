import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sloc/TelaBuscarGerente.dart';
import 'package:Sloc/TelaCadastroGerente.dart';
import 'package:Sloc/TelaCadastroVendedor.dart';
import 'TelaBuscarVendedor.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';


class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

  Completer<GoogleMapController> _controllerMap = Completer();
  Set<Marker> _marcadores = {};
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-0.000000, -0.000000), zoom: 15);
  double latUsuario = -0.000000;
  double longUsuario = -0.000000;


  TextEditingController _profissionalController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _cidadeController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();


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
      latUsuario = position.latitude;
      longUsuario = position.longitude;
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
        latUsuario = position.latitude;
        longUsuario = position.longitude;
        _movimentarCamera();

      });
    });
  }

  @override
  void initState() {
    //_recuperarLocalizacaoAtual();
    _adicionarListenerLocalizacao();
  }


  _pesquisarProfissional() async {
    //pesquisa o profissional por area
//    List<Placemark> listaProfissionais = await Geolocator()
//        .placemarkFromAddress(_profissionalController.text + "," + _bairroController.text
//        + "," + _cidadeController.text + "," + _estadoController.text);
//
//    if(listaProfissionais != null && listaProfissionais.length > 0){
//      for(Placemark item in listaProfissionais){
//        print('oi');
//        print(item.position.latitude.toString()+"\n");
//        print(item.position.longitude.toString()+"\n");
//      }
//    }

    GoogleMapsPlaces places = new GoogleMapsPlaces(apiKey: "AIzaSyACKuQtJ1jP69DM4P_9V1B5s8sRXzvQZf4");
    PlacesSearchResponse resultadoBusca = await places.searchByText(_profissionalController.text
        + "," + _bairroController.text + "," + _cidadeController.text + "," + _estadoController.text);

    List<PlacesSearchResult> lugares = resultadoBusca.results;
    print("Status busca: "+resultadoBusca.status);
    print("\nQuantidade de lugares: "+ lugares.length.toString());

    for(PlacesSearchResult item in lugares){
      print("\n"+item.name);
      _adicionarMarcadoresDeBusca(item);
      }
  }

  _adicionarMarcadoresDeBusca(PlacesSearchResult lugar) {
    //criando marcador
    Marker marcador = Marker(
        markerId: MarkerId(lugar.id),
        position: LatLng(lugar.geometry.location.lat, lugar.geometry.location.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: lugar.name),
        onTap: () {
          //print("click feito");
        });
    //adicionando no mapa
    setState(() {
      _marcadores.add(marcador);
    });
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
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              markers: _marcadores,
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.white
                ),
                child: TextField(
                  controller: _profissionalController,
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.assignment_ind),
                    hintText: "Digite o profissional",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 45,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white
                ),
                child: TextField(
                  controller: _bairroController,
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                      hintText: "Digite o bairro",
                      border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 90,
            left: 0,
            right: 100,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white
                ),
                child: TextField(
                  controller: _cidadeController,
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                      hintText: "Digite a cidade",
                      border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 90,
            left: 240,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                height: 40,
                width: 42,
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white
                ),
                child: TextField(
                  controller: _estadoController,
                  decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                      //prefixIcon: Icon(Icons.location_on),
                      hintText: "\tUF",
                      border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

//          Align(
//            alignment: Alignment.bottomLeft,
//            child: Container(
//              margin: EdgeInsets.symmetric(vertical: 20),
//              height: 150,
//              child: ListView(
//                scrollDirection: Axis.horizontal,
//                children: <Widget>[
//                  SizedBox(width: 10),
//                  Padding(
//                    padding: const EdgeInsets.all(8),
//                    child: _boxes(),
//                    //ver video no card
//                  )
//                ],
//              ),
//            ),
//          ),

        ],
      ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search, color: Colors.white),
        backgroundColor: Color(0xff315a7d),
        onPressed: () {
          _carregarMarcadores();
          _pesquisarProfissional();
        },
      ),
    );
  }
}
