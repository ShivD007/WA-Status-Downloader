
import 'package:flutter/cupertino.dart';

class TabIndexProvider with ChangeNotifier{
   int index = 0;
   
   getindx(int a){
   index = a;
   notifyListeners();
   print ("$index..........................................................................................");
   }
   



}