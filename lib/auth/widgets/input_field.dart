import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController textController;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const InputField(
      {Key? key,
      required this.textController,
      required this.hintText,
      this.prefixIcon,
      this.validator,
      this.suffixIcon,
      this.onChanged,
      this.obscureText = false
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      controller: textController,
      obscureText: obscureText,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          errorMaxLines: 2,
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          )),
    );
  }
}
