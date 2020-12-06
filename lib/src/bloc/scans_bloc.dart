

import 'dart:async';

import 'package:escaner/src/models/scan_model.dart';
import 'package:escaner/src/providers/db_provider.dart';

class ScansBloc{

static final ScansBloc _singleton = new ScansBloc._internal();

factory ScansBloc() {

   return _singleton;
} 

ScansBloc._internal(){
    //ontener sacns base de datos
    obtenerScans();

}


final _scansController = StreamController<List<ScanModel>>.broadcast();
Stream<List<ScanModel>> get scansStream => _scansController.stream;


dispose(){
  _scansController?.close();
}

agregarScan(ScanModel scan) async{
await   DBProvider.db.nuevoScan(scan);
  obtenerScans();
  }

 obtenerScans() async {
_scansController.sink.add( await  DBProvider.db.getTodosScans() );

 }
 borrarScans(int id ) async{
DBProvider.db.deleteScan(id);
 obtenerScans();

 }

 borrarScansTODOS() async {
DBProvider.db.deleteAll();
 obtenerScans();
 }



}