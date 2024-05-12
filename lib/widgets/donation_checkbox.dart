import 'package:flutter/material.dart';

class DonationItemCategoryCheckBox extends StatefulWidget {

  
  final Function(Map<String, bool>) onChanged;

  const DonationItemCategoryCheckBox({super.key, required this.onChanged});

  @override
  DonationItemCategoryCheckBoxState createState() =>
      DonationItemCategoryCheckBoxState();

}

class DonationItemCategoryCheckBoxState
    extends State<DonationItemCategoryCheckBox> {
   Map<String, bool> categoryStates = {
    'Food': false,
    'Clothes': false,
    'Cash': false,
    'Necessities': false,
  };

  final TextEditingController _customCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What are you donating?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
             ...categoryStates.keys.map((category) {
              return CheckboxListTile(
                title: Text(category),
                value: categoryStates[category],
                onChanged: (value) {
                  setState(() {
                    categoryStates[category] = value!;
                    
                  });
                  widget.onChanged(categoryStates);
                },
              );
            }),
            CheckboxListTile(
              title: TextField(
                controller: _customCategoryController,
                decoration: const InputDecoration(
                  hintText: 'Others...',
                ),
                onSubmitted: (text) {
                  setState(() {
                    categoryStates[text] = false;
                    _customCategoryController.clear();
                  });
                },
              ),
              value: false,
              onChanged: (value) {
              },
            ),
          ],
        ),
      ],
    ),
    );
  }
}
