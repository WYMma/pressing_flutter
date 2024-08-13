import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(LSCreditCard());

class LSCreditCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credit Card Input',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LSCreditCardForm(),
    );
  }
}

class LSCreditCardForm extends StatefulWidget {
  @override
  _LSCreditCardFormState createState() => _LSCreditCardFormState();
}

class _LSCreditCardFormState extends State<LSCreditCardForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _cardNumber = '';
  String _cardHolderName = '';
  String _expiryDate = '';
  String _cvvCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Input'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberInputFormatter(),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your card number';
                  }
                  if (value!.length != 19) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cardNumber = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Card Holder Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the card holder\'s name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cardHolderName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: 'MM/YY',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateInputFormatter(),
                ],
                onSaved: (value) {
                  _expiryDate = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'CVV',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the CVV code';
                  }
                  if (value?.length != 3) {
                    return 'Please enter a valid CVV code';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cvvCode = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;
    if (text.length > 19) return oldValue;
    final newText = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) newText.write(' ');
      newText.write(text[i]);
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var text = newValue.text;
    if (text.length > 4) return oldValue;
    if (text.length == 2 && oldValue.text.length == 1) {
      text = '$text/';
    } else if (text.length == 2 && oldValue.text.length == 3) {
      text = text.substring(0, 1);
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
