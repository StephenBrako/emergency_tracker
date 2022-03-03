import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ghanatracker/SizeConfig.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextEditingController controller;

  const SearchWidget({
    Key key,
    this.text,
    this.onChanged,
    this.hintText,
    this.controller
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final styleActive = TextStyle(color: Colors.black54);
    final styleHint = TextStyle(color: Colors.black45);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 35,
      width: SizeConfig.safeBlockHorizontal*20.2,
      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: style.color),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color),
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class Trip {
  String name;
  String gps;
  String officers;





  Trip(
      this.name,
      this.gps,
      this.officers,
      );

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
    'name': name,
    'gps': gps,
    'officers': officers,

  };

  // creating a Trip object from a firebase snapshot
  Trip.fromSnapshot(DocumentSnapshot snapshot) :
        name = snapshot['name'],
        gps = snapshot['gps'],
        officers = snapshot['officers'];

}

