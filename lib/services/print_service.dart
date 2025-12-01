import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class PrintService {
  static Future<Uint8List> generateReceiptPdf({
    required List<Map<String, dynamic>> cartItems,
    required double total,
    required String paymentMethod,
    required String transactionId,
    required double paidAmount,
    required double change,
    String customerName = '',
  }) async {
    final pdf = pw.Document();

    // Load a custom font if available, otherwise use default
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'KASIR APP',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 24,
                          color: PdfColors.blue,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Struk Pembayaran',
                        style: pw.TextStyle(font: font, fontSize: 16),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        DateTime.now().toString().split('.')[0],
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                          color: PdfColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 30),

                // Transaction ID
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'ID Transaksi:',
                      style: pw.TextStyle(font: font, fontSize: 12),
                    ),
                    pw.Text(
                      transactionId,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 8),

                // Customer name (if provided)
                if (customerName.isNotEmpty) ...[
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Customer:',
                        style: pw.TextStyle(font: font, fontSize: 12),
                      ),
                      pw.Text(
                        customerName,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                ] else ...[
                  pw.SizedBox(height: 12),
                ],

                // Items header
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey, width: 1),
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          'Item',
                          style: pw.TextStyle(font: fontBold, fontSize: 12),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          'Qty',
                          style: pw.TextStyle(font: fontBold, fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          'Harga',
                          style: pw.TextStyle(font: fontBold, fontSize: 12),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),

                // Items list
                ...cartItems.map(
                  (item) => pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 6),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            item['name'],
                            style: pw.TextStyle(font: font, fontSize: 11),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            '${item['quantity']}',
                            style: pw.TextStyle(font: font, fontSize: 11),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            'Rp ${(item['price'] * item['quantity']).toStringAsFixed(0)}',
                            style: pw.TextStyle(font: font, fontSize: 11),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                pw.SizedBox(height: 10),

                // Total
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.grey, width: 1),
                      bottom: pw.BorderSide(color: PdfColors.grey, width: 1),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(font: fontBold, fontSize: 14),
                      ),
                      pw.Text(
                        'Rp ${total.toStringAsFixed(0)}',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 14,
                          color: PdfColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 15),

                // Payment details
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(8),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Metode Pembayaran',
                            style: pw.TextStyle(font: font, fontSize: 11),
                          ),
                          pw.Text(
                            _getPaymentMethodDisplayName(paymentMethod),
                            style: pw.TextStyle(font: fontBold, fontSize: 11),
                          ),
                        ],
                      ),
                      if (paymentMethod == 'cash') ...[
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Uang Dibayar',
                              style: pw.TextStyle(font: font, fontSize: 11),
                            ),
                            pw.Text(
                              'Rp ${paidAmount.toStringAsFixed(0)}',
                              style: pw.TextStyle(font: font, fontSize: 11),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Kembalian',
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                                color: change >= 0
                                    ? PdfColors.green
                                    : PdfColors.red,
                              ),
                            ),
                            pw.Text(
                              'Rp ${change.toStringAsFixed(0)}',
                              style: pw.TextStyle(
                                font: fontBold,
                                fontSize: 12,
                                color: change >= 0
                                    ? PdfColors.green
                                    : PdfColors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                pw.SizedBox(height: 30),

                // Footer
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Terima Kasih Atas Kunjungan Anda',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Simpan struk ini sebagai bukti pembayaran',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printReceipt({
    required List<Map<String, dynamic>> cartItems,
    required double total,
    required String paymentMethod,
    required String transactionId,
    required double paidAmount,
    required double change,
    String customerName = '',
  }) async {
    try {
      final pdfBytes = await generateReceiptPdf(
        cartItems: cartItems,
        total: total,
        paymentMethod: paymentMethod,
        transactionId: transactionId,
        paidAmount: paidAmount,
        change: change,
        customerName: customerName,
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'Receipt_$transactionId',
      );
    } catch (e) {
      throw Exception('Failed to print receipt: $e');
    }
  }

  static Future<void> shareReceipt({
    required List<Map<String, dynamic>> cartItems,
    required double total,
    required String paymentMethod,
    required String transactionId,
    required double paidAmount,
    required double change,
    String customerName = '',
  }) async {
    try {
      final pdfBytes = await generateReceiptPdf(
        cartItems: cartItems,
        total: total,
        paymentMethod: paymentMethod,
        transactionId: transactionId,
        paidAmount: paidAmount,
        change: change,
        customerName: customerName,
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'Receipt_$transactionId.pdf',
      );
    } catch (e) {
      throw Exception('Failed to share receipt: $e');
    }
  }

  static Future<void> shareReceiptToWhatsApp({
    required List<Map<String, dynamic>> cartItems,
    required double total,
    required String paymentMethod,
    required String transactionId,
    required double paidAmount,
    required double change,
    String customerName = '',
  }) async {
    try {
      // Generate PDF receipt
      final pdfBytes = await generateReceiptPdf(
        cartItems: cartItems,
        total: total,
        paymentMethod: paymentMethod,
        transactionId: transactionId,
        paidAmount: paidAmount,
        change: change,
        customerName: customerName,
      );

      // Create XFile from PDF bytes
      final pdfFile = XFile.fromData(
        pdfBytes,
        name: 'Receipt_$transactionId.pdf',
        mimeType: 'application/pdf',
      );

      // Share PDF to WhatsApp
      await Share.shareXFiles(
        [pdfFile],
        text: 'Struk Pembayaran - $transactionId',
        subject: 'Struk Pembayaran - $transactionId',
      );
    } catch (e) {
      throw Exception('Failed to share receipt to WhatsApp: $e');
    }
  }

  static String _generateReceiptText({
    required List<Map<String, dynamic>> cartItems,
    required double total,
    required String paymentMethod,
    required String transactionId,
    required double paidAmount,
    required double change,
  }) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('🧾 *KASIR APP*');
    buffer.writeln('Struk Pembayaran');
    buffer.writeln('Tanggal: ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln('ID Transaksi: $transactionId');
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════');

    // Items header
    buffer.writeln('📦 ITEM YANG DIBELI:');
    buffer.writeln('');

    // Items list with better formatting
    for (final item in cartItems) {
      final itemName = item['name'].toString();
      final quantity = item['quantity'].toString();
      final price =
          'Rp ${(item['price'] * item['quantity']).toStringAsFixed(0)}';

      // Format: Item Name xQty - Price
      buffer.writeln('$itemName x$quantity - $price');
    }

    buffer.writeln('');
    buffer.writeln('═══════════════════════════════');

    // Total
    buffer.writeln('💰 TOTAL: Rp ${total.toStringAsFixed(0)}');
    buffer.writeln(
      'Metode Pembayaran: ${_getPaymentMethodDisplayName(paymentMethod)}',
    );

    // Cash payment details
    if (paymentMethod == 'cash') {
      buffer.writeln('Uang Dibayar: Rp ${paidAmount.toStringAsFixed(0)}');
      buffer.writeln('Kembalian: Rp ${change.toStringAsFixed(0)}');
    }

    buffer.writeln('');
    buffer.writeln('═══════════════════════════════');
    buffer.writeln('🙏 Terima Kasih Atas Kunjungan Anda!');
    buffer.writeln('Simpan struk ini sebagai bukti pembayaran.');

    return buffer.toString();
  }

  static String _getPaymentMethodDisplayName(String method) {
    switch (method) {
      case 'cash':
        return 'Tunai';
      case 'dana':
        return 'DANA';
      case 'gopay':
        return 'GoPay';
      case 'qris':
        return 'QRIS';
      case 'bca':
        return 'BCA';
      case 'mandiri':
        return 'Mandiri';
      case 'bni':
        return 'BNI';
      case 'bri':
        return 'BRI';
      default:
        return method;
    }
  }
}
