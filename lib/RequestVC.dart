import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RequestMemVC extends StatefulWidget {
  @override
  _RequestMemVCState createState() => _RequestMemVCState();
}

class _RequestMemVCState extends State<RequestMemVC> {
  String profilePicStr = "";

  @override
  Widget build(BuildContext context) {
    final tabbarCont = Container(
      //color: Colors.red,
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              )),
              child: Center(
                child: FlatButton(
                  child: Text(
                    "Accept All",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                        fontFamily: "Helvetica Neue"),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            width: 1,
            color: Colors.black12,
          ),
          Flexible(
            flex: 5,
            child: Container(
              //color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              )),
              child: Center(
                child: FlatButton(
                  child: Text(
                    "Decline All",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red,
                        fontFamily: "Helvetica Neue"),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
    final memberReqListCont = Container(
      height: 700,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: <Widget>[
                ListTile(
                    title: Text("Anie Halls",style:TextStyle( fontFamily: "Helvetica Neue",),),
                    subtitle: Text("@AnieHall009",style: TextStyle( fontFamily: "Helvetica Neue",),),
                    leading: CircleAvatar(
                      // backgroundColor: Colors.grey,
                      radius: 28.0,
                      backgroundImage: profilePicStr == ""
                          ? AssetImage('Assets/profiledummy.png')
                          : NetworkImage(profilePicStr),
                    ),
                    trailing: Container(
                      width: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xff0A5C2F),
                              //size: 30,
                            ),
                            onTap: () {
                              print("Tick Clicked");
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 2, right: 2),
                            width: 1,
                            height: 30,
                            color: Colors.black12,
                          ),
                          InkWell(
                            child: Icon(
                              Icons.cancel,
                              color: Color(0xffD93434),
                              //
                              //size: 30,
                            ),
                            onTap: () {
                              print("Cross Clicked");
                            },
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 2,
                ),
              ],
            ),
          );
        },
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        flexibleSpace: Container(
          height: 100,
          child: SvgPicture.asset(
            "Assets/GreenHeader.svg",
            fit: BoxFit.fill,
          ),
        ),
        title: new Text("Request",style: TextStyle( fontFamily: "Helvetica Neue",),),
      ),
      body: Column(
        children: <Widget>[tabbarCont, memberReqListCont],
      ),
    );
  }
}
