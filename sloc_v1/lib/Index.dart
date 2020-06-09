import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Sloc/TelaBuscarGerente.dart';
import 'package:Sloc/TelaCadastroGerente.dart';
import 'package:Sloc/TelaCadastroVendedor.dart';
import 'package:flutter/painting.dart';
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
  //////////////////////////////////////////////////////////////////
  //                          ATRIBUTOS                           //
  //////////////////////////////////////////////////////////////////

  //Atributos Maps
  Completer<GoogleMapController> _controllerMap = Completer();
  Set<Marker> _marcadores = {};
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-0.000000, -0.000000), zoom: 8);

  List<PlacesSearchResult> _lugares = [];

  double latUsuario, longUsuario;

  //Atributos TextField
  TextEditingController _profissionalController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _cidadeController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();

  bool visibilidade = false;

  //////////////////////////////////////////////////////////////////
  //                         MÉTODOS                              //
  //////////////////////////////////////////////////////////////////

//  _carregarMarcadores() {
//    Set<Marker> marcadoresLocal = {};
//
//    Marker marcador = Marker(
//        markerId: MarkerId("marcador"),
//        position: LatLng(-7.685516, -35.516136),
//        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//        infoWindow: InfoWindow(title: "Casa"),
//        onTap: () {
//          print("click feito");
//        });
//
//    marcadoresLocal.add(marcador);
//
//    setState(() {
//      _marcadores = marcadoresLocal;
//    });
//  }
//
//  _recuperarLocalizacaoAtual() async {
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//    setState(() {
//      _posicaoCamera = CameraPosition(
//          target: LatLng(position.latitude, position.longitude), zoom: 17);
//      _movimentarCamera();
//    });
//  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controllerMap.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.best,
      distanceFilter: 20,
    );
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      //atualiza a posição do marcador
      setState(() {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 8);
        latUsuario = position.latitude;
        longUsuario = position.longitude;
        _movimentarCamera();
      });
    });
  }

  _pesquisarProfissional() async {
    //limpar marcadores
    _marcadores.clear();
    //pesquisa o profissional por area

    GoogleMapsPlaces places =
        new GoogleMapsPlaces(apiKey: "AIzaSyACKuQtJ1jP69DM4P_9V1B5s8sRXzvQZf4");

    if (!visibilidade) {
      _pesquisarSemEndereco(places);
    } else {
      _pesquisarComEndereco(places);
    }
  }

  _pesquisarSemEndereco(places) async {
    List<Placemark> endereco =
        await Geolocator().placemarkFromCoordinates(latUsuario, longUsuario);
    Placemark localAtual = endereco[0];

    PlacesSearchResponse resultadoBusca = await places.searchByText(
        _profissionalController.text +
            "," +
            localAtual.subAdministrativeArea +
            "-" +
            localAtual.administrativeArea);
    _lugares.clear();

    //_lugares = resultadoBusca.results;
    _lugares = _validarLugares(
        resultadoBusca.results, localAtual.subAdministrativeArea);

    //adiciona marcador por marcador no mapa
    for (PlacesSearchResult item in _lugares) {
      _adicionarMarcadoresDeBusca(item);
    }

    //mover camera para cidade
    _irParaLocal(latUsuario, longUsuario, zoom: 8);
  }

  _pesquisarComEndereco(GoogleMapsPlaces places) async {
    PlacesSearchResponse resultadoBusca = await places.searchByText(
        _profissionalController.text +
            "," +
            _bairroController.text +
            "," +
            _cidadeController.text +
            "," +
            _estadoController.text);
    _lugares.clear();

    _lugares = resultadoBusca.results;
    //_lugares = _validarLugares(resultadoBusca.results);

    //adiciona marcador por marcador no mapa
    for (PlacesSearchResult item in _lugares) {
      _adicionarMarcadoresDeBusca(item);
    }

    //mover camera para cidade pesquisada
    List<Placemark> endereco =
    await Geolocator().placemarkFromAddress(_cidadeController.text);
    Placemark local = endereco[0];

    _irParaLocal(local.position.latitude, local.position.longitude, zoom: 5);
  }

  _validarLugares(List<PlacesSearchResult> lugares, String cidade) {
    List<PlacesSearchResult> lugaresValidados = List<PlacesSearchResult>();

    for (PlacesSearchResult item in lugares) {
      //se não for da vidade é removido da lista
      if (item.formattedAddress.contains(cidade) && item.rating != null) {
        lugaresValidados.add(item);
        print("\n" + item.name);
      }
    }

    return lugaresValidados;
  }

  _adicionarMarcadoresDeBusca(PlacesSearchResult lugar) {
    //criando marcador
    Marker marcador = Marker(
        markerId: MarkerId(lugar.id),
        position:
            LatLng(lugar.geometry.location.lat, lugar.geometry.location.lng),
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

  Future<void> _irParaLocal(double lat, double long, {double zoom/*Parâmetro opcional*/}) async {
    if(zoom == null){
      _posicaoCamera = CameraPosition(target: LatLng(lat, long), zoom: 15);
    }else{
      _posicaoCamera = CameraPosition(target: LatLng(lat, long), zoom: zoom);
    }
    _movimentarCamera();
  }

  List<Widget> _criarLista() {
    //instanciando lista de Widgets
    List<Widget> listaDeWidget = [];
    //colocando um container vazio para não dar erro: "lista vazia"
    listaDeWidget.add(
      Container(),
    );

    //adicionando as caixas com insformações dos lugares
    for (PlacesSearchResult item in _lugares) {
      listaDeWidget.add(_caixas(item));
    }
    return listaDeWidget;
  }

  Widget _caixas(PlacesSearchResult item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _irParaLocal(item.geometry.location.lat, item.geometry.location.lng);
        },
        child: Container(
          child: new FittedBox(
            child: Material(
              elevation: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    color: Color(0xff25394e),
                    width: 150,
                    height: 200,
                    child: ClipRRect(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Image.asset("imagens/pinoBranco.png"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Container(
                              child: Text(
                                item.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff1e2e3e),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Container(
                              child: Text(
                                item.formattedAddress,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            child: Text(
                            "Avaliação: " + "lulu",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                              ),
                            ),
                        ),


                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              child: Text(
                                "Avaliação: " + item.rating.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),


                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _habilitarVisibilidade() {
    setState(() {
      if (visibilidade) {
        visibilidade = false;
      } else {
        visibilidade = true;
      }
    });
  }

  @override
  void initState() {
    _adicionarListenerLocalizacao();
    super.initState();
  }

  //////////////////////////////////////////////////////////////////
  //                          APPBAR                              //
  //////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sloc"),
        backgroundColor: Color(0xff1e2e3e),
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
                color: Color(0xff1e2e3e),
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

      //////////////////////////////////////////////////////////////////
      //                            BODY                              //
      //////////////////////////////////////////////////////////////////

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
              padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.white),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
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
          Visibility(
            visible: visibilidade,
            child: Positioned(
              top: 45,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(), color: Colors.white),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
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
          ),
          Visibility(
            visible: visibilidade,
            child: Positioned(
              top: 90,
              left: 0,
              right: 100,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(border: Border.all(), color: Colors.white),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
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
          ),
          Visibility(
            visible: visibilidade,
            child: Positioned(
              top: 90,
              left: 240,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 10, 20),
                child: Container(
                  height: 40,
                  width: 42,
                  decoration:
                      BoxDecoration(border: Border.all(), color: Colors.white),
                  child: TextField(
                    textCapitalization: TextCapitalization.characters,
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
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 150,
              child: ListView(
                  scrollDirection: Axis.horizontal, children: _criarLista()),
            ),
          ),

          Visibility(
            visible: !visibilidade,
            child: Positioned(
              top: 40,
              left: 310,
              right: 0,
              child: IconButton(
                  icon: new Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xff1e2e3e),
                    size: 40,
                  ),
                  onPressed: () {
                    _habilitarVisibilidade();
                  }),
            ),
          ),

          Visibility(
            visible: visibilidade,
            child: Positioned(
              top: 130,
              left: 310,
              right: 0,
              child: IconButton(
                  icon: new Icon(
                    Icons.keyboard_arrow_up,
                    color: Color(0xff1e2e3e),
                    size: 40,
                  ),
                  onPressed: () {
                    _habilitarVisibilidade();
                  }),
            ),
          ),

        ],
      ),

      ////////////////////////////////////////////////

      ////////////////////////////////////////////////

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search, color: Colors.white),
        backgroundColor: Color(0xff1e2e3e),
        onPressed: () {
          _pesquisarProfissional();
        },
      ),
    );
  }
}
