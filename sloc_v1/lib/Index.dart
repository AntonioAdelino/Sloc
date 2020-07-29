import 'dart:convert';
import 'package:Sloc/dados/dbProfissional.dart';
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
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;

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
  Set <Polyline> _polylines = {};
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-0.000000, -0.000000), zoom: 8);
  double latUsuario, longUsuario;
  double latTG;
  double lonTG;
  double lat2 = -7.691178;
  double lon2 = -35.510659;

  //Atributos seleção
  List<PlacesSearchResult> _lugares = [];
  List<bool> _controleDeSelecao = [];
  List<bool> _controleDeSelecaoBusca = [];

  //Atributos TextField
  TextEditingController _profissionalController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _cidadeController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();

  //Atributo flag de visibilidade de componentes
  bool _visibilidade = false;
  bool _visibilidadeRota = false;

  //Atributo banco
  DbProfissional dbProfissional = new DbProfissional();

  //Atributo de rota
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  poly.PolylinePoints polylinePoints = poly.PolylinePoints();

  //////////////////////////////////////////////////////////////////
  //                         MÉTODOS                              //
  //////////////////////////////////////////////////////////////////

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

    if (!_visibilidade) {
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

  Future<String> pegarNumero(PlacesSearchResult item) async {
    //faz consulta web
    var response = await http.get(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=" +
            item.placeId +
            "&fields=formatted_phone_number&key=AIzaSyACKuQtJ1jP69DM4P_9V1B5s8sRXzvQZf4");
    //trata Json e retorna apenas o numero
    String numero = transformarJsonEmNum(json.decode(response.body));
    return numero;
  }

  verificarHorariodeFuncionamento(PlacesSearchResult item) {
    if (item.openingHours != null) {
      bool horario = item.openingHours.openNow;
      if (horario == null) {
        return "Não consta!";
      } else if (horario) {
        return "Sim";
      } else {
        return "Não";
      }
    }
    return "Não consta!";
  }

  transformarJsonEmNum(Map<String, dynamic> json) {
    String numero;
    //transforma o map em list
    var list = json.values.toList();

    //verifica se a lista está vazia
    if (list.length == 3 && list != null) {
      //verifica se existe o numero de contato
      if (list[1].length != 0) {
        numero = list[1].values.toList()[0].toString();
        return numero;
      }
    }
    return "Não consta!";
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

  Future<void> _irParaLocal(double lat, double long,
      {double zoom /*Parâmetro opcional*/}) async {
    if (zoom == null) {
      _posicaoCamera = CameraPosition(target: LatLng(lat, long), zoom: 15);
    } else {
      _posicaoCamera = CameraPosition(target: LatLng(lat, long), zoom: zoom);
    }
    _movimentarCamera();
  }

  _inicializarListaDeSelecao(int quantidadeDeItens) {
    var controle = 0;
    if (quantidadeDeItens != _controleDeSelecao.length) {
      while (controle < quantidadeDeItens) {
        _controleDeSelecao.add(false);
        controle++;
      }
      _controleDeSelecao.removeRange(controle, _controleDeSelecao.length);
    }
  }

  _marcarOuDesmarcarCard(int indice) {
    bool estado = _controleDeSelecao[indice];
    int quantidadeDeItens = _lugares.length;
    //limpando lista
    _controleDeSelecao.clear();
    _inicializarListaDeSelecao(quantidadeDeItens);
    //marcando ou desmarcando o elemento selecionado
    setState(() {
      if (estado == true) {
        _controleDeSelecao[indice] = false;
      } else {
        _controleDeSelecao[indice] = true;
      }
    });
  }

  _inicializarListaDeSelecaoBusca(int quantidadeDeItens) {
    var controle = 0;
    if (quantidadeDeItens != _controleDeSelecaoBusca.length) {
      _controleDeSelecaoBusca.clear();
      while (controle < quantidadeDeItens) {
        _controleDeSelecaoBusca.add(false);
        controle++;
      }
    }
  }

  _marcarOuDesmarcarCardBusca(int indice) {
    bool estado = _controleDeSelecaoBusca[indice];
    //marcando ou desmarcando o elemento selecionado
    setState(() {
      if (estado == true) {
        _controleDeSelecaoBusca[indice] = false;
      } else {
        _controleDeSelecaoBusca[indice] = true;
        latTG = _lugares[indice].geometry.location.lat;
        lonTG =  _lugares[indice].geometry.location.lng;
      }
    });
  }

  List<Widget> _criarLista() {
    //iniciando lista de seleção
    _inicializarListaDeSelecao(_lugares.length);
    _inicializarListaDeSelecaoBusca(_lugares.length);
    //instanciando cards
    List<Widget> listaDeWidget = List.generate(_lugares.length, (i) {
      var item = _lugares[i];
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          child: new FittedBox(
            child: Material(
              elevation: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    color: _controleDeSelecaoBusca[i]
                        ? Colors.green
                        : Color(0xff25394e),
                    width: 100,
                    height: 215,
                    child: FlatButton(
                      child: _controleDeSelecaoBusca[i]
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.check_circle, color: Colors.white),
                                Text(
                                  "Adicionado",
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                )
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add_circle, color: Colors.white),
                                Text(
                                  "Adicionar",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                      onPressed: () {
                        _marcarOuDesmarcarCardBusca(i);
//                        latTG = item.geometry.location.lat;
//                        lonTG = item.geometry.location.lng;

                        },
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () {
                      //print("oi! "+item.name);

                    },
                    onTap: () {
                      _marcarOuDesmarcarCard(i);
                      _irParaLocal(item.geometry.location.lat,
                          item.geometry.location.lng);
                      //print(_controleDeSelecao);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: _controleDeSelecao[i]
                            ? Border.all(color: Color(0xff1e2e3e), width: 2)
                            : Border.all(color: Colors.transparent),
                      ),
                      width: 250,
                      height: 215,
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3, 3, 3, 16),
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
                              padding: const EdgeInsets.fromLTRB(3, 0, 3, 5),
                              child: Container(
                                child: Text(
                                  item.formattedAddress.split(", Brazil")[0] +
                                      ".",
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
                                child: FutureBuilder(
                                  future: pegarNumero(item),
                                  builder: (context, numero) {
                                    if (numero.hasData) {
                                      return Text(
                                        "Contato: " + numero.data,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      return Text(
                                        "Contato: Carregando...",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                child: Text(
                                  "Aberto agora: " +
                                      verificarHorariodeFuncionamento(item),
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
                                  "Avaliação: " + item.rating.toString() + "/5",
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
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    return listaDeWidget;
  }

  _habilitarVisibilidade() {
    setState(() {
      if (_visibilidade) {
        _visibilidade = false;
      } else {
        _visibilidade = true;
      }
    });
  }
  _habilitarVisibilidadeRota() {
    setState(() {
      if (!_visibilidadeRota) {
        _visibilidadeRota = true;
      }
    });
  }

  _getPolyline() async {
    poly.PolylineResult result = await polylinePoints
        .getRouteBetweenCoordinates(
        "AIzaSyACKuQtJ1jP69DM4P_9V1B5s8sRXzvQZf4",
        poly.PointLatLng(latUsuario, longUsuario),
        //poly.PointLatLng(lat2, lon2),
        poly.PointLatLng(latTG, lonTG),
        travelMode: poly.TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((poly.PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        
      });
    }
    _addPolyLine();

  }

  _addPolyLine() {
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("rota"),
          color: Color(0xff1e2e3e),
          width: 6,
          points: polylineCoordinates
      );
      _polylines.add(polyline);

    });

  }

//  _pegarMenorDistancia() async {
//
//    double distancia = await Geolocator().distanceBetween(
//      startCoordinates.latitude,
//      startCoordinates.longitude,
//      destinationCoordinates.latitude,
//      destinationCoordinates.longitude,
//    );
//  }

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
              polylines: _polylines,
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
            visible: _visibilidade,
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
            visible: _visibilidade,
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
            visible: _visibilidade,
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
              margin: EdgeInsets.symmetric(vertical: 40),
              height: 150,
              child: ListView(
                  scrollDirection: Axis.horizontal, children: _criarLista()),
            ),
          ),
          Visibility(
            visible: !_visibilidade,
            child: Positioned(
              top: 40,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: new Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xff1e2e3e),
                        size: 40,
                      ),
                      onPressed: () {
                        _habilitarVisibilidade();
                      }),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _visibilidade,
            child: Positioned(
              top: 130,
              //left: 310,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: new Icon(
                        Icons.keyboard_arrow_up,
                        color: Color(0xff1e2e3e),
                        size: 40,
                      ),
                      onPressed: () {
                        _habilitarVisibilidade();
                      }),
                ],
              ),
            ),
          ),

          Visibility(
            visible: _visibilidadeRota,
            child: Positioned(
              top: 300,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: new Icon(
                        Icons.directions,
                        color: Color(0xff1e2e3e),
                        size: 40,
                      ),
                      onPressed: () {
                        //fazer o desenho da rota
                        polylineCoordinates.clear();
                        _polylines.clear();
                        _getPolyline();
                      }),
                  Text("\t\tRota",
                    style: TextStyle(color: Color(0xff1e2e3e), fontWeight: FontWeight.bold, fontSize: 14),
                  )
                ],
              ),
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
          _controleDeSelecao.clear();
          _controleDeSelecaoBusca.clear();
          _pesquisarProfissional();
          _habilitarVisibilidadeRota();
        },
      ),
    );
  }
}
