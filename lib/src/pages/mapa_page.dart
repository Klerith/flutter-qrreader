import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';


import 'package:qrreaderapp/src/models/scan_model.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante( context ),
    );
  }

  Widget _crearBotonFlotante(BuildContext context ) {

    return FloatingActionButton(
      child: Icon( Icons.repeat ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {

        // streets, dark, light, outdoors, satellite
        if ( tipoMapa == 'streets' ) {
          tipoMapa = 'dark';
        } else if ( tipoMapa == 'dark' ) {
          tipoMapa = 'light';
        } else if ( tipoMapa == 'light' ) {
          tipoMapa = 'outdoors';
        } else if ( tipoMapa == 'outdoors' ) {
          tipoMapa = 'satellite';
        } else {
          tipoMapa = 'streets';
        }

        setState((){});

      },
    );

  }

  Widget _crearFlutterMap( ScanModel scan ) {

    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores( scan )
      ],
    );

  }

  _crearMapa() {

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1Ijoia2xlcml0aCIsImEiOiJjanY2MjF4NGIwMG9nM3lvMnN3ZDM1dWE5In0.0SfmUpbW6UFj7ZnRdRyNAw',
        'id': 'mapbox.$tipoMapa' 
        // streets, dark, light, outdoors, satellite
      }
    );
  }

  _crearMarcadores( ScanModel scan ) {

    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: ( context ) => Container(
            child: Icon( 
              Icons.location_on, 
              size: 70.0,
              color: Theme.of(context).primaryColor,
              ),
          )
        )
      ]
    );

  }
}
