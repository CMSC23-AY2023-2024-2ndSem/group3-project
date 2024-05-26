import 'package:flutter/material.dart';

class MultipleAddressSignUpInput extends StatefulWidget {
  final void Function(List<String>) onChanged;

  const MultipleAddressSignUpInput({super.key, required this.onChanged});

  @override
  MultipleAddressSignUpInputState createState() =>
      MultipleAddressSignUpInputState();
}

class MultipleAddressSignUpInputState
    extends State<MultipleAddressSignUpInput> {
  List<String> addresses = [];

  TextEditingController addressController = TextEditingController();

  void _addAddress(String address) {
    if (address.isEmpty) {
      return;
    }

    setState(() {
      addresses.add(address);
      addressController.clear();
      widget.onChanged(addresses);
    });
  }

  void _removeAddress(int index) {
    setState(() {
      addresses.removeAt(index);
      widget.onChanged(addresses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(50, 50, 50, 1),
        border: Border.all(color: const Color.fromRGBO(50, 50, 50, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (addresses.isEmpty)
            const Text(
              'Address:',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
            ),
          if (addresses.isNotEmpty)
            const Text(
              'Address:',
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.purpleAccent),
            ),
          const SizedBox(height: 8),
          Column(
            children: [
              ...addresses.asMap().entries.map((entry) {
                final index = entry.key;
                final address = entry.value;
                return ListTile(
                  title: Text(address),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeAddress(index),
                  ),
                );
              }),
              ListTile(
                leading: const Icon(Icons.add),
                title: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    floatingLabelStyle: TextStyle(color: Colors.purpleAccent),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.purple,
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.redAccent, style: BorderStyle.solid),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.purple, style: BorderStyle.solid),
                    ),
                    labelText: 'Add Address',
                  ),
                  onSubmitted: (text) {
                    _addAddress(text);
                  },
                ),
                onTap: () {
                  _addAddress(addressController.text);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
