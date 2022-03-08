import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String label, hintText, iniString;
  final bool isSuffixIcon;
  late final bool isObscured;
  final TextInputType inputType;
  final bool isMultiText;
  CustomInput(this.controller, this.label, this.hintText, this.iniString, this.isSuffixIcon,
      this.inputType, this.isObscured, this.isMultiText);

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool isObscure = true;
  void initialization(){
    setState(() {
      isObscure = widget.isObscured;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    if(widget.isMultiText){
      if(UniversalPlatform.isIOS){
        return CupertinoTextField(
          controller: widget.controller,
          placeholder: '${widget.label}',
          placeholderStyle: isDarkModeOn ? TextStyle(color: Colors.white)
              : TextStyle(color: Colors.black),
          style: isDarkModeOn ? TextStyle(color: Colors.white)
              : TextStyle(color: Colors.black),
          keyboardType: widget.inputType,
          cursorColor: isDarkModeOn ? Colors.white : Colors.black,
          maxLength: 256,
          maxLines: 5,
          minLines: 1,
        );
      }
      return TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: '${widget.label}',
          hintText: widget.hintText != "" ? '${widget.hintText}' : null,
          labelStyle: isDarkModeOn ? TextStyle(color: Colors.white)
              : TextStyle(color: Colors.black),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.teal,
              )
          ),
        ),
        validator: (input){
          if(input!.isEmpty){
            return "Field is required";
          }
          return "";
        },
        keyboardType: widget.inputType,
        cursorColor: isDarkModeOn ? Colors.white : Colors.black,
        maxLength: 256,
        maxLines: 5,
        minLines: 1,
      );
    }
    if(widget.isSuffixIcon){
      if(UniversalPlatform.isIOS){
        return CupertinoTextField(
          controller: widget.controller,
          placeholder: '${widget.label}',
          placeholderStyle: isDarkModeOn ? TextStyle(color: Colors.white)
              : TextStyle(color: Colors.black),
          style: isDarkModeOn ? TextStyle(color: Colors.white)
              : TextStyle(color: Colors.black),
          suffix: InkWell(
            onTap: () => setState(
                  () => isObscure =
              !isObscure,
            ),
            child: Icon(
              isObscure
                  ? Icons.visibility_outlined
                  : Icons
                  .visibility_off_outlined,
              size: 22,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          keyboardType: widget.inputType,
          obscureText: isObscure,
          cursorColor: isDarkModeOn ? Colors.white : Colors.teal,
        );
      }
      return TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: '${widget.label}',
          hintText: widget.hintText != "" ? '${widget.hintText}' : "",
          labelStyle: isDarkModeOn ? TextStyle(color: Colors.white)
              : TextStyle(color: Colors.black),
          suffixIcon: InkWell(
            onTap: () => setState(
                  () => isObscure =
              !isObscure,
            ),
            child: Icon(
              isObscure
                  ? Icons.visibility_outlined
                  : Icons
                  .visibility_off_outlined,
              size: 22,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.teal,
              )
          ),
        ),
        validator: (input){
          if(input!.isEmpty){
            return "Field is required";
          }
          return "";
        },
        keyboardType: widget.inputType,
        obscureText: isObscure,
        cursorColor: isDarkModeOn ? Colors.white : Colors.black,
      );
    }
    if(UniversalPlatform.isIOS){
      return CupertinoTextField(
        controller: widget.controller,
        placeholder: '${widget.label}',
        placeholderStyle: isDarkModeOn ? TextStyle(color: Colors.white)
            : TextStyle(color: Colors.black),
        style: isDarkModeOn ? TextStyle(color: Colors.white)
            : TextStyle(color: Colors.black),
        keyboardType: widget.inputType,
        cursorColor: isDarkModeOn ? Colors.white : Colors.black,
      );
    }
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: '${widget.label}',
        hintText: widget.hintText != "" ? '${widget.hintText}' : null,
        labelStyle: isDarkModeOn ? TextStyle(color: Colors.white)
            : TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
            )
        ),
      ),
      validator: (input){
        if(input!.isEmpty){
          return "Field is required";
        }
        return "";
      },
      keyboardType: widget.inputType,
      cursorColor: isDarkModeOn ? Colors.white : Colors.black,
    );
  }
}