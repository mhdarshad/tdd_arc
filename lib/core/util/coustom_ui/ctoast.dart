import 'package:flutter/material.dart' show BuildContext,Colors;
import 'package:velocity_x/velocity_x.dart' show VxToast;

class CToast {
 static late BuildContext _context;
 static late String _messege;
 static CToast toast(BuildContext context, {required String msg}){
    _context = context;
    _messege = msg;
    return CToast();
  }
  get error =>VxToast.show(_context, msg: _messege ,bgColor: Colors.red,textColor: Colors.white);
  get warning =>VxToast.show(_context, msg: _messege ,bgColor: Colors.orange,textColor: Colors.white);
  get success =>VxToast.show(_context, msg: _messege ,bgColor: Colors.green,textColor: Colors.white);
  get normal =>VxToast.show(_context, msg: _messege );
}