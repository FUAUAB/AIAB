import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_order_app/core/responsive/responsive.dart';

import '../../styles/colors_style.dart';

class ScannerFieldView extends StatefulWidget {
  ScannerFieldView(this.updateSelectedProduct);

  final ValueChanged<String> updateSelectedProduct;

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<ScannerFieldView> {
  TextEditingController textController = new TextEditingController();

  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal(
      ValueChanged<String> updateSelectedProduct) async {
    String barcodeScanRes = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      setState(() {
        updateSelectedProduct(barcodeScanRes);
      });
    } catch (e) {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      color: CustomColors.evenRow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 35.0,
                    ),
                    child: ListTile(
                      title: TextField(
                        onSubmitted: (value) {
                          widget.updateSelectedProduct(textController.text);
                          textController.text = '';
                        },
                        controller: textController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          suffixIcon: Container(
                            width: 100,
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.search,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 17,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.updateSelectedProduct(
                                          textController.text);
                                      textController.text = '';
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      textController.text = '';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Zoek een artikel bij artikelNr of Ean ',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Responsive.isMobile(context)
                      ? GestureDetector(
                          onTap: () =>
                              scanBarcodeNormal(widget.updateSelectedProduct),
                          child: Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Icon(
                                FontAwesomeIcons.barcode,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.barcode,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          label: Text(
                            'SCAN',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            scanBarcodeNormal(widget.updateSelectedProduct);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary,
                            alignment: Alignment.center,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
