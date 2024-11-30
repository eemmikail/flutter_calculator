import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final fieldController = TextEditingController();
  final List<String> history = [];

  void handleBackspace() {
    final text = fieldController.text;
    if (text.isNotEmpty) {
      fieldController.text = text.substring(0, text.length - 1);
    }
  }

  void showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  history[history.length - 1 - index],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  fieldController.text = history[history.length - 1 - index];
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: fieldController,
                    showCursor: true,
                    readOnly: true,
                    textAlign: TextAlign.right,
                    textAlignVertical: TextAlignVertical.center,
                    expands: true,
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (32 - fieldController.text.length.toDouble())
                          .clamp(20, double.infinity),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => showHistoryDialog(context),
                        icon: const Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: handleBackspace,
                        icon: const Icon(
                          Icons.backspace_outlined,
                          color: Color.fromARGB(255, 128, 197, 131),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:
                                            ToolButton('C', fieldController)),
                                    Expanded(
                                        child:
                                            ToolButton('(', fieldController)),
                                    Expanded(
                                        child:
                                            ToolButton('%', fieldController)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:
                                            DigitButton('7', fieldController)),
                                    Expanded(
                                        child:
                                            DigitButton('8', fieldController)),
                                    Expanded(
                                        child:
                                            DigitButton('9', fieldController)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:
                                            DigitButton('4', fieldController)),
                                    Expanded(
                                        child:
                                            DigitButton('5', fieldController)),
                                    Expanded(
                                        child:
                                            DigitButton('6', fieldController)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:
                                            DigitButton('1', fieldController)),
                                    Expanded(
                                        child:
                                            DigitButton('2', fieldController)),
                                    Expanded(
                                        child:
                                            DigitButton('3', fieldController)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:
                                            ToolButton('+/-', fieldController)),
                                    Expanded(
                                        child:
                                            DigitButton('0', fieldController)),
                                    Expanded(
                                        child:
                                            ToolButton('.', fieldController)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(child: ToolButton('/', fieldController)),
                              Expanded(child: ToolButton('*', fieldController)),
                              Expanded(child: ToolButton('-', fieldController)),
                              Expanded(child: ToolButton('+', fieldController)),
                              Expanded(child: ToolButton('=', fieldController)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DigitButton extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const DigitButton(this.label, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(80, 85, 85, 85),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          controller.text += label;
        },
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class ToolButton extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const ToolButton(this.label, this.controller, {super.key});

  bool _canCloseParenthesis(String text) {
    int count = 0;
    String lastChar = text.isEmpty ? '' : text[text.length - 1];
    if ('+-/*('.contains(lastChar)) {
      return false;
    }
    for (int i = 0; i < text.length; i++) {
      if (text[i] == '(') {
        count++;
      } else if (text[i] == ')') {
        count--;
      }
      if (count < 0) {
        return false;
      }
    }
    return count > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(80, 85, 85, 85),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          if (label == 'C') {
            controller.clear();
          } else if (label == '+/-') {
            controller.text = controller.text.startsWith('-')
                ? controller.text.substring(1)
                : '-${controller.text}';
          } else if (label == '(') {
            if (_canCloseParenthesis(controller.text)) {
              final lastChar = controller.text.isEmpty
                  ? ''
                  : controller.text[controller.text.length - 1];
              if (!'+-/*('.contains(lastChar)) {
                controller.text += ')';
              }
            } else {
              final lastChar = controller.text.isEmpty
                  ? ''
                  : controller.text[controller.text.length - 1];
              if (controller.text.isEmpty || '+-/*('.contains(lastChar)) {
                controller.text += '(';
              }
            }
          } else if (label == '%') {
            try {
              final currentValue = double.parse(controller.text);
              controller.text = (currentValue / 100).toString();
            } catch (e) {
              controller.text = 'Error';
            }
          } else if (label == '.') {
            if (!controller.text.contains('.') && controller.text.isNotEmpty) {
              controller.text += label;
            }
          } else if (label == '=') {
            final expression = controller.text;
            try {
              final result = _evaluateExpression(expression);
              final historyEntry = '$expression = ${result.toString()}';
              final state = context.findAncestorStateOfType<_MainAppState>();
              state?.history.add(historyEntry);
              controller.text = result.toString();
            } catch (e) {
              controller.text = 'Error';
            }
          } else {
            controller.text += label;
          }
        },
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  double _evaluateExpression(String expression) {
    while (expression.contains('(')) {
      int openIndex = -1;
      int closeIndex = -1;
      int depth = 0;
      for (int i = 0; i < expression.length; i++) {
        if (expression[i] == '(') {
          if (depth == 0) {
            openIndex = i;
          }
          depth++;
        } else if (expression[i] == ')') {
          depth--;
          if (depth == 0 && openIndex != -1) {
            closeIndex = i;
            break;
          }
        }
      }

      if (openIndex == -1 || closeIndex == -1) {
        throw Exception('Invalid parentheses');
      }
      String subExpression = expression.substring(openIndex + 1, closeIndex);
      double result = _evaluateExpression(subExpression);
      expression = expression.substring(0, openIndex) +
          result.toString() +
          expression.substring(closeIndex + 1);
    }
    expression = expression.replaceAll(' ', '');
    List<String> tokens = [];
    String currentNumber = '';

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (char == '-' && (i == 0 || '+-/*'.contains(expression[i - 1]))) {
        currentNumber = '-';
      } else if ('0123456789.'.contains(char)) {
        currentNumber += char;
      } else if ('+-/*'.contains(char)) {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber);
          currentNumber = '';
        }
        tokens.add(char);
      }
    }

    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber);
    }
    for (int i = 1; i < tokens.length - 1;) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        double a = double.parse(tokens[i - 1]);
        double b = double.parse(tokens[i + 1]);
        double result;

        if (tokens[i] == '*') {
          result = a * b;
        } else {
          if (b == 0) throw Exception('Division by zero');
          result = a / b;
        }

        tokens[i - 1] = result.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
      } else {
        i++;
      }
    }
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double b = double.parse(tokens[i + 1]);

      if (operator == '+') {
        result += b;
      } else if (operator == '-') {
        result -= b;
      }
    }

    return result;
  }
}
