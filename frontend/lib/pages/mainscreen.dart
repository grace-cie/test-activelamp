import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config/colors.dart';
import 'package:frontend/config/sizes.dart';
import 'package:frontend/config/widgets.dart';
import 'package:frontend/providers/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main (){
  runApp(const Homepage());
}



class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() => HomepageState();
}

final RoundedLoadingButtonController sendURL = RoundedLoadingButtonController();
final RoundedLoadingButtonController copyURL = RoundedLoadingButtonController();
final formKey = GlobalKey<FormState>();
final shortenFormkey = GlobalKey<FormState>();
final urlcont = TextEditingController();
final shorteurlcont = TextEditingController();


class HomepageState extends State<Homepage> {

  void copyText() async {
    await Clipboard.setData(ClipboardData(text: shorteurlcont.text));
  }

  Future<bool> onWillPop() async {
    return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Hold on!',
            style: TextStyle(fontFamily: 'Prompt'),
          ),
          content: const Text(
            'Are you sure do you want to Exit?',
            style: TextStyle(fontFamily: 'Prompt', color: colors.grey),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'NO',
                style: TextStyle(fontFamily: 'Prompt'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              // onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: const Text(
                'YES',
                style: TextStyle(color: colors.red, fontFamily: 'Prompt'),
              ),
            ),
          ],
        ),
      )
    ) ?? false;
  }

  shortUrl(context, String url) async {

    var map = <String, dynamic>{};
    map['origurl'] = url;


    final response = await http.post(
      Uri.parse('${Provider.baseurl}${Provider.prefix}${Provider.shortroute}'),
      body: map
    );
    print('res $response');
    
    Map<String, dynamic> res = await json.decode(response.body);
    var resmessage = res['message'];
    // var resurl = res['url'];
    var resshort = res['short'];

    if(response.statusCode == 200) {

      sendURL.reset();

      Fluttertoast.showToast(
        msg: resmessage, 
        backgroundColor: colors.basecolor,
        gravity: ToastGravity.TOP,
      );

      shorteurlcont.text = '${Provider.baseurl}/$resshort';

      FocusScope.of(context).unfocus();

    } else {
      sendURL.reset();

      Fluttertoast.showToast(
        msg: resmessage, 
        backgroundColor: colors.basecolor,
        gravity: ToastGravity.TOP,
      );

      shorteurlcont.clear();

    }
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(sizes.appbarGlobal),
            child: widgets.homeappbarwidget
          ),
          body: Center(
            child: Stack(
              children: [
                Positioned(
                  top: 40.0,
                  left: 10.0,
                  right: 10.0,
                  height: 210.0,
                  child: Container(
                    width: double.infinity,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: colors.basecolor,
                      borderRadius: BorderRadius.circular(sizes.boxesRadius),
                      boxShadow: const [
                        BoxShadow(
                          color: colors.grey,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 40 , 10, 10),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: urlcont,
                                  // obscureText: true,
                                  decoration: const InputDecoration(
                                    // prefixIcon: Icon(Icons.net, color: colors.maincolor),
                                    border: OutlineInputBorder(),
                                    enabledBorder: widgets.customborder,
                                    focusedBorder: widgets.customborder,
                                    errorBorder: widgets.customborder,
                                    errorStyle: widgets.customerr,
                                    focusedErrorBorder: widgets.customborder,
                                    labelText: 'Enter URL',
                                    labelStyle: TextStyle(
                                      color: colors.grey,
                                      fontFamily: 'Prompt'
                                    ), 
                                  ),
                                  style: const TextStyle(
                                    color: colors.white
                                  ),
                                  cursorColor: colors.white,
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'This field is required';
                                    }
                                    return null;
                                  }
                                ),
                              ),
                              // Padding(
                                // padding: const EdgeInsets.all(1),
                                // child: 
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                    color: colors.maincolor,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: RoundedLoadingButton(
                                    elevation: 0,
                                    color: colors.maincolor,
                                    onPressed: () {
                                      if(formKey.currentState!.validate()){
                                        shortUrl(context, urlcont.text);
                                      }
                                      sendURL.reset();
                                    },
                                    controller: sendURL, 
                                    child: const Text('Shorten Url')
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      )
                    ),
                  ),
                ),
                Positioned(
                  top: 280.0,
                  left: 10.0,
                  right: 10.0,
                  height: 210.0,
                  child: Container(
                    width: double.infinity,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: colors.basecolor,
                      borderRadius: BorderRadius.circular(sizes.boxesRadius),
                      boxShadow: const [
                        BoxShadow(
                          color: colors.grey,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Form(
                        key: shortenFormkey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text(
                                  'Shortened URL',
                                  style: TextStyle(
                                    fontFamily: 'Prompt',
                                    color: colors.white
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: TextFormField(
                                  enabled: false,
                                  controller: shorteurlcont,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    disabledBorder: widgets.customborder,
                                    // enabledBorder: widgets.customborder,
                                    // focusedBorder: widgets.customborder,
                                    // errorBorder: widgets.customborder,
                                    // errorStyle: widgets.customerr,
                                    focusedErrorBorder: widgets.customborder,
                                    // labelText: 'Enter URL',
                                    labelStyle: TextStyle(
                                      color: colors.grey,
                                      fontFamily: 'Prompt'
                                    ), 
                                  ),
                                  style: const TextStyle(
                                    color: colors.white
                                  ),
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                    color: colors.maincolor,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: RoundedLoadingButton(
                                    elevation: 0,
                                    color: colors.maincolor,
                                    onPressed: () {
                                      copyText();
                                      Future.delayed(const Duration(milliseconds: 8)).then((_){
                                        copyURL.reset();
                                        Fluttertoast.showToast(msg: "Copied Url");
                                      });
                                    },
                                    controller: copyURL, 
                                    child: const Icon(Icons.copy)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                  )
                )
              ],
            )
          ),
        ),
      ), 
      
    );
  }
}