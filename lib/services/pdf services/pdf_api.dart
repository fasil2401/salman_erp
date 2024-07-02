import 'dart:io';
import 'dart:ui';
import 'package:axolon_erp/model/Sales%20Model/sales_order_print_model.dart';
import 'package:axolon_erp/utils/Calculations/inventory_calculations.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfApi {
  static Future<File> generatePdf(SalesOrderPrintModel object) async {
    PdfDocument document = PdfDocument();
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 30;
    PdfPage page = document.pages.add();
    final PdfGrid grid = _getGrid();
    _drawGrid(
      object,
      page,
      grid,
    );
    //Add invoice footer
    // _drawFooter(page, pageSize);
    //Save and dispose the document.

    return saveFile(document);
  }

  static Future<File> saveFile(
    PdfDocument doccument,
  ) async {
    final path = await getApplicationDocumentsDirectory();
    final fileName =
        path.path + '/AxolonSalesOrder${DateTime.now().toIso8601String()}.pdf';
    final file = File(fileName);

    file.writeAsBytes(await doccument.save());
    doccument.dispose();
    return file;
  }

  //Draws the grid
  static void _drawGrid(
    SalesOrderPrintModel object,
    PdfPage page,
    PdfGrid grid,
  ) {
    double boxHeight = 13;
    PdfGraphics graphics = page.graphics;
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    PdfBrush solidBrush = PdfSolidBrush(PdfColor(1, 66, 150));
    Rect bounds = Rect.fromLTWH(
        graphics.clientSize.width - graphics.clientSize.width * 0.3,
        0,
        graphics.clientSize.width * 0.3,
        boxHeight);

//Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

//Creates a text element to add the invoice number
    PdfTextElement element = PdfTextElement(text: '', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result =
        element.draw(page: page, bounds: Rect.fromLTWH(10, bounds.top, 0, 0))!;

//Use 'intl' package for date format.
    // String currentDate = 'DATE ' + DateFormat.yMMMd().format(DateTime.now());

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString('Sales Order');
    // Offset textPosition = Offset(
    //     graphics.clientSize.width - textSize.width - , result.bounds.top);

//Draws the date by using drawString method
    graphics.drawString('Sales Order', subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 50,
                result.bounds.top) &
            Size(textSize.width + 2, 20));
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - graphics.clientSize.width * 0.3,
            boxHeight,
            graphics.clientSize.width * 0.3,
            boxHeight),
        pen: PdfPen(PdfColor(1, 66, 150)));
    String docId =
        '${object.header![0].sysDocId} - ${object.header![0].voucherId}';
    Size docIdtSize = subHeadingFont.measureString(docId);
    element = PdfTextElement(
        text: docId,
        font: PdfStandardFont(PdfFontFamily.helvetica, 10,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(graphics.clientSize.width - docIdtSize.width - 50,
            result.bounds.top + boxHeight, docIdtSize.width, 12))!;

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - graphics.clientSize.width * 0.3,
            boxHeight * 2,
            (graphics.clientSize.width * 0.3) / 3,
            boxHeight),
        pen: PdfPen(PdfColor(1, 66, 150)));
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - graphics.clientSize.width * 0.3,
            boxHeight * 2,
            (graphics.clientSize.width * 0.3),
            boxHeight),
        pen: PdfPen(PdfColor(1, 66, 150)));
    element = PdfTextElement(
        text: 'Date',
        font: PdfStandardFont(PdfFontFamily.helvetica, 10,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - graphics.clientSize.width * 0.29,
            result.bounds.top + boxHeight,
            docIdtSize.width,
            boxHeight))!;
    String date = DateFormat.yMMMd().format(object.header![0].transactionDate!);
    Size dateSize = subHeadingFont.measureString(date);
    graphics.drawString(date, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - dateSize.width - 5,
                result.bounds.top) &
            Size(dateSize.width + 2, 20));
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - graphics.clientSize.width * 0.3,
            boxHeight * 3,
            graphics.clientSize.width * 0.3,
            boxHeight),
        pen: PdfPen(PdfColor(1, 66, 150)));

    String transactionNumber = 'TRN:100274453800003';
    Size transactionNumberSize =
        subHeadingFont.measureString(transactionNumber);

    element = PdfTextElement(
        text: transactionNumber,
        font: PdfStandardFont(PdfFontFamily.helvetica, 10,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - transactionNumberSize.width - 20,
            result.bounds.top + boxHeight,
            transactionNumberSize.width,
            boxHeight))!;

    graphics.drawRectangle(
        brush: solidBrush,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 10,
            graphics.clientSize.width * 0.4, boxHeight));
    graphics.drawRectangle(
        brush: solidBrush,
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - graphics.clientSize.width * 0.5,
            result.bounds.bottom + 10,
            graphics.clientSize.width * 0.5,
            boxHeight));
    element = PdfTextElement(
        text: 'To :',
        font: PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.white;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(
            10, result.bounds.top + 23, docIdtSize.width, boxHeight))!;
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(
            0, result.bounds.bottom, graphics.clientSize.width * 0.4, 60),
        pen: PdfPen(PdfColor(1, 66, 150)));
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.5,
            result.bounds.bottom, graphics.clientSize.width * 0.5, 60),
        pen: PdfPen(PdfColor(1, 66, 150)));
    graphics.drawString('FARZANA TRADING',
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.5 + 5,
            result.bounds.top, graphics.clientSize.width * 0.5, boxHeight));
    graphics.drawString(
        'Refrence',
        PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.regular),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(
            graphics.clientSize.width * 0.5 + 5,
            result.bounds.top + boxHeight,
            graphics.clientSize.width * 0.5,
            boxHeight));
    graphics.drawString(
        'Required Date',
        PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.regular),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(
            graphics.clientSize.width * 0.5 + 5,
            result.bounds.top + boxHeight * 2,
            graphics.clientSize.width * 0.5,
            boxHeight));
    graphics.drawString(
        'Payment Term',
        PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.regular),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(
            graphics.clientSize.width * 0.5 + 5,
            result.bounds.top + boxHeight * 3,
            graphics.clientSize.width * 0.5,
            boxHeight));
    graphics.drawString(
        'Currency',
        PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.regular),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(
            graphics.clientSize.width * 0.5 + 5,
            result.bounds.top + boxHeight * 4,
            graphics.clientSize.width * 0.5,
            boxHeight));

    String customer = object.header![0].customerName.toString();
    element = PdfTextElement(
        text: customer,
        font: PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.bold));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(5, result.bounds.top + boxHeight,
            graphics.clientSize.width * 0.39, 45))!;
    String tel = 'Tel : ${object.header![0].phone1}';
    element = PdfTextElement(
        text: tel,
        font: PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.regular));
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(5, result.bounds.top + 45,
            (graphics.clientSize.width * 0.4) / 2, boxHeight))!;
    graphics.drawString(
        'Fax : ${object.header![0].fax}',
        PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.regular),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(
            (graphics.clientSize.width * 0.4) / 2,
            result.bounds.top,
            (graphics.clientSize.width * 0.4) / 2,
            boxHeight));
//Draws a line at the bottom of the address
    // graphics.drawLine(
    //     PdfPen(PdfColor(126, 151, 173), width: 0.7),
    //     Offset(0, result.bounds.bottom + 3),
    //     Offset(graphics.clientSize.width, result.bounds.bottom + 3));

    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 6);

//Add header to the grid
    grid.headers.add(1);

//Set values to the header cells
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'SI#';
    header.cells[1].value = 'Description';
    header.cells[2].value = 'Unit';
    header.cells[3].value = 'Qty';
    header.cells[4].value = 'Rate';
    header.cells[5].value = 'Amount';

//Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(1, 66, 150));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font =
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold);

//Adds cell customizations
    for (int i = 0; i < header.cells.count; i++) {
      if (i == 0 || i == 1) {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle);
      } else {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle);
      }
      header.cells[i].style = headerStyle;
    }

//Add rows to grid
    PdfGridRow row;
    int index = 1;
    for (var element in object.detail!) {
      row = grid.rows.add();
      row.cells[0].value = index.toString();
      row.cells[1].value = element.description.toString();
      row.cells[2].value = element.unitId.toString();
      row.cells[3].value = element.quantity.toString();
      row.cells[4].value =
          InventoryCalculations.formatPrice(element.unitPrice.toDouble())
              .toString();
      row.cells[5].value =
          InventoryCalculations.formatPrice(element.total.toDouble())
              .toString();

      index++;
    }

    grid.columns[1].width = 230;
    grid.columns[0].width = 30;

//Set padding for grid cells
    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

//Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.helvetica, 8);
    cellStyle.textBrush = PdfBrushes.black;
//Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        if (j == 0 || j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle);
        } else if (j == 2) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.middle);
        }
      }
    }

//Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height),
        format: layoutFormat)!;

    gridResult.page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(
            0, gridResult.bounds.bottom + 10, graphics.clientSize.width, 60),
        pen: PdfPen(PdfColor(0, 0, 0)));
    gridResult.page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.6,
            gridResult.bounds.bottom + 10, graphics.clientSize.width * 0.4, 60),
        pen: PdfPen(PdfColor(0, 0, 0)));
    gridResult.page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.8,
            gridResult.bounds.bottom + 10, graphics.clientSize.width * 0.2, 15),
        pen: PdfPen(PdfColor(0, 0, 0)));

    gridResult.page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.8,
            gridResult.bounds.bottom + 25, graphics.clientSize.width * 0.2, 15),
        pen: PdfPen(PdfColor(0, 0, 0)));

    gridResult.page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.8,
            gridResult.bounds.bottom + 40, graphics.clientSize.width * 0.2, 15),
        pen: PdfPen(PdfColor(0, 0, 0)));

    gridResult.page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.8,
            gridResult.bounds.bottom + 55, graphics.clientSize.width * 0.2, 15),
        pen: PdfPen(PdfColor(0, 0, 0)));

    gridResult.page.graphics.drawString(
        object.header![0].totalInWords.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(10, gridResult.bounds.bottom + 15, 0, 0));

    gridResult.page.graphics.drawString('Subtotal :',
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.6 + 5,
            gridResult.bounds.bottom + 13, 0, 0));
    Size subTotalTextSize = subHeadingFont.measureString(
        InventoryCalculations.formatPrice(object.header![0].total.toDouble())
            .toString());
    gridResult.page.graphics.drawString(
        InventoryCalculations.formatPrice(object.header![0].total.toDouble())
            .toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - subTotalTextSize.width,
            gridResult.bounds.bottom + 13,
            0,
            0));

    gridResult.page.graphics.drawString('Discount :',
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.6 + 5,
            gridResult.bounds.bottom + 28, 0, 0));
    Size discountTextSize = subHeadingFont.measureString(
        InventoryCalculations.formatPrice(object.header![0].discount.toDouble())
            .toString());
    gridResult.page.graphics.drawString(
        InventoryCalculations.formatPrice(object.header![0].discount.toDouble())
            .toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - discountTextSize.width,
            gridResult.bounds.bottom + 28,
            0,
            0));

    gridResult.page.graphics.drawString('Vat 5% :',
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.6 + 5,
            gridResult.bounds.bottom + 43, 0, 0));
    Size taxTextSize = subHeadingFont.measureString(
        InventoryCalculations.formatPrice(object.header![0].tax.toDouble())
            .toString());
    gridResult.page.graphics.drawString(
        InventoryCalculations.formatPrice(object.header![0].tax.toDouble())
            .toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(graphics.clientSize.width - taxTextSize.width,
            gridResult.bounds.bottom + 43, 0, 0));

    gridResult.page.graphics.drawString('Total :',
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(graphics.clientSize.width * 0.6 + 5,
            gridResult.bounds.bottom + 58, 0, 0));
    Size grandTotalTextSize = subHeadingFont.measureString(
        InventoryCalculations.formatPrice(
                (object.header![0].grandTotal + object.header![0].tax)
                    .toDouble())
            .toString());
    gridResult.page.graphics.drawString(
        InventoryCalculations.formatPrice(
                (object.header![0].grandTotal + object.header![0].tax)
                    .toDouble())
            .toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(
            graphics.clientSize.width - grandTotalTextSize.width,
            gridResult.bounds.bottom + 58,
            0,
            0));

    gridResult.page.graphics.drawString(
        'Remarks :',
        PdfStandardFont(PdfFontFamily.helvetica, 8,
            style: PdfFontStyle.regular),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(5, gridResult.bounds.bottom + 80, 0, 0));

    // gridResult.page.graphics.drawString('Thank you for your business !',
    //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    //     brush: PdfBrushes.black,
    //     bounds: Rect.fromLTWH(100, gridResult.bounds.bottom + 60, 0, 0));
  }

  // //Draw the invoice footer data.
  // static void _drawFooter(PdfPage page, Size pageSize) {
  //   final PdfPen linePen =
  //       PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
  //   linePen.dashPattern = <double>[3, 3];
  //   //Draw line
  //   page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
  //       Offset(pageSize.width, pageSize.height - 100));
  //   const String footerContent =
  //       '800 Interchange Blvd.\r\n\r\nSuite 2501, Austin, TX 78721\r\n\r\nAny Questions? support@adventure-works.com';
  //   //Added 30 as a margin for the layout
  //   page.graphics.drawString(
  //       footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
  //       format: PdfStringFormat(alignment: PdfTextAlignment.right),
  //       bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  // }

  //Create PDF grid and return
  static PdfGrid _getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Total';
    _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    _addProducts(
        'LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  static void _addProducts(String productId, String productName, double price,
      int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }

  //Get the total amount.
  static double _getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }
}
