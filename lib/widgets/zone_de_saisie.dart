import 'package:flutter/material.dart';
import '../style/style.dart';

class ZoneDeSaisie  extends StatefulWidget{
  final TextEditingController controller ;
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;

  const ZoneDeSaisie({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.obscureText = true,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    });

  @override
  State<ZoneDeSaisie> createState() => _ZoneDeSaisieState();
}

class _ZoneDeSaisieState extends State<ZoneDeSaisie> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppStyle.textButton,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                    if (widget.onToggleVisibility != null) {
                      widget.onToggleVisibility!();
                    }
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        ),
        style: AppStyle.textButton,
    );
  }
}