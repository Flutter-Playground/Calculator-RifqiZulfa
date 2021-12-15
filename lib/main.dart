import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

void main() => runApp(Calculator());

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {

  String equation = "0";
  String result = "0";
  String expression = "0";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText){
    setState(() {
      if(buttonText == "C"){
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      }
      else if(buttonText == "⌫"){
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if(equation == ""){
          equation = "0";
        }
      }
      else if(buttonText == "="){
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('x', '*');
        expression = expression.replaceAll('÷', '/');

        try{
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        }catch(e){
          result = "Error";
        }
      }
      else{
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if(equation == "0"){
          equation = buttonText;
        }else{
          equation = equation + buttonText;
        }  
      }
    });
  }

  Widget buildButton (String buttonText, double buttonHeight, Color buttonColor){
    return Container( 
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                color: Colors.white, 
                width: 1, 
                style: BorderStyle.solid
              )
          ),
          padding: EdgeInsets.all(16.0),
        ),
          onPressed:() => buttonPressed(buttonText),
          child: Text(
           buttonText,
           style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white
            ),
          )
      ),
  );
  }


  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
            key: _innerDrawerKey,
            onTapClose: true, // default false
            swipe: true, // default true            
            colorTransitionChild: Colors.red, // default Color.black54
            colorTransitionScaffold: Colors.black54, // default Color.black54
            
            //When setting the vertical offset, be sure to use only top or bottom
            offset: IDOffset.only(bottom: 0.05, right: 0.0, left: 0.0),
            
            scale: IDOffset.horizontal( 0.8 ), // set the offset in both directions
            
            proportionalChildArea : true, // default true
            borderRadius: 50, // default 0
            leftAnimationType: InnerDrawerAnimation.static, // default static
            rightAnimationType: InnerDrawerAnimation.quadratic,
            backgroundDecoration: BoxDecoration(color: Colors.red ), // default  Theme.of(context).backgroundColor
            
            //when a pointer that is in contact with the screen and moves to the right or left            
            onDragUpdate: (double val, InnerDrawerDirection? direction) {
                // return values between 1 and 0
                print(val);
                // check if the swipe is to the right or to the left
                print(direction==InnerDrawerDirection.start);
            },
            
            innerDrawerCallback: (a) => print(a), // return  true (open) or false (close)
            leftChild: Container(), // required if rightChild is not set
            rightChild: Container(), // required if leftChild is not set
            
            //  A Scaffold is generally used but you are free to use other widgets
            // Note: use "automaticallyImplyLeading: false" if you do not personalize "leading" of Bar
            scaffold: Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false
                ),
            ),
        );
    }
  }

final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();    

    void _toggle()
    {
       _innerDrawerKey.currentState?.toggle(
       // direction is optional 
       // if not set, the last direction will be used
       //InnerDrawerDirection.start OR InnerDrawerDirection.end                        
        direction: InnerDrawerDirection.end 
       );
    }