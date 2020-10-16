import 'package:flutter/material.dart';
import 'package:letstogether/ui/base/app_localizations.dart';

class MultiSelectChip extends StatefulWidget {
  final List<int> reportList;
  final Function(int) onSelectionChanged;
  
  MultiSelectChip({this.reportList, this.onSelectionChanged});
 
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();

}

class _MultiSelectChipState extends State<MultiSelectChip> {
  int _selectedChoice = 0;
  int get selectedChoice => _selectedChoice;
   
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(5.0),
        child: ChoiceChip(
          label: Text(item.toString()),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              _selectedChoice = item;
               widget.onSelectionChanged(item);
            });
          },
          selectedColor: Theme.of(context).primaryColor,
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,

        child: Text(
        AppLocalizations.of(context).translate('yourPoint'), 
      )),
      Wrap(
        children: _buildChoiceList(),
      ),
    ]);
  }



}
