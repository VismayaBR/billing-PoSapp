import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../view_model/pos_screen_view_model.dart';

Future<Uint8List> generateInvoice(PosScreenViewModel pos) async {
  final pdf = pw.Document();

  try {
    // Load the font
    final ByteData fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final pw.Font ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start, // Adjust alignment of all children
            children: [
              // Center align the Invoice header
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text('Invoice', style: pw.TextStyle(font: ttf, fontSize: 24)),
              ),
              pw.SizedBox(height: 20),

              // Left align the "Items:" header
              pw.Text('Items:', style: pw.TextStyle(font: ttf, fontSize: 18), textAlign: pw.TextAlign.left),

              // Adjust the alignment of the item list
              pw.ListView.builder(
                itemCount: pos.cartItems.length,
                itemBuilder: (context, index) {
                  final item = pos.cartItems[index];
                  return pw.Container(
                    margin: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, // Space between name and price
                      children: [
                        // Left align the item name
                        pw.Text(item.name.toString(), style: pw.TextStyle(font: ttf, fontSize: 14)),
                        // Right align the item price
                        pw.Text('Qr ${item.price?.toStringAsFixed(2)}', style: pw.TextStyle(font: ttf, fontSize: 14)),
                      ],
                    ),
                  );
                },
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),

              // Right align the totals and discounts
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end, // Right align the content within the column
                  children: [
                    // pw.Text('Total: Qr ${pos.total.toStringAsFixed(2)}', style: pw.TextStyle(font: ttf, fontSize: 18)),
                    // pw.SizedBox(height: 10),
                    // pw.Text('Discount: Qr ${pos.discount.toStringAsFixed(2)}', style: pw.TextStyle(font: ttf, fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text('Total Payable: Qr ${(pos.total - pos.discount).toStringAsFixed(2)}', style: pw.TextStyle(font: ttf, fontSize: 18)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  } catch (e) {
    print('Error generating invoice PDF: $e');
    rethrow;
  }

  return pdf.save();
}
Future<void> shareInvoice(PosScreenViewModel pos) async {
  try {
    // Generate the invoice PDF
    final pdfBytes = await generateInvoice(pos);

    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();

    // Create a temporary file for the PDF
    final pdfFile = File('${tempDir.path}/invoice.pdf');

    // Write the PDF bytes to the file
    await pdfFile.writeAsBytes(pdfBytes);

    // Convert the file to an XFile object
    final xfile = XFile(pdfFile.path);

    // Share the PDF file directly via WhatsApp
    await Share.shareXFiles([xfile], text: 'Here is your invoice.');
  } catch (e) {
    print('Error sharing invoice: $e');
  }
}

