import 'package:flutter/material.dart';

class splash_screens extends StatefulWidget {
  const splash_screens({Key? key}) : super(key: key);

  @override
  State<splash_screens> createState() => _splash_screensState();
}

class _splash_screensState extends State<splash_screens> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Read Your Favourite Books",style: TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.w800),),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("All your favourites book in one \nplace, read any book, staying at \nhome, on travelling, or anywhere else",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: InkWell(
                      onTap: (){
                        setState((){

                          Navigator.of(context).pushNamed('Homepage');
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Text("Continue",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
      backgroundColor: Colors.orangeAccent,
    );
  }
}