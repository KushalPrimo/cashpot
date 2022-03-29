import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Style/Color.dart';

class TransactionOptionListVC extends StatefulWidget {
  @override
  _TransactionOptionListVCState createState() => _TransactionOptionListVCState();
}

class _TransactionOptionListVCState extends State<TransactionOptionListVC> {



  @override
  Widget build(BuildContext context) {
    final tansactionoptionListCont = Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Wallet Activity",style: TextStyle( fontFamily: "Helvetica Neue",),),
            trailing: Icon(
              Icons.navigate_next,
              color: AppColor.menuItemColor,
              size: 40,
            ),
            onTap: (){
              Navigator.of(context).pushNamed('/PersonalWalletActivityVC');
            },
          ),
          Divider(height: 1,),
          ListTile(
            title: Text("Transactions",style: TextStyle( fontFamily: "Helvetica Neue",),),
            trailing: Icon(
              Icons.navigate_next,
              color: AppColor.menuItemColor,
              size: 40,
            ),
            onTap: (){
              Navigator.of(context).pushNamed('/TransactionHistoryVC');
            },
          ),
          Divider(height: 1,),
        ],
      ),

    );
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: AppColor.themeColor,
          flexibleSpace:
          Container(
            height: 100,
            child: SvgPicture.asset("Assets/GreenHeader.svg",
              fit: BoxFit.fill,
            ),
          ),
          title: Text("Transactions",style: TextStyle( fontFamily: "Helvetica Neue",),),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: tansactionoptionListCont
    );
  }
}
