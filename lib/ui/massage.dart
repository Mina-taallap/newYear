import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_broadcast_whatsapp/flutter_broadcast_whatsapp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
class MassegePage extends StatefulWidget {
  @override
  _MassegePageState createState() => _MassegePageState();
}

class _MassegePageState extends State<MassegePage> {
  TextEditingController messageController=TextEditingController();
  String msg="Happy new year كل سنة وانت طيب يا حبيبي وعقبال سنين كنير";
  List<Contact>contactList;
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
  contactPermissoion();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle:true ,title: Text("New Year"),),
      body: Column(
        children: [
          SizedBox(height: 50,),

          Center(child:
          RaisedButton(
            child: Text("Send"),
              color: Colors.red,
              onPressed: ()async{
                for(int i=0;i<=5;i++){
                 // FlutterBroadcastWhatsapp.sendBroadcastMessage(msg);
                  await launch("https://wa.me/${contactList[i].phones.first.value.toString()}?text= $msg ${contactList[i].displayName}");
                }


          }),),
          Center(child:
          RaisedButton(
              child: Text("Send All"),
              color: Colors.lightBlueAccent,
              onPressed: ()async{
                 FlutterBroadcastWhatsapp.sendBroadcastMessage(msg);
              }),)
        ],      ),
    );
  }
  Future<void> getPoneContacts()  async {
    Iterable<Contact>contact= await ContactsService.getContacts(withThumbnails: false);
    contactList=contact.toList();


  }
  contactPermissoion()async{
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
            getPoneContacts();
    } else {
      //If permissions have been denied show standard cupertino alert dialog
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Permissions error'),
            content: Text('Please enable contacts access '
                'permission in system settings'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
    }
  }
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

}
