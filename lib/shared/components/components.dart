import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/styles/color.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => widget), (route) {
      return false;
    });

Widget defaultButton({
  @required String text,
  @required Function function,
  double radius = 35.0,
  Color color = kPrimaryColor,
}) =>
    Container(
      height: 50.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(text.toUpperCase()),
      ),
    );

Widget defaultTextField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required String label,
  @required IconData prefix,
  bool isPassword = false,
  Function onSubmit,
  Function suffixPressed,
  IconData suffix,
  @required Function validation,
}) =>
    TextFormField(

      onFieldSubmitted: onSubmit,
      obscureText: isPassword,
      controller: controller,
      validator: validation,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
      ),
    );

void showToast({
  @required String msg,
  @required ToastStates state,
}){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0
  );
}

enum ToastStates{success,error,warning}
Color chooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.error:
      color = Colors.yellow;
      break;
  }
  return color;
}

Widget circularProgress(){
  return CircularProgressIndicator(
    backgroundColor: kPrimaryColor,
  );
}