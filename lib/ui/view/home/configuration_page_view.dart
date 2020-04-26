import 'package:flutter/material.dart';
import 'package:letstogether/ui/base/app_localizations.dart';
import 'package:letstogether/ui/base/appbar_page.dart';
import 'package:letstogether/ui/base/custom_theme_data.dart';
import 'package:letstogether/ui/theme/green_thema.dart';
import 'package:letstogether/ui/theme/red_theme.dart';
import 'package:letstogether/ui/theme/turkuaz_theme.dart';
import 'package:provider/provider.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(title: AppLocalizations.of(context).translate('configurations')),
        body: Stack(
          
          children: <Widget>[ 
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text(AppLocalizations.of(context).translate('dark')),
                    shape: Theme.of(context).buttonTheme.shape,
                    color : Theme.of(context).buttonColor,
                    onPressed: () {
                      Provider.of<CustomThemeDataModal>(context)
                          .setThemeData(ThemeData.dark());
                    },
                  ),
                  RaisedButton(
                    child: Text(AppLocalizations.of(context).translate('light')),
                     shape: Theme.of(context).buttonTheme.shape,
                     color : Theme.of(context).buttonColor,
                    onPressed: () {
                      Provider.of<CustomThemeDataModal>(context)
                          .setThemeData(ThemeData.light());
                    },
                  ),
                  RaisedButton(
                    child: Text(AppLocalizations.of(context).translate('red')), 
                     shape: Theme.of(context).buttonTheme.shape,
                     color : Theme.of(context).buttonColor,
                    onPressed: () {
                      Provider.of<CustomThemeDataModal>(context)
                          .setThemeData(redTheme);
                    },
                  ),
                  RaisedButton(
                    child: Text(AppLocalizations.of(context).translate('blue')),  
                    shape: Theme.of(context).buttonTheme.shape,
                    color : Theme.of(context).buttonColor,
                    onPressed: () {
                      Provider.of<CustomThemeDataModal>(context)
                          .setThemeData(turkuazTheme);
                    },
                  ),
                  RaisedButton(
                    child: Text(AppLocalizations.of(context).translate('green')),  
                    shape: Theme.of(context).buttonTheme.shape,
                    color : Theme.of(context).buttonColor,
                    onPressed: () {
                      Provider.of<CustomThemeDataModal>(context)
                          .setThemeData(greenTheme);
                    },
                  ),
                ]
              ),

            //  _showCircularProgress(),
          ],
        )
        // drawer: DrawerPage(auth: widget.auth ,logoutCallback : widget.logoutCallback),
        // body: Center(child: SwipeList()));
        //body:  _listActivity(),
        );
  }
 
}