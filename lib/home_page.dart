import 'package:alphalist/alpha_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  List<String> list = [
    'last',
    'christmas',
    'I',
    'gave',
    'you',
    'my',
    'heart',
    'But',
    'the',
    'very',
    'next',
    'day',
    'this',
    'year',
    'to',
    'save',
    'me',
    'from',
    'tears',
    'will',
    'give',
    'it',
    'someone',
    'special',
    'Once',
    'bitten',
    'and',
    'twice',
    'shy',
    'keep',
    'distance',
    'still',
    'catch',
    'eye',
    'tell',
    'baby',
    'do',
    'recognize',
    'well',
    'been',
    'year',
    'does',
    'surprise',
    'wrapped',
    'up',
    'sent',
    'with',
    'note',
    'saying',
    'meant',
    'now',
    'know',
    'what',
    'fool',
    'kiss',
    'face',
    'on',
    'lover',
    'man',
    'under',
    'cover',
    'tore',
    'apart',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AlphabetScrollView(
              list: list.map((e) => AlphaModel(e)).toList(),
              alignment: LetterAlignment.right,
              itemExtent: 50,
              unselectedTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black
              ),
              selectedTextStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red
              ),
              itemBuilder: (_, k, id) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ListTile(
                    title: Text('$id'),
                  ),
                );
              },
            ),
          )
        ],
      ),

    );
  }

}