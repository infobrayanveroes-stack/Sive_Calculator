import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false, 
  title: "Sive_Calculator",
  home: CalculadoraCientifica()
));

class CalculadoraCientifica extends StatefulWidget {
  const CalculadoraCientifica({super.key});
  @override
  State<CalculadoraCientifica> createState() => _CalculadoraCientificaState();
}

class _CalculadoraCientificaState extends State<CalculadoraCientifica> {
  String equation = "0";
  String result = "0";

  void onButtonPressed(String text) {
    setState(() {
      if (text == "AC") {
        equation = "0";
        result = "0";
      } else if (text == "⌫") {
        equation = equation.length > 1 ? equation.substring(0, equation.length - 1) : "0";
      } else if (text == "=") {
        try {
          String finalEquation = equation.replaceAll('×', '*').replaceAll('÷', '/');
          Parser p = Parser();
          Expression exp = p.parse(finalEquation);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toStringAsFixed(eval == eval.toInt() ? 0 : 4);
        } catch (e) {
          result = "Error";
        }
      } else {
        equation = (equation == "0") ? text : equation + text;
      }
    });
  }

  Widget buildBtn(String text, Color color, {bool isSpecial = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(3), 
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSpecial ? color : const Color(0xFF222222),
            padding: const EdgeInsets.symmetric(vertical: 18), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => onButtonPressed(text),
          child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSpecial ? Colors.black : color)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40), // ESTO BAJA EL CUADRO "UN DEDO"
            
            // Pantalla de Resultados optimizada contra Overflow
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // La ecuación con scroll horizontal para evitar líneas amarillas
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true, // Para que siempre veas el final de lo que escribes
                      child: Text(
                        equation, 
                        style: const TextStyle(color: Colors.white70, fontSize: 26),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // El resultado que se encoge si es muy grande
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        result, 
                        style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.w300)
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Teclado
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF151515),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                ),
                child: Column(
                  children: [
                    Row(children: [buildBtn("sin", Colors.blue), buildBtn("cos", Colors.blue), buildBtn("tan", Colors.blue), buildBtn("log", Colors.blue), buildBtn("^", Colors.blue)]),
                    Row(children: [buildBtn("AC", Colors.redAccent), buildBtn("(", Colors.green), buildBtn(")", Colors.green), buildBtn("√", Colors.green), buildBtn("÷", Colors.green, isSpecial: true)]),
                    Row(children: [buildBtn("7", Colors.white), buildBtn("8", Colors.white), buildBtn("9", Colors.white), buildBtn("π", Colors.blue), buildBtn("×", Colors.green, isSpecial: true)]),
                    Row(children: [buildBtn("4", Colors.white), buildBtn("5", Colors.white), buildBtn("6", Colors.white), buildBtn("e", Colors.blue), buildBtn("-", Colors.green, isSpecial: true)]),
                    Row(children: [buildBtn("1", Colors.white), buildBtn("2", Colors.white), buildBtn("3", Colors.white), buildBtn("%", Colors.blue), buildBtn("+", Colors.green, isSpecial: true)]),
                    Row(children: [buildBtn("0", Colors.white), buildBtn(".", Colors.white), buildBtn("⌫", Colors.orange), buildBtn("=", Colors.green, isSpecial: true)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}