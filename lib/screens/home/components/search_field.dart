import 'package:flutter/material.dart';

import '../../../constants.dart';

class SearchField extends StatelessWidget {
  final Function(String) onSearch;

  const SearchField({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        onChanged: onSearch,
        decoration: InputDecoration(
          filled: true,
          fillColor: kSecondaryColor.withOpacity(0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: searchOutlineInputBorder,
          focusedBorder: searchOutlineInputBorder,
          enabledBorder: searchOutlineInputBorder,
          hintText: "Search product",
          hintStyle: const TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 184, 184, 183)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
        ),
      ),
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
