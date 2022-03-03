import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart';
class getmap extends StatefulWidget {
  final double lg;
  final double lt;

  getmap(this. lt, this.lg);

  @override
  State<StatefulWidget> createState() {

    return getmapState(this.lt, this.lg);
  }
}

class getmapState extends State<getmap> {
 double lt,lg;

  getmapState(this.lt, this.lg);
  Widget build(BuildContext context) {


  //A unique id to name the div element
  String htmlId = "6";
  //creates a webview in dart
  //ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final latLang = LatLng(widget.lt,widget.lg);

    //class to create a div element

    final mapOptions = MapOptions()
      ..zoom = 11
      ..tilt = 90
      ..center = latLang;
    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = "none";

    final map = GMap(elem, mapOptions);
    Marker(MarkerOptions()
      ..position = latLang
      ..map = map
      ..title = 'My position');

  /*  Marker(MarkerOptions()
      ..position = LatLng(5.946957921437299,0.005786032571075289)
      ..map = map
      ..icon=FontAwesomeIcons.infoCircle
      ..title = 'My position');
    Marker(MarkerOptions()
      ..position = LatLng(5.946957921437299,0.0105786032571075289)
      ..map = map
      ..icon=FontAwesomeIcons.cog
      ..title = 'My posit');*/

    return elem;
  });
  //creates a platform view for Flutter Web
  return HtmlElementView(
    viewType: htmlId,
  );
}}