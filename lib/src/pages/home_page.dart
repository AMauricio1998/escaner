import 'dart:io';

import 'direcciones_page.dart';

import 'package:escaner/src/bloc/scans_bloc.dart';
import '../models/scan_model.dart';

import 'package:escaner/src/pages/direcciones_page.dart';
import 'mapas_page.dart';


import 'package:barcode_scan/barcode_scan.dart';

import 'package:escaner/src/utils/utils.dart' as utils;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.delete_forever ),
            onPressed: scansBloc.borrarScanTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.filter_center_focus ),
        onPressed: ()=> _scanQR( context ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {

    // https://fernando-herrera.com
    // geo:40.724233047051705,-74.00731459101564

    // String futureString = '';
    String futureString;

    try {
      // futureString = await new QRCodeReader().scan();
      futureString = await BarcodeScanner.scan();
    } catch(e) {
      futureString = e.toString();
    }

    if ( futureString != null ) {
      
      final scan = ScanModel( valor: futureString );
      scansBloc.agregarScan(scan);      

      if ( Platform.isIOS ) {
        Future.delayed( Duration( milliseconds: 750 ), () {
          utils.abrirScan(context, scan);    
        });
      } else {
        utils.abrirScan(context, scan);
      }

    }
     

  }


  Widget _callPage( int paginaActual ) {

    switch( paginaActual ) {

      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();
    }

  }

  Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index; 
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.brightness_5 ),
          title: Text('Direcciones')
        ),
      ],
    );


  }
}