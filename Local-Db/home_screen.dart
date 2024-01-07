import 'package:flutter/material.dart';
import 'entry.dart';
import 'package:crudproject_nonnative/sql_hlp.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  // Get All data from Database
  void _refreshData() async {
    final data = await SqlHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Add Data
  Future<void> _addData() async {
    await SqlHelper.createData(
      _ManufacturerNameNameController.text,
      _ModelNameController.text,
      int.parse(_PriceInitialController.text),
      int.parse(_ModelYearController.text),
      _ColorController.text
    );

    _refreshData();
  }

  // Update Data
  Future<void> _updateData(int? id) async {
    if (id != null) {
      await SqlHelper.updateData(
        id!,
         _ManufacturerNameController.text = existingData!['ManufacturerName'];
      _ModelNameController.text = existingData!['ModelName'];
      _PriceInitialController.text = existingData!['PriceInitial']?.toString() ?? '';
      _ModelYearController.text = existingData!['ModelYear']?.toString() ?? '';
      _ColorController.text = existingData!['Color'];
      );
      _refreshData();
    }
  }

  // Delete Data
  void _deleteData(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure you want to delete this?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                // Delete the data
                await SqlHelper.deleteData(id);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text("Data Deleted"),
                  ),
                );
                _refreshData();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController _ManufacturerNameController = TextEditingController();
  final TextEditingController _ModelNameController = TextEditingController();
  final TextEditingController _PriceInitialController = TextEditingController();
  final TextEditingController _ModelYearController = TextEditingController();
  final TextEditingController _ColorController = TextEditingController();

  void _navigateToDataEntryPage(int? id) async {
    List<Map<String, dynamic>> existingDataList = [];

    // Fetch existing data if updating
    if (id != null) {
      existingDataList = await SqlHelper.getSingleData(id);
    }

    // Use the first item from the list as existing data
    Map<String, dynamic>? existingData = existingDataList.isNotEmpty ? existingDataList.first : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataEntryPage(id: id, existingData: existingData),
      ),
    ).then((value) {
      // Refresh data when returning from DataEntryPage
      _refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEA4),
      appBar: AppBar(
        title: Text("Car Bidder"),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.all(15),
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                _allData[index]['ManufacturerName'] ?? 'No Name',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type: ${_allData[index]['ModelName'] ?? 'No Name'}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  'Employees: ${_allData[index]['PriceInitial']?.toString() ?? 'No price'}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  'Customers: ${_allData[index]['ModelYear']?.toString() ?? 'No year'}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  'Income: ${_allData[index]['Color']?.toString() ?? 'No color'}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _navigateToDataEntryPage(_allData[index]['id']);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.indigo,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _deleteData(_allData[index]['id']);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDataEntryPage(null),
        child: Icon(Icons.add),
      ),
    );
  }
}