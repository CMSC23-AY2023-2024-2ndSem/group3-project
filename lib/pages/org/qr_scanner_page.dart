import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../providers/donation_provider.dart';

class  QrScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if(result != null) {
        controller.pauseCamera();
        var wait = await context.read<DonationProvider>().updateStatusToConfirm(result!.code.toString());
        Navigator.pop(context);

        if(wait == "Successfully updated!"){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("QR Code Scanned! Donation Confirmed."),
              duration: Duration(seconds: 5),
            ),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error: Invalid QR Code or Donation status."),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text("Scan a donor's QR Code"),
            ),
          )
        ],
      ),
    );
  }


}
