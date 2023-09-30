import 'package:flutter/material.dart';

class AddUserButton extends StatelessWidget {
 final void Function() onAdduser;

  const AddUserButton({ Key? key, required this.onAdduser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onAdduser,
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: 65,
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