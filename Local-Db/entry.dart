import 'package:flutter/material.dart';
import 'package:crudproject_nonnative/sql.hlp.dart';

class EntryPage extends StatelessWidget {
  final int? id;
  final Map<String, dynamic>? existingData;

  DataEntryPage({Key? key, this.id, this.existingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _ManufacturerNameController = TextEditingController();
    final TextEditingController _ModelNameController = TextEditingController();
    final TextEditingController _PriceInitialController = TextEditingController();
    final TextEditingController _ModelYearController = TextEditingController();
    final TextEditingController _ColorController = TextEditingController();

    // Load existing data if updating
    if (existingData != null) {
      _ManufacturerNameController.text = existingData!['ManufacturerName'];
      _ModelNameController.text = existingData!['ModelName'];
      _PriceInitialController.text = existingData!['PriceInitial']?.toString() ?? '';
      _ModelYearController.text = existingData!['ModelYear']?.toString() ?? '';
      _ColorController.text = existingData!['Color'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? 'Add' : 'Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _ManufacturerNameController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _ModelNameController,
              decoration: InputDecoration(labelText: 'Model'),
            ),
            TextField(
              controller: _PriceInitialController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'initial price'),
            ),
            TextField(
              controller: _ModelYearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Year'),
            ),
            TextField(
              controller: _ColorController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Implement your logic for adding or updating data
                final ManufacturerName = _ManufacturerController.text;
                final ModelName = _ModelNameController.text;
                final PriceInitial = int.tryParse(_PriceInitialController.text.isNotEmpty ? _PriceInitialController.text : '0') ?? 0;
                final ModelYear = int.tryParse(_ModelYearController.text.isNotEmpty ? _ModelYearController.text : '0') ?? 0;
                final Color = _ColorController.text;

                if (id == null) {
                  // Add logic for adding data
                  await SqlHelper.createData(ManufacturerName, ModelName, PriceInitial, ModelYear, Color);
                } else {
                  // Add logic for updating data
                  await SqlHelper.updateData(id, ManufacturerName, ModelName, PriceInitial, ModelYear, Color);
                }
                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}