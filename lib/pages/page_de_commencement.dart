
import 'package:flutter/material.dart';
import 'package:note/pages/page_inscription.dart';
import '../style/style.dart';

class PageDeCommencement extends StatelessWidget{
  const PageDeCommencement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("")),
        backgroundColor: Color(0xff1f48ff),
      ),
      backgroundColor: Color(0xff1f48ff),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/logo.jpg",
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "Mes notes, Ma memoire au bout de mes doigts", 
                        style: AppStyle.taillText,
                        textAlign: TextAlign.center,
                        ),
                  ),
                  OutlinedButton(
                    onPressed: (){
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => PageInscription()
                          )
                        );
                    }, 
                    child: Text(
                      "Commencer", 
                      style: AppStyle.textButton,
                      )
                    ),

                    Text("Powered by Mouktar")
          ],
        ),
      ),
    );
  }
}