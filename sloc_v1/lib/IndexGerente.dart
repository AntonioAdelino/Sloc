import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:Sloc/controladores/RotaControlador.dart';
import 'package:Sloc/dados/dbProfissional.dart';
import 'package:Sloc/entidades/profissional.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

import 'dados/dbGerente.dart';
import 'entidades/gerente.dart';

class IndexGerente extends StatefulWidget {
  @override
  _IndexGerenteState createState() => _IndexGerenteState();
}

class _IndexGerenteState extends State<IndexGerente> {
  //////////////////////////////////////////////////////////////////
  //                          ATRIBUTOS                           //
  //////////////////////////////////////////////////////////////////

  //Atributos constantes
  String KEY_GOOGLE_API = "AIzaSyDwxSkolZisErTZW5eI8pm6veaCiEgxZ8w";

  //Atributos Maps
  Completer<GoogleMapController> _controllerMap = Completer();
  Set<Marker> _marcadores = {};
  Set<Polyline> _polylines = {};
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-15.7991564, -47.8606298), zoom: 0);
  double latUsuario, longUsuario, latSeguinte, longSeguinte;
  Set<Circle> _circles = HashSet<Circle>();

  //Atributos seleção
  List<PlacesSearchResult> _lugares = [];
  List<bool> _controleDeSelecao = [];
  List<bool> _controleDeSelecaoBusca = [];
  List<String> _listaDeContatos = [];

  //Atributos TextField
  TextEditingController _profissionalController = TextEditingController();
  TextEditingController _bairroController = TextEditingController();
  TextEditingController _cidadeController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();

  //Atributo flag de visibilidade de componentes
  bool _visibilidade = false;
  bool _visibilidadeRota = false;
  bool _visibilidadeIr = false;

  //Atributo banco
  DbProfissional dbProfissional = new DbProfissional();

  //Atributo de rota
  List<LatLng> polylineCoordinates =
      []; //isso manterá cada coordenada de polilinha como pares Lat e Lng
  Map<PolylineId, Polyline> polylines = {}; //contem as polilinhas geradas
  poly.PolylinePoints polylinePoints =
      poly.PolylinePoints(); // que gera cada polilinha entre o início e o fim

  //Atributos controlador
  RotaControlador visitaControlador = RotaControlador();

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
        latUsuario = position.latitude;
        longUsuario = position.longitude;
        _posicaoCamera =
            CameraPosition(target: LatLng(latUsuario, longUsuario), zoom: 1);
        _movimentarCamera();
      });
    });
  }

  _pesquisarProfissional() async {
    //limpar marcadores
    _marcadores.clear();
    //pesquisa o profissional por area
    GoogleMapsPlaces places = new GoogleMapsPlaces(apiKey: KEY_GOOGLE_API);

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
    _irParaLocal(latUsuario, longUsuario, zoom: 1);
  }

  Future<String> pegarNumero(PlacesSearchResult item) async {
    //faz consulta web
    var response = await http.get(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=" +
            item.placeId +
            "&fields=formatted_phone_number&key=" +
            KEY_GOOGLE_API);
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
    String cidade = _cidadeController.text + "-" + _estadoController.text;
    List<Placemark> endereco = await Geolocator().placemarkFromAddress(cidade);
    Placemark local = endereco[0];
    _irParaLocal(local.position.latitude, local.position.longitude, zoom: 1);
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
      markerId: MarkerId(lugar.placeId),
      position:
          LatLng(lugar.geometry.location.lat, lugar.geometry.location.lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: lugar.name),
    );
    //adicionando no mapa
    setState(() {
      _marcadores.add(marcador);
    });
  }

  _adicionarMarcadoresDePesquisa(List profissionais) {
    _marcadores.clear();
    //ImageConfiguration configuration = ImageConfiguration(size: Size(1, 1));
    Marker marcador = Marker(
      markerId: MarkerId("inicio"),
      position: LatLng(latUsuario, longUsuario),
      //icon: await BitmapDescriptor.fromAssetImage(configuration, "imagens/pino.png"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      //.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(title: "Local de Início"),
    );
    //adicionando no mapa
    setState(() {
      _marcadores.add(marcador);
    });

    for (int i = 0; i < profissionais.length; i++) {
      //instanciando lat long
      double latitude = double.parse(profissionais[i][1].latitude);
      double longitude = double.parse(profissionais[i][1].longitude);

      //instanciando marcador
      Marker marcador = Marker(
        markerId: MarkerId(profissionais[i][1].nome),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: profissionais[i][1].nome),
      );
      //adicionando no mapa
      setState(() {
        _marcadores.add(marcador);
      });
    }
  }

  Future<void> _irParaLocal(double lat, double long,
      {double zoom /*Parâmetro opcional*/
      }) async {
    if (zoom == null) {
      _posicaoCamera = CameraPosition(target: LatLng(lat, long), zoom: 5);
      _movimentarCamera();
    } else {
      _posicaoCamera = CameraPosition(target: LatLng(lat, long), zoom: zoom);
      _movimentarCamera();
    }
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

  _inicializarListaDeContatos(int quantidadeDeItens) {
    var controle = 0;
    if (quantidadeDeItens != _listaDeContatos.length) {
      _listaDeContatos.clear();
      while (controle < quantidadeDeItens) {
        _listaDeContatos.add(null);
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
      }
    });
  }

  List<Widget> _criarLista() {
    //iniciando lista de seleção
    _inicializarListaDeSelecao(_lugares.length);
    _inicializarListaDeSelecaoBusca(_lugares.length);
    _inicializarListaDeContatos(_lugares.length);
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                )
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add_circle, color: Colors.white),
                                Text(
                                  "Adicionar para visita",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                      onPressed: () {
                        _marcarOuDesmarcarCardBusca(i);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _marcarOuDesmarcarCard(i);
                      _irParaLocal(item.geometry.location.lat,
                          item.geometry.location.lng);
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
                                      _listaDeContatos[i] = numero.data;
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

  _habilitarVisibilidadeIr() {
    setState(() {
      if (!_visibilidadeIr) {
        _visibilidadeIr = true;
      }
    });
  }

  _getPolyline() async {
    //pegar distancia
    List distancias = await _pegarDistancias();
    //limpar marcadores
    _adicionarMarcadoresDePesquisa(distancias);
    //iniciar controlador de loop
    int controladorLoop = distancias.length;

    //variaveis de controle de lat e long
    double latA, longA, latB, longB;
    List anterior = [0, 0];

    for (int i = 0; i < controladorLoop; i++) {
      //controla o acesso a localização
      //se for a primeira então o primeiro ponto é o usuário
      //senão primeiro ponto é o ponto anterior
      if (i == 0) {
        latA = latUsuario;
        longA = longUsuario;
        List menorDistancia = _pegarMenorDistancia(distancias);
        latB = double.parse(menorDistancia[1].latitude);
        longB = double.parse(menorDistancia[1].longitude);
        anterior[0] = double.parse(menorDistancia[1].latitude);
        anterior[1] = double.parse(menorDistancia[1].longitude);
      } else {
        latA = anterior[0];
        longA = anterior[1];
        List menorDistancia = _pegarMenorDistancia(distancias);
        latB = double.parse(menorDistancia[1].latitude);
        longB = double.parse(menorDistancia[1].longitude);
        anterior[0] = double.parse(menorDistancia[1].latitude);
        anterior[1] = double.parse(menorDistancia[1].longitude);
      }

      //faz a busca no google pela rota
      poly.PolylineResult result =
          await polylinePoints.getRouteBetweenCoordinates(
        KEY_GOOGLE_API,
        poly.PointLatLng(latA, longA),
        poly.PointLatLng(latB, longB),
        travelMode: poly.TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((poly.PointLatLng point) {
          //traça os pontos da rota
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          //desenha a rota no mapa
          _addPolyLine();
        });
      }
    }
  }

  _addPolyLine() {
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("rota"),
          color: Color(0xff1e2e3e),
          width: 6,
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  _pegarDistancias() async {
    List distancias = [];

    for (int i = 0; i < _controleDeSelecaoBusca.length; i++) {
      if (_controleDeSelecaoBusca[i] == true) {
        double latitude = _lugares[i].geometry.location.lat;
        double longitude = _lugares[i].geometry.location.lng;

        double distancia = await Geolocator().distanceBetween(
          latUsuario,
          longUsuario,
          latitude,
          longitude,
        );

        String idPlace = _lugares[i].placeId;
        String nome = _lugares[i].name;
        String endereco =
            _lugares[i].formattedAddress.split(", Brazil")[0] + ".";
        String contato = _listaDeContatos[i];
        String avaliacao = _lugares[i].rating.toString() + "/5";
        String latitudeString = latitude.toString();
        String longitudeString = longitude.toString();

        Profissional profissional = Profissional(idPlace, nome, endereco,
            contato, avaliacao, latitudeString, longitudeString);
        distancias.add([distancia, profissional]);
      }
    }
    return distancias;
  }

  _pegarMenorDistancia(distancias) {
    List menor = distancias[0];
    for (int i = 0; i < distancias.length; i++) {
      if (menor[0] > distancias[i][0]) {
        menor = distancias[i];
      }
    }

    for (int i = 0; i < distancias.length; i++) {
      if (menor[1].nome == distancias[i][1].nome) {
        distancias.removeAt(i);
      }
    }

    return menor;
  }

  void _navegarParaTela(Object objeto, String rota) {
    Navigator.pushNamed(context, rota, arguments: {"objeto": objeto});
  }

  void _sair() {
    DbGerente dbGerente = DbGerente();
    dbGerente.deletarGerentes();
    Navigator.pushReplacementNamed(context, "/Login");
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
    Map objeto = ModalRoute.of(context).settings.arguments;
    Gerente gerente = objeto["objeto"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1e2e3e),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sloc",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Gerente",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(gerente.nome,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              accountEmail: Text(gerente.email, style: TextStyle(fontSize: 14)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  gerente.nome[0],
                  style: TextStyle(fontSize: 40.0, color: Color(0xff1e2e3e)),
                ),
              ),
            ),
            ListTile(
              leading:
                  Icon(Icons.person_add_alt_1_sharp, color: Color(0xff1e2e3e)),
              title: Text(
                'Cadastrar novo vendedor',
                style: TextStyle(fontSize: 14, color: Color(0xff1e2e3e)),
              ),
              onTap: () {
                _navegarParaTela(gerente, "/CadastroVendedor");
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.person_search_sharp, color: Color(0xff1e2e3e)),
              title: Text(
                'Procurar vendedor',
                style: TextStyle(fontSize: 14, color: Color(0xff1e2e3e)),
              ),
              onTap: () {
                _navegarParaTela(gerente, "/BuscarVendedor");
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment, color: Color(0xff1e2e3e)),
              title: Text(
                'Ver relatório de vendedor',
                style: TextStyle(fontSize: 14, color: Color(0xff1e2e3e)),
              ),
              onTap: () {
                _navegarParaTela(gerente, "/TelaDeRelatorioDeVendedores");
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xff1e2e3e)),
              title: Text(
                'Sair',
                style: TextStyle(fontSize: 14, color: Color(0xff1e2e3e)),
              ),
              onTap: () {
                _sair();
              },
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
              circles: _circles,
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
                  onTap: () {
                    _polylines.clear();
                    _controleDeSelecao.clear();
                    _controleDeSelecaoBusca.clear();
                    _lugares.clear();
                    _marcadores.clear();
                  },
                  onSubmitted: (String str) {
                    if (_visibilidade == false) {
                      _pesquisarProfissional();
                      _habilitarVisibilidadeRota();
                    }
                  },
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
                    onSubmitted: (String str) {
                      if (_visibilidade == true) {
                        _controleDeSelecao.clear();
                        _controleDeSelecaoBusca.clear();
                        _pesquisarProfissional();
                        _habilitarVisibilidadeRota();
                      }
                    },
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
              left: 0,
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
              left: 0,
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
        ],
      ),

      ////////////////////////////////////////////////

      ////////////////////////////////////////////////

      floatingActionButton: Visibility(
        visible: (_visibilidadeRota && !_visibilidade),
        child: FloatingActionButton(
          child: Icon(Icons.directions, color: Colors.white),
          backgroundColor: Color(0xff1e2e3e),
          onPressed: () {
            //_instanciarProfissionais();
            polylineCoordinates.clear();
            _polylines.clear();
            _circles.clear();
            _getPolyline();
            _habilitarVisibilidadeIr();
          },
        ),
      ),
    );
  }
}
