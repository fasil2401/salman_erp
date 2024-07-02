import 'package:axolon_erp/view/Announcement%20Screen/announcement_screen.dart';
import 'package:axolon_erp/view/Approval%20Sreen/approval_screen.dart';
import 'package:axolon_erp/view/Attendance%20Screen/attendance_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Employee%20Document%20Screen/employee_document_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Employee%20Ledger%20Screen/employee_ledger_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Employee%20Profile%20Screen/employee_profile_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Leave%20Request/leave_req_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Letter%20Request/letter_request_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Pay%20Slip/pay_slip_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/Inner%20Pages/Reinbursement%20Request/reimbursement_request_screen.dart';
import 'package:axolon_erp/view/Hr%20Screen/MyTask%20Screen/my_task_list_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/Inner%20Pages/Inventory%20Item%20List%20Screen/inventory_item_list_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/Inner%20Pages/Item%20Catalogue%20Screen/item_catalogue_screen.dart';
import 'package:axolon_erp/view/Inventory%20Screen/Inner%20Pages/Product%20Screen/product_screen.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/container_tracker_screen.dart';
import 'package:axolon_erp/view/Merchandise%20Screen/merchandise_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Customer%20Statement%20Screen/customer_statement_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Daily%20Sales%20Analysis/daily_sales_analysis_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Leads%20Screen/lead_list_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Leads%20Screen/leads_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Monthly%20Sales%20Screen/monthly_sales_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Reciepts/reciepts_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Comparsion/sales_comparison_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Invoice%20Screen/sales_invoice_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Order%20Screen/sales_order_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Person%20Commission/sales_person_commission_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20Purchase%20Analysis/sales_purchase_analysis_screen.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Sales%20by%20Customer%20Screen/sales_by_customers.dart';
import 'package:axolon_erp/view/SalesScreen/Inner%20Pages/Salesman%20Activity/salesman_activity_screen.dart';
import 'package:axolon_erp/view/components/redirect_screen.dart';
import 'package:axolon_erp/view/connection_settings/connection_screen.dart';
import 'package:axolon_erp/view/home_screen/home_screen.dart';
import 'package:axolon_erp/view/login_screen/login_screen.dart';
import 'package:axolon_erp/view/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

import '../../view/Inventory Screen/Inner Pages/Inventory Aging Screen/inventory_aging_screen.dart';
import '../../view/Inventory Screen/Inner Pages/Inventory Ledger Screen/inventory_ledger_screen.dart';
import '../../view/Inventory Screen/Inner Pages/Inventory Valuation Screen/inventory_valuation_screen.dart';
import '../../view/Inventory Screen/Inner Pages/Item Stock Screen/item_stock_screen.dart';
import '../../view/Inventory Screen/Inner Pages/Top Selling Products Screen/top_selling_products_Screen.dart';
import '../../view/SalesScreen/Inner Pages/Sales Profitability/sales_profitability_filter_screen.dart';
import '../../view/SalesScreen/Inner Pages/Sales Profitability/sales_profitability_screen.dart';

class RouteManager {
  static const String attendance = 'attendance';
  static const String productDetail = 'productDetail';
  static const String salesOrder = 'salesOrder';
  static const String salesInvoice = 'salesInvoice';
  static const String salesmanActivity = 'salesmanActivity';
  static const String dailySalesAnalysis = 'dailySalesAnalysis';
  static const String customerStatement = 'customerStatement';
  static const String merchandise = 'merchandise';
  static const String redirect = 'redirect';
  static const String lead = 'lead';
  static const String leadList = 'leadList';
  static const String leaveRequest = 'leaveRequest';
  static const String letterRequest = 'letterRequest';
  static const String reimbursementRequest = 'reimbursementRequest';
  static const String employeeDocument = 'employeeDocument';
  static const String payslip = 'payslip';
  static const String itemCatalogue = 'itemCatalogue';
  static const String salesProfitability = 'salesProfitability';
  static const String salesByCustomer = 'salesByCustomers';
  static const String salesProfitabilityFilter = 'salesProfitabilityFilter';
  static const String salesComparison = 'salesComparison';
  static const String monthlySales = 'monthlySales';
  static const String salesPurchaseAnalysis = 'salesPurchaseAnalysis';
  static const String salesPersonCommission = 'salesPersonCommission';
  static const String inventoryAging = 'inventoryAging';
  static const String inventoryLedger = 'inventoryLedger';
  static const String inventoryValuation = 'inventoryValuation';
  static const String topSellingProducts = 'topSellingProducts';
  static const String employeeLedger = 'employeeLedger';
  static const String employeeProfile = 'employeeProfile';
  static const String itemStock = 'itemStock';
  static const String receipts = 'receipts';
  static const String containerTracker = 'containerTracker';
  static const String itemList = 'itemList';
  static const String myTask = 'myTask';
  static const String announcement = 'announcement';
  static const String approvals = 'approvals';

  List<GetPage> _routes = [
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/connection',
      page: () => ConnectionScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$attendance',
      page: () => AttendanceScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$productDetail',
      page: () => ProductDetails(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$announcement',
      page: () => AnnouncementScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesOrder',
      page: () => SalesOrderScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesInvoice',
      page: () => SalesInvoiceScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$dailySalesAnalysis',
      page: () => DailySalesAnalysisScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$customerStatement',
      page: () => CustomerStatementScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$merchandise',
      page: () => MerchandiseScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$redirect',
      page: () => RedirectScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$lead',
      page: () => LeadsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesmanActivity',
      page: () => SalesmanActivityScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$receipts',
      page: () => ReceiptsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$containerTracker',
      page: () => ContainerTrackerScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$leaveRequest',
      page: () => LeaveReqScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$letterRequest',
      page: () => LetterRequestScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$reimbursementRequest',
      page: () => ReimbursementRequestScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$employeeDocument',
      page: () => EmployeeDocumentScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$payslip',
      page: () => PaySlipScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$myTask',
      page: () => MyTaskScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$itemCatalogue',
      page: () => ItemCatalogueScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesProfitability',
      page: () => SalesProfitabilityScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesByCustomer',
      page: () => SalesByCustomersScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesComparison',
      page: () => SalesComparisonScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$monthlySales',
      page: () => MonthlySalesScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesPurchaseAnalysis',
      page: () => SalesPurchaseAnalysisScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$salesPersonCommission',
      page: () => SalesPersonCommissionScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$inventoryAging',
      page: () => InventoryAgingScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$inventoryLedger',
      page: () => InventoryLedgerScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$inventoryValuation',
      page: () => InventoryValuationScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$topSellingProducts',
      page: () => TopSellingProductsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$employeeLedger',
      page: () => EmployeeLedgerScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$employeeProfile',
      page: () => EmployeeProfileScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$itemStock',
      page: () => ItemStockScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$itemList',
      page: () => InventoryItemListScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$leadList',
      page: () => LeadListScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: '/$approvals',
      page: () => ApprovalScreen(),
      transition: Transition.cupertino,
    ),
  ];

  get routes => _routes;
}
