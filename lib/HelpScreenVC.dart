import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Style/Color.dart';
class HelpScreenVC extends StatefulWidget {
  @override
  _HelpScreenVCState createState() => _HelpScreenVCState();
}

class _HelpScreenVCState extends State<HelpScreenVC> {
  final List<String> entries = <String>[
    "FAQ's",
    'Contact Us',
  ];

  @override
  Widget build(BuildContext context) {
    final helpList = Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[

                InkWell(
                  child: Container(
                    //height: 75,
                    //color: Colors.amber[colorCodes[index]],
                    child: ListTile(
                      title: Text('${entries[index]}',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Helvetica Neue",
                      ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: AppColor.menuItemColor,
                        size: 40,
                      ),
                      onTap: (){
                        if(entries[index].toString() == "FAQ's"){
                          Navigator.of(context).pushNamed('/FaqVC');
                        }else{
                          Navigator.of(context).pushNamed('/ContactUsVC');
                        }

                       //
                      },
                    ),

                  ),
                  onTap: (){
                    // Navigator.of(context).pushNamed('/HistoryDetailVC');

                  },
                ),
                Divider(
                  height: 1,
                 // color: Colors.black54,
                ),
              ],
            );
          }),
    );
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: AppColor.themeColor,
          flexibleSpace: Container(
            height: 100,
            child: SvgPicture.asset(
              "Assets/GreenHeader.svg",
              fit: BoxFit.fill,
            ),
          ),

          title: Text("Help",style: TextStyle(fontFamily: "Helvetica Neue",),),

        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              helpList,
            ],
          ),
        )
    );
  }
}
