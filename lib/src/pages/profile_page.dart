import 'package:flutter/material.dart';
import 'package:heartdog/src/util/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundSecondColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              //shape: ShapeBorder.,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 84,
                      ),
                      SizedBox(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Carlos Eduardo',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text('Izarra Ticlla',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.edit,
                          size: 24,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ]),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            //Mascota
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              //shape: ShapeBorder.,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Información de mi\nmascota  🐕',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.edit,
                              size: 24,
                              color: AppColors.primaryColor,
                            ),
                          )
                        ]
                        ),
                    SizedBox(height: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('Nombre: Firulais',style: TextStyle(fontSize: 16),),
                      SizedBox(height: 5,),
                      Text('Edad: 8 años',style: TextStyle(fontSize: 16),),
                      SizedBox(height: 5,),
                      Text('Raza: Pequines',style: TextStyle(fontSize: 16),),
                      SizedBox(height: 5,),
                      Text('Peso: 25 kg',style: TextStyle(fontSize: 16),),
                      SizedBox(height: 5,),
                      Text('Condicion médica: Con arritmias ',style: TextStyle(fontSize: 16),),
                    ],)
                        
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 30,
            ),

            GestureDetector(
              onTap: ()=>{
                Navigator.of(context).pushNamed('/')
              },
              child: Text('Cerrar sesión',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                decoration: TextDecoration.underline
              ),
              ),
            )

          ]),
        ),
      ),
    );
  }
}
