import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghanatracker/SizeConfig.dart';
import 'dart:ui';
import 'package:ghanatracker/search_widget.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';




class signup extends StatefulWidget {
  final double lg;
  final double lt;
  final String officers;
  final int _selectedIndex;


  signup(this.officers,this.lt,this.lg,this._selectedIndex);

  @override
  State<StatefulWidget> createState() {

    return _signupState(this.officers,this.lt,this.lg,this._selectedIndex);
  }
}

class _signupState extends State<signup> {
  final itemScrollController=ItemScrollController();

  TextEditingController _searchController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  final Key _mapKey = UniqueKey();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }


  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if(_searchController.text != "") {
      for(var tripSnapshot in _allResults){
        var title = Trip.fromSnapshot(tripSnapshot).name.toLowerCase();

        if(title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }

    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('police').get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  final _key = GlobalKey<GoogleMapStateBase>();
  bool stat = false;
  String _mapStyle;

  bool homeactive=true;
  bool historyactive=false;
  bool trackeractive=false;
  bool history=false;
  bool tracker=false;
  bool home=true;
  String gpssearch;
  double lg;
  double lt;
  int _selectedIndex;
  ScrollController _controller1;
  ScrollController _controller2;
  ScrollController _controller3;
  String station;
  _signupState(this.officers,this.lt,this.lg,this._selectedIndex);
  String officers;
  String query = '';
  Timer debouncer;


  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    debouncer?.cancel();
    super.dispose();
  }


  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 100),
      }) {
    if (debouncer != null) {
      debouncer.cancel();
    }

    debouncer = Timer(duration, callback);
  }



  @override
  void initState() {
    //_controller1 = ScrollController();
    //_controller2 = ScrollController();
   // _controller3 = ScrollController();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToIndex(_selectedIndex));
    super.initState();


  }

  @override
  Widget build(BuildContext context){


    return Scaffold(
        appBar: AppBar(

          leading:
             Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage:
                  AssetImage("assets/uk.png"),
                ),
          ),
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _menuItemHome(title: 'Home',isActive: homeactive),
              _menuItemTracker(title: 'Tracker',isActive: trackeractive),
              _menuItemHistory(title: 'History', isActive: historyactive),

            ],
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 27,
                ),
                onPressed: () {
                  scrollToIndex(10);
                  testfirestore();

                })
          ],

          backgroundColor:   Colors.transparent,
          elevation: 0.0,


          centerTitle: true,

        ),

        body:Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              color: Colors.blueGrey.withOpacity(0.3),
              child: Row(
                children: [
                  Container(
                    width: SizeConfig.safeBlockHorizontal*30,
                    child:Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('active').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return new Padding(padding: EdgeInsets.only(right:10,left: 10, bottom: 10),
                              child: SizedBox(
                                height: SizeConfig.safeBlockVertical*90,
                                child: new ScrollablePositionedList.builder(
                                  itemScrollController: itemScrollController,
                                 // scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot doc = snapshot.data.docs[index];


                                    return new Card(
                                        color: _selectedIndex != null && _selectedIndex == index
                                            ? Colors.blueGrey.withOpacity(0.1)
                                            : Colors.white,


                                        child:Padding(padding: EdgeInsets.all(5),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage("assets/user.png"),
                                              ),
                                              SizedBox(width: 5,),
                                              Column(mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("ID: ${doc["id"]}"),
                                                  Text("Long: ${doc["longitude"]}"),
                                                  Text("Lat: ${doc["latitude"]}"),
                                                  Text("D&T: ${doc["dateandtime"]}"),
                                                ],
                                              ),
                                              SizedBox(width: 8,),
                                             Column(children: [
                                               ElevatedButton(onPressed:(){
                                                 setState(() {
                                                   lg = double.parse('${doc["longitude"]}');
                                                   lt = double.parse('${doc["latitude"]}');
                                                   _selectedIndex = index;


                                                 });


                                                 Timer(Duration(milliseconds: 500), () {
                                                   Navigator.of(context).push(new MaterialPageRoute(builder: (context) => signup(officers,lt,lg,_selectedIndex)));
                                                 });

                                               }, child: Text("search")),
                                               SizedBox(height: 10,),

                                               ElevatedButton(onPressed:(){
                                                 DateTime date = DateTime.now();
                                                 FirebaseFirestore.instance.collection("${date.year}-${date.month}-${date.day}").add({
                                                   "id": "${doc["id"]}",
                                                   "latitude": "${doc["latitude"]}",
                                                   "longitude": "${doc["longitude"]}",
                                                   "dateandtime": "${doc["dateandtime"]}"

                                                 });

                                                 FirebaseFirestore.instance.collection("active")
                                                     .where("id", isEqualTo : "${doc["id"]}")
                                                     .get().then((value){
                                                   value.docs.forEach((element) {
                                                     FirebaseFirestore.instance.collection("active").doc(element.id).delete().then((value){
                                                       print("Deleted!");
                                                     });
                                                   });
                                                 });


                                               }, child: Text("clear"),
                                                 style: ElevatedButton.styleFrom(
                                                     primary: Colors.red,
                                                  ))
                                             ],)
                                            ],
                                          ),)
                                    );
                                  },


                                ),
                              ),
                            );
                          } else {
                            return Text("No data");
                          }
                        },
                      ),
                    ),
                    ) ,

                  Padding(padding: EdgeInsets.only(right:10,left: 10, bottom: 10),
                  child:Container(
                    width:  MediaQuery.of(context).size.width /1.48,
                    child:Column(
                      children: [

                        Visibility(child: Column(children: [
                      Container(color: Colors.white,
                      height: SizeConfig.safeBlockVertical*60,
                      child: Padding(padding:  EdgeInsets.all(10),
                        child: Container(color: Colors.blueGrey.withOpacity(0.3),
                          child: GoogleMap(
                            key: _mapKey,
                            markers: {
                              Marker(
                                GeoCoord(lt,lg),
                              ),
                              Marker(
                                GeoCoord(51.53646909647158, -0.4820621839739808),
                                icon: 'assets/pstation.png',
                                info: "looooooooool",
                                onTap: (polygonId) async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'KNUST Police Station!\n d$polygonId',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: (){
                                            Navigator.of(context).pop;
                                            setState(() {
                                              query="KNUST Police Station";
                                              _searchController.text=query;
                                            });
                                            Navigator.of(context, rootNavigator: true).pop();
                                          },
                                          child: Text('search'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              Marker(
                                GeoCoord(6.688847257453242, -1.5646674625748602),
                                icon: 'assets/pstation.png',
                                info: "looooooooool",
                                onTap: (polygonId) async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'KNUST Police Station!\n d$polygonId',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: (){
                                            Navigator.of(context).pop;
                                            setState(() {
                                              query="KNUST Police Station";
                                              _searchController.text=query;
                                            });
                                            Navigator.of(context, rootNavigator: true).pop();
                                           },
                                          child: Text('search'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              Marker(
                                GeoCoord(5.57225583921777, -0.18031893802581284),
                                icon: 'assets/pstation.png',
                                info: "looooooooool",
                                onTap: (polygonId) async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'Cantonments Police Station!\n d$polygonId',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: (){

                                            setState(() {
                                              query="Cantonments Police Station";
                                              _searchController.text=query;
                                            });
                                            Navigator.of(context, rootNavigator: true).pop();
                                          },
                                          child: Text('search'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              Marker(
                                GeoCoord(5.574612404574407, -0.20044566073830683),
                                icon: 'assets/pstation.png',
                                info: "looooooooool",
                                onTap: (polygonId) async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'Nima Police Station!\n d$polygonId',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: (){
                                            setState(() {
                                              query="Nima Police Station";
                                              _searchController.text=query;
                                            });
                                            Navigator.of(context, rootNavigator: true).pop();
                                            },
                                          child: Text('search'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              Marker(
                                GeoCoord(5.6320033467151545, -0.15206379142876708),
                                icon: 'assets/pstation.png',
                                info: "looooooooool",
                                onTap: (polygonId) async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'East Legon Police Station!\n d$polygonId',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: (){
                                            setState(() {
                                              query="East Legon Police Station";
                                              _searchController.text=query;
                                            });
                                            Navigator.of(context, rootNavigator: true).pop();},
                                          child: Text('search'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              Marker(
                                GeoCoord(5.63174082052899, -0.013025816110116073),
                                icon: 'assets/pstation.png',
                                info: "looooooooool",
                                onTap: (polygonId) async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'Tema Comm.2 Police Station!\n d$polygonId',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: (){
                                            setState(() {
                                              query="Tema Comm.2 Police Station";
                                              _searchController.text=query;
                                            });
                                            Navigator.of(context, rootNavigator: true).pop();},
                                          child: Text('search'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              Marker(
                                GeoCoord(5.666134680362117, -0.022674145155236733),
                                icon: 'assets/pstation.png',
                                info: "looooooooool",
                                onTap: (polygonId) async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'Tema Comm.11 Police Station!\n d$polygonId',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: (){
                                            setState(() {
                                              query="Tema Comm.11 Police Station";
                                              _searchController.text=query;
                                            });
                                            Navigator.of(context, rootNavigator: true).pop();},
                                          child: Text('search'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Marker(
                                GeoCoord(5.747328,-0.0023453),
                                icon: 'assets/fservice.png',
                                info: "looooooooool",
                              ),
                              Marker(
                                GeoCoord(5.747328,-0.00453453),
                                icon: 'assets/ambulances.png',
                                info: "looooooooool",
                              ),

                            },
                            initialZoom: 16.7,
                            initialPosition:
                            GeoCoord(lt, lg), // Los Angeles, CA
                            mapType: MapType.roadmap,
                            mapStyle: _mapStyle,
                            interactive: true,
                         /*   onTap: (coord) =>
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(coord?.toString()),
                                  duration: const Duration(seconds: 2),
                                )),
                            mobilePreferences: const MobileMapPreferences(
                              trafficEnabled: true,
                            ),*/
                            webPreferences: WebMapPreferences(
                              fullscreenControl: true,
                              zoomControl: true,
                            ),
                          ),

                        ),),) ,


                          Container(
                            child: Row(
                            children: [


                              Container(color: Colors.blueGrey.withOpacity(0.3),
                                height: MediaQuery.of(context).size.height /3.35,
                                width: MediaQuery.of(context).size.width /2.96,
                                child: Padding(padding: EdgeInsets.only(left: 10,right:10,bottom: 10,top: 4),
                                  child: Column(children: [
                                    Row(

                                      children: [
                                        SizedBox(width: 20,),

                                        Container(child: Text("Police Stations"),
                                        ),
                                        Expanded(child:buildSearch(), )
                                      ],),
                                    SizedBox(height: 4,),
                                    Expanded(child:Container(
                                      color: Colors.white,
                                      height: MediaQuery.of(context).size.height /3.4,
                                      child:  Padding(padding: EdgeInsets.only(right:10,left: 10, bottom: 10),
                                              child: SizedBox(
                                                height: SizeConfig.safeBlockVertical*90,
                                                child: new ListView.builder(
                                                  controller: _controller2,
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: _resultsList.length,
                                                  itemBuilder: (context, index) {
                                                    final trip = Trip.fromSnapshot(_resultsList[index]);

                                                    return new Card(
                                                        child:Padding(padding: EdgeInsets.all(5),
                                                            child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row( mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      backgroundImage: AssetImage("assets/policestation.png"),
                                                                      backgroundColor: Colors.white,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Column(mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(trip.name),
                                                                        Text(trip.gps),

                                                                      ],
                                                                    ),
                                                                    SizedBox(width: 8,),

                                                                  ],
                                                                ),
                                                                ElevatedButton(onPressed:(){
                                                                  setState(() {
                                                                    officers=trip.officers;
                                                                  });
                                                                }, child: Text("Officers"))

                                                              ],


                                                            ) )
                                                    );
                                                  },


                                                ),
                                              ),
                                            ),

                                    ) ),


                                  ],) ,),),




                              Container(color: Colors.blueGrey.withOpacity(0.3),
                                height: MediaQuery.of(context).size.height /3.35,
                                width: MediaQuery.of(context).size.width /2.96,
                                child: Padding(padding: EdgeInsets.only(left: 10,right:10,bottom: 10,top: 11),
                                  child: Column(children: [
                                    Container(child: Text("Police Officers "),
                                    ),

                                    SizedBox(height: 10,),
                                    Expanded(child:Container(
                                      color: Colors.white,
                                      height: MediaQuery.of(context).size.height /3.4,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection(officers).snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return new Padding(padding: EdgeInsets.only(right:10,left: 10, bottom: 10),
                                              child: SizedBox(
                                                height: SizeConfig.safeBlockVertical*90,
                                                child: new ListView.builder(
                                                  controller: _controller3,
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: snapshot.data.docs.length,
                                                  itemBuilder: (context, index) {
                                                    DocumentSnapshot doc = snapshot.data.docs[index];

                                                    return new Card(
                                                        child:Padding(padding: EdgeInsets.all(5),
                                                            child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row( mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      backgroundImage: AssetImage("assets/police.png"),
                                                                      backgroundColor: Colors.white,
                                                                    ),
                                                                    SizedBox(width: 5,),
                                                                    Column(mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text("${doc["name"]}"),
                                                                        Text("status: ${doc["status"]}"),

                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                                ElevatedButton(style: ElevatedButton.styleFrom(
                                                                    primary: Colors.red),
                                                                    onPressed:(){

                                                                }, child: Text("Assign"))

                                                              ],


                                                            ) )
                                                    );
                                                  },


                                                ),
                                              ),
                                            );
                                          } else {
                                            return Text("No data");
                                          }
                                        },
                                      ),
                                    ) ),



                                  ],) ,),),
                            ],

                          ),)

                        ],),
                        visible: home,),

                        Visibility(child: Container(child: Expanded(
                          child: new StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('active').snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return new Padding(padding: EdgeInsets.only(right:10,left: 10, bottom: 10),
                                  child: SizedBox(
                                    height: SizeConfig.safeBlockVertical*60,
                                    child: new GridView.builder(
                                      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 380,
                                          childAspectRatio: 6 / 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                      controller: _controller1,
                                      // scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot doc = snapshot.data.docs[index];


                                        return new Card(
                                            color: _selectedIndex != null && _selectedIndex == index
                                                ? Colors.blueGrey.withOpacity(0.1)
                                                : Colors.white,


                                            child:new Padding(padding: EdgeInsets.all(5),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage("assets/user.png"),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Column(mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("ID: ${doc["id"]}"),
                                                      Text("Long: ${doc["longitude"]}"),
                                                      Text("Lat: ${doc["latitude"]}"),
                                                      Text("D&T: ${doc["dateandtime"]}"),
                                                    ],
                                                  ),
                                                  SizedBox(width: 8,),
                                                  ElevatedButton(onPressed:(){
                                                    setState(() {
                                                      lg = double.parse('${doc["longitude"]}');
                                                      lt = double.parse('${doc["latitude"]}');
                                                      _selectedIndex = index;


                                                    });

                                                    Timer(Duration(milliseconds: 500), () {
                                                      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => signup(officers,lt,lg,_selectedIndex)));
                                                    });

                                                  }, child: Text("search"))
                                                ],
                                              ),)
                                        );
                                      },


                                    ),
                                  ),
                                );
                              } else {
                                return Text("No data");
                              }
                            },
                          ),
                        ),),
                        visible: history,),

                        Visibility(child: Container(),
                          visible: tracker,),
                      ],
                    ) ,
                  ) ,)
                  ,
                ],
              ),

            ),







          ],
        ),



    );

  }


  Widget _menuItemHome({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 35),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap:(){
            setState(() {
              home=true;
              tracker=false;
              history= false;
              homeactive=true;
              trackeractive=false;
              historyactive=false;

            });
          }
          ,

          child: Column(
            children: [
              Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.deepPurple : Colors.grey,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              isActive
                  ? Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30),
                ),
              )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
  Widget _menuItemTracker({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 35),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap:(){
            setState(() {
              home=false;
              tracker=true;
              history= false;
              homeactive=false;
              trackeractive=true;
              historyactive=false;

            });
          }
          ,

          child: Column(
            children: [
              Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.deepPurple : Colors.grey,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              isActive
                  ? Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30),
                ),
              )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
  Widget _menuItemHistory({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 35),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap:(){
            setState(() {
              home=false;
              tracker=false;
              history= true;
              homeactive=false;
              trackeractive=false;
              historyactive=true;

            });
          }
          ,

          child: Column(
            children: [
              Text(
                '$title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.deepPurple : Colors.grey,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              isActive
                  ? Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30),
                ),
              )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
  void testfirestore(){
    DateTime date = DateTime.now();
    FirebaseFirestore.instance.collection("active").doc("id1").set({
      "id": "GHA-002409363-7",
      "latitude": "51.53081839454341",
      "longitude": "-0.4797315078322359",
      "dateandtime": "${date.year}-${date.month}-${date.day}_${date.hour}:${date.minute}"

    });
  }




  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: "search station name",
    onChanged: searchBook,
    controller: _searchController,
  );

  Future searchBook(String query) async => debounce(() async {

    if (!mounted) return;

    setState(() {
      _searchController.text;
      this.query = query;
      //this.books = books;
    });
  });

  void scrollToIndex(int index) => itemScrollController.jumpTo(index: index);






}

