import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';

// final homeController = Get.put(HomeController());

class SalesScreenItems {
  static const String salesOrderId = 'mcSOrder';
  static const String salesInvoiceId = 'mcSReceipt';
  static const String salesManActivityId = 'activityToolStripMenuItem1';
  static const String receiptsId = 'maCashReceipt';
  static const String customerStatementId = 'mcCStatement';
  static const String dailySalesAnalysisId = 'toolStripMenuItem8';
  static const String salesProfitabilityId = 'toolStripMenuItem8';
  static const String salesPurchaseId = 'toolStripMenuItem8';
  static const String monthlySalesId = 'toolStripMenuItem8';
  static const String salesComparisonId = 'toolStripMenuItem8';
  static const String salesPersonCommissionId = 'toolStripMenuItem8';
  static const String salesByCustomerId = 'mrsSaleByCus';
  static const String merchandise = 'itemTransactionToolStripMenuItem';
  static const String creditlimit = 'CreditLimitVoucherToolStripMenuItem';
  static const String overdue = 'OverdueInvoiceControlToolStripMenuItem';

  static List<ScreenItemModel> SalesItems = [
    ScreenItemModel(
        title: 'Sales Order',
        menuId: salesOrderId,
        screenId: SalesScreenId.salesOrder,
        route: '${RouteManager.salesOrder}',
        icon: AppIcons.sales_order),
    ScreenItemModel(
        title: 'Sales Invoice',
        menuId: salesInvoiceId,
        screenId: SalesScreenId.salesInvoice,
        route: '${RouteManager.salesInvoice}',
        icon: AppIcons.invoice),
    ScreenItemModel(
        title: 'Salesman Activity',
        menuId: salesManActivityId,
        screenId: SalesScreenId.salesActivity,
        route: '${RouteManager.salesmanActivity}',
        icon: AppIcons.salesman),
    ScreenItemModel(
        title: 'Leads',
        menuId: salesManActivityId,
        screenId: SalesScreenId.leadDetails,
        route: '${RouteManager.leadList}',
        icon: AppIcons.salesman),
    ScreenItemModel(
        title: 'Receipts',
        menuId: receiptsId,
        screenId: SalesScreenId.cashReceipt,
        route: '${RouteManager.receipts}',
        icon: AppIcons.receipt),
    ScreenItemModel(
        title: 'Customer Statement',
        menuId: customerStatementId,
        screenId: SalesScreenId.customerStatement,
        route: '${RouteManager.customerStatement}',
        icon: AppIcons.statement),
    ScreenItemModel(
        title: 'Merchandise',
        menuId: merchandise,
        screenId: SalesScreenId.merchandise,
        route: '${RouteManager.merchandise}',
        icon: AppIcons.statement),
  ];

  static List<ScreenItemModel> SalesReportItems = [
    ScreenItemModel(
        title: 'Daily Sales Analysis',
        menuId: dailySalesAnalysisId,
        screenId: SalesScreenId.dailySalesAnalysis,
        route: '${RouteManager.dailySalesAnalysis}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Profitability',
        menuId: salesProfitabilityId,
        screenId: SalesScreenId.salesProfitability,
        route: '${RouteManager.salesProfitability}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Purchase Analysis',
        menuId: salesPurchaseId,
        screenId: SalesScreenId.salesPurchaseAnalysis,
        route: '${RouteManager.salesPurchaseAnalysis}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Monthly Sales',
        menuId: monthlySalesId,
        screenId: SalesScreenId.monthlySalesPivot,
        route: '${RouteManager.monthlySales}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Comparison',
        menuId: salesComparisonId,
        screenId: SalesScreenId.salesComparison,
        route: '${RouteManager.salesComparison}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales Person Commission',
        menuId: salesPersonCommissionId,
        screenId: SalesScreenId.salespersonCommision,
        route: '${RouteManager.salesPersonCommission}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Sales By Customer',
        menuId: salesByCustomerId,
        screenId: SalesScreenId.salesByCustomer,
        route: '${RouteManager.salesByCustomer}',
        icon: AppIcons.report),
  ];
}
