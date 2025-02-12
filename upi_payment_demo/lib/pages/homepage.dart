import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _receiverNameController = TextEditingController();

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.white70,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    double amount = double.parse(_amountController.text);
    String receiverUpiId = _upiIdController.text;
    String receiverName = _receiverNameController.text;

    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: receiverUpiId,
      receiverName: receiverName,
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: amount,
    );
  }
Widget displayUpiApps() {
  if (apps == null) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.grey,
      ),
    );
  } else if (apps!.length == 0) {
    return Center(
      child: Text(
        "No apps found to handle transaction.",
        style: header,
      ),
    );
  } else {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: apps!.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () {
                if (_amountController.text.isEmpty ||
                    _upiIdController.text.isEmpty ||
                    _receiverNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                } else {
                  setState(() {
                    _transaction = initiateTransaction(app);
                  });
                }
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(
                      app.icon,
                      height: 35,
                      width: 35,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      app.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

String _upiErrorHandler(Object error) {
  if (error is UpiIndiaAppNotInstalledException) {
    return 'Requested app not installed on device';
  } else if (error is UpiIndiaUserCancelledException) {
    return 'You cancelled the transaction';
  } else if (error is UpiIndiaNullResponseException) {
    return 'Requested app didn\'t return any response';
  } else if (error is UpiIndiaInvalidParametersException) {
    return 'Requested app cannot handle the transaction';
  } else {
    return 'An Unknown error has occurred';
  }
}

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset('assets/icons/youtube.png',height: 20,width: 20,),
          const SizedBox(width: 4,),
           Row(children: [
            Text('Developed by ',style: TextStyle(color: Colors.grey[700],fontSize: 12),),
            Text('@SSHegde.Visuals',style: TextStyle(color: Colors.grey[600],fontSize: 12),)
           ],)
        ],)
      ],
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.grey,
        leading: const Icon(Icons.arrow_back),
        title: const Text('UPI Payment',style: TextStyle(color: Colors.grey),),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text("About UPI",style: TextStyle(color: Colors.grey),),
                    content: const Text(
                      "UPI India is a plugin for Flutter that allows you to make UPI payments using various UPI apps available on the device. This plugin supports both Android and iOS platforms.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    actions: <Widget>[
                      
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close",style: TextStyle(color: Colors.white),),
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _amountController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Amount",
                        labelStyle: TextStyle(color: Colors.white60),
                        hintText: "Enter amount to send",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _upiIdController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Receiver's UPI ID",
                        labelStyle: TextStyle(color: Colors.white60),
                        hintText: "Enter receiver's UPI ID",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _receiverNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Receiver's Name",
                        labelStyle: TextStyle(color: Colors.white60),
                        hintText: "Enter receiver's name",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        displayUpiApps(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _amountController.text = '';
                              _upiIdController.text = '';
                              _receiverNameController.text = '';
                            });

                            // _transaction = initiateTransaction(apps!.first);
                            
                          },
                          child: const Text('Clear All',style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: _transaction,
                builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          _upiErrorHandler(snapshot.error.runtimeType),
                          style: header,
                        ),
                      );
                    }

                    UpiResponse _upiResponse = snapshot.data!;

                    String txnId = _upiResponse.transactionId ?? 'N/A';
                    String resCode = _upiResponse.responseCode ?? 'N/A';
                    String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                    String status = _upiResponse.status ?? 'N/A';
                    String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                    _checkTxnStatus(status);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          displayTransactionData('Transaction Id', txnId),
                          displayTransactionData('Response Code', resCode),
                          displayTransactionData('Reference Id', txnRef),
                          displayTransactionData('Status', status.toUpperCase()),
                          displayTransactionData('Approval No', approvalRef),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(''),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
