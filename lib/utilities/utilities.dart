import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordfun/utilities/constants.dart';
import 'package:wordfun/utilities/dialog_button_data.dart';



class Utilities{

  static String genRandomString(int length) {
    String data= 'abcdefghijklmn opqrs tuvw xyz A BCD EFG HIJKL MNOPQRST UVWXYZ ___ 1234567 890()';
    String result = '';
    for(int i =0 ; i< length; i++){
      result += data[Random().nextInt(data.length)];
    }
    return result;
  }

  static String genRandomString4Pic(int length) {
    String data= 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    String result = '';
    for(int i =0 ; i< length; i++){
      result += data[Random().nextInt(data.length)];
    }
    return result;
  }

  static showCustomDialog({required BuildContext context, required IconData icon, required Color iconColor,
    required String text, required List<DialogButtonData> buttonList}){
    List<Widget> butList=[];
    if(buttonList!=null && buttonList.length>0){
      for(var arr in buttonList){
        butList.add(Expanded(
          child: GestureDetector(
            onTap: arr.onTapped,
            child: Container(
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: arr.backColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Text(arr.text, style: TextStyle(color:Colors.white),),
              ),
            ),
          ),
        ));
      }
    }
    Dialog errorDialog= Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Container(
        height: 350,
        width: 350,
        child: Column(
          children: [
            Expanded(child: Icon(icon, color: iconColor, size: 200,)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 20,),
            Container(
              height: butList!=null?50:2,
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: buttonList!=null?butList:[],
              ),
            )
          ],
        ),
      ),
    );
    showGeneralDialog(context: context,
        barrierLabel: text,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 500),
        transitionBuilder: (_, anim, __, child){
          return SlideTransition(position: Tween(begin: Offset(-1,0), end: Offset(0,0)).animate(anim), child: child,);
        },
        pageBuilder: (BuildContext context, _, __)=>(errorDialog)
    );
  }


  static Future<void> setPrefsValue(String key, var value) async {
    SharedPreferences sp=await SharedPreferences.getInstance();
    if(sp.containsKey(key)){
      await sp.remove(key);
    }
    await sp.reload();
    await sp.setString(key, value.toString());
  }


  static Future<String> getSharedPrefValue(String key) async {
    SharedPreferences sp=await SharedPreferences.getInstance();
    await sp.reload();
    String result =  sp.get(key).toString();
    if (result == 'null') return '';
    return result;
  }

  static void showOkNotification(String text){
    showSimpleNotification(
        SelectableText(text, style: NAVTEXTSTYLE,),
        background: Colors.green);
  }

  static void showErrorNotification(String text, BuildContext context){
    if((text.contains('>') || text.contains('null') || text.length > 80) && !text.contains('An error occured !')){
      Utilities.showErrorNotification('An error occured !', context);
      return;
    }
    showSimpleNotification(
        SelectableText(text, style: (text == 'An error occured !')
            ?NAVTEXTSTYLE:NAVTEXTSTYLE.copyWith(color: Colors.red),),
        leading:Icon(Icons.warning, color:Colors.white),
        background: (text == 'An error occured !')?Colors.red:Colors.white);
    // Provider.of<UserDataProvider>(context, listen:false).setError(text);
  }

  static void showMessageSentNotification() {
    showSimpleNotification(
        SelectableText('Sent', style: NAVTEXTSTYLE,),
        leading:Icon(Icons.check, color:Colors.white),
        background: Colors.green);
  }

  static void showEmptyTextNotification(String message) {
    showSimpleNotification(
        SelectableText(message, style: TextStyle(color: Colors.black),),
        leading:Icon(Icons.warning, color:Colors.black),
        background: Colors.white);
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }


  static String genPicString(List<String> restaurantImagesList) {
    String result = '';
    for(String url in restaurantImagesList){
      result += url+',';
    }
    return result;
  }

  static String getFileName(String string) {
    List<String> data = string.split('/');
    return data.last;
  }

  static bool validateStartEndTime(String timeData){
    List<String> dataList = timeData.replaceAll(' ', '').replaceAll('-', ':').split(':');
    if(dataList.length!=4){
      return false;
    }
    if((int.tryParse(dataList[1])??70)>=60 || (int.tryParse(dataList[3])??70)>=60){
      return false;
    }
    if((int.tryParse(dataList[0])??24)>=24 || (int.tryParse(dataList[2])??24)>=24){
      return false;
    }
    return true;
  }

  static Future<void> logout(BuildContext context) async {
    SharedPreferences sp=await SharedPreferences.getInstance();
    await sp.clear();
    // Navigator.pushAndRemoveUntil(context,
    //   MaterialPageRoute(builder: (context)=>StartScreen()), (_)=>false);
  }


}