import 'package:flutter/material.dart';

class MultipleAddressInput extends StatefulWidget {
  final void Function(List<String>) onChanged;

  const MultipleAddressInput({super.key, required this.onChanged});

  @override
  MultipleAddressInputState createState() => MultipleAddressInputState();
}

class MultipleAddressInputState extends State<MultipleAddressInput> {
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address:',
          style: TextStyle(fontWeight: FontWeight.bold),
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
