import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ghanatracker/SizeConfig.dart';
import 'package:ghanatracker/signup.dart';
import 'package:google_fonts/google_fonts.dart';





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'Flutter Login Web',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  int _state = 0;
  bool fire=false;
  bool ambulance=false;
  bool police=false;
  bool vis=true;
  bool gpactive=false;
  bool ambactive=false;
  bool fireactive=false;
  bool adminactive=true;
  bool isLoading = true;
  bool ishidden=true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  getData() async {
    setState(() {
      isLoading = false;
    });
  }
  void main() async {
    await Firebase.initializeApp();
  }
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),

      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: [
      Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _menuItempolice(title: 'Ghana Police',isActive: gpactive),
              _menuItemfire(title: 'Fire Service',isActive: fireactive),
              _menuItemambulance(title: 'Ambulance', isActive: ambactive),
              _menuItemadmin(title: 'Administration',isActive: adminactive),
            ],
          ),
          Row(
            children: [
             _registerButton(),
            ],
          ),
        ],
      ),
    ),
          // MediaQuery.of(context).size.width >= 980
          //     ? Menu()
          //     : SizedBox(), // Responsive
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.safeBlockHorizontal*50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: SizeConfig.safeBlockVertical*40,
                      width: SizeConfig.safeBlockHorizontal*40,
                      child: Image.asset("assets/uk1.png"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "             United Kingdom",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w800,fontSize: 30,),textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                  ],
                ),
              ),
              Visibility(child:Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 4),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal*25,
                  child: _formLogin1(),
                ),
              ),
                visible: vis,),


              Visibility(child:Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 4),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal*25,
                  child: _formLogin2(),
                ),
              ),
                visible: fire,),


              Visibility(child:Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 4),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal*25,
                  child: _formLogin3(),
                ),
              ),
                visible: ambulance,),


              Visibility(child:Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 4),
                child: Container(
                  width: SizeConfig.safeBlockHorizontal*25,
                  child: _formLogin4(),
                ),
              ),
                visible: police,)
            ],
          )
        ],
      ),
    );
  }

  Widget _formLogin1() {

    return Column(
      children: [
        TextField(
          controller: username,
          decoration: InputDecoration(
            hintText: 'Enter username',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextField(
          controller: password,
          obscureText: ishidden,
          decoration: InputDecoration(
            hintText: 'Password',
            counterText: 'Forgot password?',
            suffixIcon: InkWell(
              onTap: _toggleview,
              child: Icon(Icons.visibility),
            ),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple[100],
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            child: Container(
                width: double.infinity,
                height: 50,
                child: Center(child: save1())),
            onPressed: (){
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => signup(" ",0,0,0),
                  transitionDuration: Duration(seconds: 0),
                ),);

              },
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Row(children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Or continue with"),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              height: 1,
            ),
          ),
        ]),
      ],
    );
  }

  Widget _formLogin2() {


    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter username',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextField(
          obscureText: ishidden,
          decoration: InputDecoration(
            hintText: 'Password',
            counterText: 'Forgot password?',
            suffixIcon: InkWell(
              onTap: _toggleview,
              child: Icon(Icons.visibility),
            ),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple[100],
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            child: Container(
                width: double.infinity,
                height: 50,
                child: Center(child: save2())),
            onPressed: (){

              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => signup(" ",0,0,0),
                  transitionDuration: Duration(seconds: 0),
                ),);

              },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Row(children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Or continue with"),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              height: 1,
            ),
          ),
        ]),
      ],
    );
  }
  Widget _formLogin3() {

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter username',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextField(
          obscureText: ishidden,
          decoration: InputDecoration(
            hintText: 'Password',
            counterText: 'Forgot password?',
            suffixIcon: InkWell(
              onTap: _toggleview,
              child: Icon(Icons.visibility),
            ),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple[100],
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            child: Container(
                width: double.infinity,
                height: 50,
                child: Center(child: save3())),
            onPressed: (){

              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => signup(" ",0,0,0),
                  transitionDuration: Duration(seconds: 0),
                ),);

              },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Row(children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Or continue with"),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              height: 1,
            ),
          ),
        ]),
      ],
    );
  }

  Widget _formLogin4() {

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter username',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextField(
          obscureText: ishidden,
          decoration: InputDecoration(
            hintText: 'Password',
            counterText: 'Forgot password?',
            suffixIcon: InkWell(
              onTap: _toggleview,
              child: Icon(Icons.visibility),
            ),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple[100],
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            child: Container(
                width: double.infinity,
                height: 50,
                child: Center(child: save4())),
            onPressed: (){
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => signup(" ",0,0,0),
                  transitionDuration: Duration(seconds: 0),
                ),);

              /*animateButton();
              gp.child("${username.text}/password").once().then((DataSnapshot data2){
                setState(() {

                  if(data2.value == password.text){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => signup(),
                        transitionDuration: Duration(seconds: 0),
                      ),);


                  }else{
                    wrongid();

                  }});});*/},
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Row(children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Or continue with"),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey[400],
              height: 1,
            ),
          ),
        ]),
      ],
    );
  }

  Widget _menuItempolice({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 35),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap:(){
            setState(() {
             gpactive=true;
             police=true;//
             fire=false;
             ambulance=false;
             vis=false;
             ambactive=false;
             fireactive=false;
             adminactive=false;// it gives the value which is selected
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
  Widget _menuItemfire({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 35),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap:(){
            setState(() {
              fireactive=true;
              fire=true;
              ambulance=false;
              police=false;
              vis=false;
              gpactive=false;
              ambactive=false;
              adminactive=false;//// it gives the value which is selected
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
  Widget _menuItemambulance({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 35),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap:(){
            setState(() {
              ambactive=true;
              ambulance=true;// it
              fire=false;
              police=false;
              vis=false;
              gpactive=false;
              fireactive=false;
              adminactive=false;//// gives the value which is selected
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
  Widget _menuItemadmin({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 35),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap:(){
            setState(() {
              adminactive=true;
              vis=true;
              fire=false;
              ambulance=false;
              police=false;
              gpactive=false;
              ambactive=false;
              fireactive=false;
            //// it gives the value which is selected
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

  Widget _registerButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            spreadRadius: 10,
            blurRadius: 12,
          ),
        ],
      ),
      child: Text(
        'Register',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget save1() {
    if (_state == 0) {
      return new Text("Sign In");
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Widget save2() {
    if (_state == 0) {
      return new Text("Sign In");
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Widget save3() {
    if (_state == 0) {
      return new Text("Sign In");
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Widget save4() {
    if (_state == 0) {
      return new Text("Sign In");
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }
  void animateButton2() {
    setState(() {
      _state = 0;
    });
  }
  void animateButton() {
    setState(() {
      _state = 1;
    });
  }

  void _toggleview(){
    if(ishidden==true){ishidden=false;}
    else{ishidden=true;}
    setState(() {});
  }
  void wrongid(){

      animateButton2();
  }


  void testfirestore(){
    FirebaseFirestore.instance.collection("channels").add({
      "name": "rr",
      "description": "rr",

    });
  }



}





