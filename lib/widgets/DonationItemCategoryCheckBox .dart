import 'package:flutter/material.dart';

class DonationItemCategoryCheckBox extends StatefulWidget {

  
  final Function(Map<String, bool>) onChanged;

  DonationItemCategoryCheckBox({required this.onChanged});
  @override
  _DonationItemCategoryCheckBoxState createState() =>
      _DonationItemCategoryCheckBoxState();

  getSelectedCategories() {
    return _DonationItemCategoryCheckBoxState().categoryStates;
  }
}

class _DonationItemCategoryCheckBoxState
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
    return Column(
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
            }).toList(),
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
    );
  }
}
