import 'package:flutter/material.dart';
import 'main.dart';
class Page1 extends StatefulWidget {





  @override
  State<StatefulWidget> createState() => _Page1State();
}

class _Page1State extends State<Page1> {




  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      children: [
        Text(
    '',
          style: Theme.of(context).textTheme.headline4,
        ),
        Divider(),
        ElevatedButton(
          onPressed: () => {},
          child: Icon(Icons.add,size: 24,),
          style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(70,70)), shape: MaterialStateProperty.all(CircleBorder())),
        )
      ],
    );
  }
}
