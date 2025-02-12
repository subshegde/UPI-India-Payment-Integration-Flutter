# UPI Payment Integration in Flutter

This Flutter project demonstrates how to integrate **UPI payments** using the `upi_india: ^3.0.1` package, allowing users to make UPI transactions directly from the app. It supports both Android and iOS platforms and provides a smooth and seamless experience.

## Features

- UPI payment integration with multiple UPI apps
- Simple and user-friendly UI for making payments
- Handles transaction status and error scenarios
- Supports transaction details display (Transaction ID, Response Code, etc.)

## Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/subshegde/UPI-India-Payment-Integration-Flutter.git

# Install dependencies
    flutter pub get
    
# How to Use:
# UI Flow
        Enter the amount, receiver's UPI ID, and receiver's name.
        Select a UPI app from the available apps list.
        Complete the transaction through the selected UPI app.
        
# Transaction Flow
        The app initiates the transaction and listens for the response (success, failure, or submission).
        The transaction status is displayed along with transaction details like Transaction ID, Response Code, Approval Ref, etc.

# Example

final UpiIndia _upiIndia = UpiIndia();

Future<UpiResponse> initiateTransaction(UpiApp app) async {
  double amount = 100.0;
  String receiverUpiId = 'receiver@upi';
  String receiverName = 'Receiver Name';

  return _upiIndia.startTransaction(
    app: app,
    receiverUpiId: receiverUpiId,
    receiverName: receiverName,
    transactionRefId: 'UniqueTransactionRef',
    transactionNote: 'Payment for services',
    amount: amount,
  );
}

# Dependencies
    upi_india: ^3.0.1: UPI payment handling package for Flutter.

# Error Handling

The app handles various error scenarios:
    App not installed (UpiIndiaAppNotInstalledException)
    User cancels transaction (UpiIndiaUserCancelledException)
    Invalid parameters (UpiIndiaInvalidParametersException)

# Screenshots

![UPI ](https://github.com/user-attachments/assets/5b4df1b5-a146-43ed-b1ab-dec5044e1e27)


# Contributing
Feel free to fork this repository, submit issues, or make pull requests. Contributions are welcome!

Developed with ❤️🍹  by🎥 @SSHegde.Visuals
