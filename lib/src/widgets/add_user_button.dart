import 'package:flutter/material.dart';

class AddUserButton extends StatelessWidget {
 final void Function() onAdduser;

  const AddUserButton({required Key key, required this.onAdduser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onAdduser,
      child: Container(
        alignment: Alignment.center,
        height: 55,
        width: 55,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey,

        ),
        child: const Icon(Icons.add, 
        size: 30,
        color:Colors.white)
        
      ),
    );
  }
}