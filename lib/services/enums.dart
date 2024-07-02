import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:flutter/material.dart';

enum MyTask {
  AssignedToMe(1, 'Assigned To Me'),
  CreatedBy(2, 'Created By'),
  Involved(3, 'Involved');

  const MyTask(this.value, this.name);
  final int value;
  final String name;
  static int getValueFromName(String name) {
    for (var task in MyTask.values) {
      if (task.name == name) {
        return task.value;
      }
    }
    throw Exception('No enum value found for name: $name');
  }
}

enum ApprovalTypeStatus {
  Pending(1, 'Pending', AppIcons.clock, Colors.amber),
  Waiting(2, 'Waiting', AppIcons.clock, Colors.amber),
  Rejected(3, 'Rejected', AppIcons.reject, AppColors.error),
  Approved(10, 'Approved', AppIcons.tick, AppColors.success),
  Submitted(12, 'Submitted', AppIcons.up, AppColors.success),
  Created(11, 'Created', AppIcons.plus, Colors.amber);

  const ApprovalTypeStatus(this.value, this.name, this.icon, this.color);
  final int value;
  final String name;
  final String icon;
  final Color color;
}

enum FollowUpStatus {
  Open(1, 'Open', AppColors.success),
  InProgress(5, 'InProgress', Color(0xFFFF8000)),
  Completed(10, 'Completed', AppColors.primary);

  final int value;
  final String name;
  final Color color;

  const FollowUpStatus(this.value, this.name, this.color);
}

enum Priority {
  High(0, 'High', AppColors.error),
  Low(1, 'Low', AppColors.warning),
  Medium(2, 'Medium', AppColors.success);

  const Priority(this.value, this.name, this.color);
  final int value;
  final String name;
  final Color color;
}

enum ItemTypes {
  none(0, 'None'),
  inventory(1, 'Inventory'),
  nonInventory(2, 'NonInventory'),
  service(3, 'Service'),
  discount(4, 'Discount'),
  consignmentItem(5, 'ConsignmentItem'),
  matrix(6, 'Matrix'),
  assembly(7, 'Assembly'),
  projectFee(8, 'ProjectFee'),
  inventory3PL(9, 'Inventory3PL'),
  kit(10, 'Kit');

  const ItemTypes(this.value, this.name);
  final int value;
  final String name;
}

enum CreditControlType {
  creditlimit(1, 'CreditLimit'),
  overdue(2, 'Overdue');

  const CreditControlType(this.value, this.name);
  final int value;
  final String name;
}

enum ActionStatusType {
  None(0, 'None'),
  Packing(1, 'Packing'),
  Lead(2, 'Lead'),
  Employee(3, 'Employee');

  const ActionStatusType(this.value, this.name);
  final int value;
  final String name;
}

enum EmployeeActivityTypes {
  General(1, 'General'),
  Hire(2, 'Hire'),
  Rehire(3, 'Rehire'),
  Promotion(4, 'Promotion'),
  Transfer(5, 'Transfer'),
  Vacation(6, 'Vacation'),
  Leave(7, 'Leave'),
  Training(8, 'Training'),
  DisciplinaryAction(9, 'DisciplinaryAction'),
  Termination(10, 'Termination'),
  SalaryChange(11, 'SalaryChange'),
  Resumption(12, 'Resumption'),
  LeaveEncashment(13, 'LeaveEncashment'),
  LeavePayment(14, 'LeavePayment'),
  Cancelation(15, 'Cancelation'),
  PassportControl(16, 'PassportControl'),
  Absconding(17, 'Absconding'),
  ;

  const EmployeeActivityTypes(this.value, this.name);
  final int value;
  final String name;
}

enum SalesOptons {
  SalesOrder(1, 'SalesOrder'),
  CustomerStatement(2, 'CustomerStatement');

  const SalesOptons(this.value, this.name);
  final int value;
  final String name;
}

enum MenuOptions {
  Inventory(1, 'Inventory'),
  Sales(2, 'Sales'),
  HR(3, 'HR'),
  Logistics(3, 'HR'),
  Dashboard(4, 'Dashboard');

  const MenuOptions(this.value, this.name);
  final int value;
  final String name;
}

enum BottomMenu {
  Dashboard(1, 'Dashboard'),
  Approval(2, 'Approval'),
  Favorite(3, 'Favorite'),
  Profile(4, 'Profile'),
  Common(5, 'Common');

  const BottomMenu(this.value, this.name);
  final int value;
  final String name;
}

enum ScreenRightOptions {
  View(1, 'view'),
  Edit(2, 'edit'),
  Add(3, 'add'),
  Delete(4, 'delete');

  const ScreenRightOptions(this.value, this.name);
  final int value;
  final String name;
}

enum RelatedtypeOptions {
  Lead(1, 'Lead'),
  Customers(4, 'Customers');

  const RelatedtypeOptions(this.value, this.name);
  final int value;
  final String name;
}

enum EntityType {
  Transactions(12, 'Transactions'),
  JobTask(38, 'JobTask');

  const EntityType(this.value, this.name);
  final int value;
  final String name;
}

enum FilterComboOptions {
  Customer(1, 'Customer'),
  Class(2, 'Class'),
  Group(3, 'Group'),
  Area(4, 'Area'),
  Country(5, 'Country'),
  Item(6, 'Item'),
  ItemClass(7, 'ItemClass'),
  ItemCategory(8, 'ItemCategory'),
  ItemBrand(9, 'ItemBrand'),
  ItemManufacture(10, 'ItemManufacture'),
  ItemOrigin(11, 'ItemOrigin'),
  ItemStyle(12, 'ItemStyle'),
  SalesPerson(13, 'SalesPerson'),
  SalesPersonDivision(14, 'SalesPersonDivision'),
  SalesPersonGroup(15, 'SalesPersonGroup'),
  SalesPersonArea(16, 'SalesPersonArea'),
  SalesPersonCountry(17, 'SalesPersonCountry'),
  Location(18, 'Location'),
  Employees(19, 'Employees'),
  EmployeeDepartment(20, 'EmployeeDepartment'),
  EmployeeLocation(21, 'EmployeeLocation'),
  EmployeeType(22, 'EmployeeType'),
  EmployeeSponsor(23, 'EmployeeSponsor'),
  EmployeeGroup(24, 'EmployeeGroup'),
  EmployeeGrade(25, 'EmployeeGrade'),
  EmployeePosition(26, 'EmployeePosition'),
  Bank(27, 'Bank'),
  Account(28, 'Account'),
  ;

  const FilterComboOptions(this.value, this.name);
  final int value;
  final String name;
}

enum SysdocType {
  None(-1, 'None'),
  Other(0, 'Other'),
  GJournal(1, 'G Journal'),
  ChequeReceipt(2, 'Cheque Receipt'),
  CashReceipt(3, 'Cash Receipt'),
  CashPayment(4, 'Cash Payment'),
  ChequePayment(5, 'Cheque Payment'),
  FundTransfer(6, 'Fund Transfer'),
  ChequeDeposit(7, 'Cheque Deposit'),
  CashExpense(8, 'Cash Expense'),
  ChequeExpense(9, 'Cheque Expense'),
  DebitNote(10, 'Debit Note'),
  CreditNote(11, 'Credit Note'),
  ReturnedCheque(12, 'Returned Cheque'),
  ReceivedChequeCancellation(13, 'Received Cheque Cancellation'),
  IssuedChequeClearance(14, 'Issued Cheque Clearance'),
  IssuedChequeCancellation(15, 'Issued Cheque Cancellation'),
  IssuedChequeReturn(16, 'Issued Cheque Return'),
  IssuedSecurityCheque(17, 'Issued Security Cheque'),
  InventoryAdjustment(18, 'Inventory Adjustment'),
  TransitTransferOut(19, 'Transit Transfer Out'),
  TransitTransferIn(20, 'Transit Transfer In'),
  ReturnTransitTransfer(21, 'Return Transit Transfer'),
  SalesQuote(22, 'Sales Quote'),
  SalesOrder(23, 'Sales Order'),
  DeliveryNote(24, 'Delivery Note'),
  SalesInvoice(25, 'Sales Invoice'),
  SalesReceipt(26, 'Sales Receipt'),
  CreditSalesReturn(27, 'Credit Sales Return'),
  CashSalesReturn(28, 'Cash Sales Return'),
  DeliveryReturn(29, 'Delivery Return'),
  PurchaseQuote(30, 'Purchase Quote'),
  PurchaseOrder(31, 'Purchase Order'),
  GoodsReceivedNote(32, 'Goods Received Note'),
  PurchaseInvoice(33, 'Purchase Invoice'),
  CashPurchase(34, 'Cash Purchase'),
  CashPurchaseReturn(35, 'Cash Purchase Return'),
  PackingList(36, 'Packing List'),
  CreditPurchaseReturn(37, 'Credit Purchase Return'),
  ImportPurchaseOrder(38, 'Import Purchase Order'),
  ImportPurchaseInvoice(39, 'Import Purchase Invoice'),
  DirectInventoryTransfer(40, 'Direct Inventory Transfer'),
  Deposit(41, 'Deposit'),
  Expense(42, 'Expense'),
  SalarySheet(43, 'Salary Sheet'),
  PayrollTransaction(44, 'Payroll Transaction'),
  EmployeeLoan(45, 'Employee Loan'),
  SalesPOS(46, 'Sales POS'),
  ConsignOut(47, 'Consign Out'),
  ConsignOutSettlement(48, 'Consign Out Settlement'),
  ExchangeGainLoss(49, 'Exchange Gain Loss'),
  ImportGoodsReceivedNote(50, 'Import Goods Received Note'),
  ExportSalesInvoice(51, 'Export Sales Invoice'),
  ExportSalesOrder(52, 'Export Sales Order'),
  ExportDeliveryNote(53, 'Export Delivery Note'),
  ConsignOutReturn(54, 'Consign Out Return'),
  ConsignIn(55, 'Consign In'),
  ConsignInSettlement(56, 'Consign In Settlement'),
  ConsignInReturn(57, 'Consign In Return'),
  FixedAssetPurchase(58, 'Fixed Asset Purchase'),
  FixedAssetTransfer(59, 'Fixed Asset Transfer'),
  FixedAssetSale(60, 'Fixed Asset Sale'),
  FixedAssetDep(61, 'Fixed Asset Dep'),
  ReturnPOS(62, 'Return POS'),
  ProformaInvoice(63, 'Proforma Invoice'),
  TTPayment(64, 'TT Payment'),
  TTReceipt(65, 'TTReceipt'),
  CashReceiptMultiple(66, 'Cash Receipt Multiple'),
  AssemblyBuild(67, 'Assembly Build'),
  EmployeeLoanPayment(68, 'Employee Loan Payment'),
  SalaryPaymentCash(69, 'Salary Payment Cash'),
  SalaryPaymentCheque(70, 'Salary Payment Cheque'),
  JobInventoryIssue(71, 'Job Inventory Issue'),
  JobInventoryReturn(72, 'Job Inventory Return'),
  JobExpenseIssue(73, 'Job Expense Issue'),
  JobInvoice(74, 'Job Invoice'),
  JobReceipt(75, 'Job Receipt'),
  JobTimesheet(76, 'Job Timesheet'),
  JobMaterialRequisition(77, 'Job Material Requisition'),
  WorkOrder(78, 'Work Order'),
  TR(79, 'TR'),
  TRPayment(80, 'TR Payment'),
  JobClosing(81, 'Job Closing'),
  JobMaterialEstimate(82, 'Job Material Estimate'),
  SendChequesToBank(83, 'Send Cheques To Bank'),
  ChequeDiscount(84, 'Cheque Discount'),
  OverTimeEntry(85, 'Over Time Entry'),
  PriceList(86, 'Price List'),
  InventoryNoneSale(87, 'Inventory None Sale'),
  OpeningInventory(88, 'Opening Inventory'),
  InventoryRepacking(89, 'Inventory Repacking'),
  ConsignInClosing(90, 'Consign In Closing'),
  ExportPackingList(91, 'Export Packing List'),
  EmployeeLeaveEncashment(92, 'Employee Leave Encashment'),
  EmployeeLeavePayment(93, 'Employee Leave Payment'),
  LPOReceipt(94, 'LPO Receipt'),
  GRNReturn(95, 'GRN Return'),
  ChangeReceiveStatus(96, 'Change Receive Status'),
  QualityClaim(97, 'Quality Claim'),
  ArrivalReport(98, 'Arrival Report'),
  SalaryPaymentBank(99, 'Salary Payment Bank'),
  PaymentRequest(100, 'Payment Request'),
  PropertyRental(101, 'Property Rental'),
  PropertyRenew(102, 'Property Renew'),
  PropertyCancel(103, 'Property Cancel'),
  PropertyRentPost(104, 'Property Rent Post'),
  W3PLGRN(105, 'W3PLGRN'),
  W3PLDelivery(106, 'W3PL Delivery'),
  W3PLInvoice(107, 'W3PL Invoice'),
  ProjectExpenseAllocation(108, 'Project Expense Allocation'),
  PurchaseClaim(109, 'Purchase Claim'),
  JobEstimation(110, 'Job Estimation'),
  EmployeeLoanSettlement(111, 'Employee Loan Settlement'),
  GarmentRental(112, 'Garment Rental'),
  GarmentRentalReturn(113, 'Garment Rental Return'),
  CRMActivity(114, 'CRM Activity'),
  PurchaseOrderNI(115, 'Purchase Order NI'),
  PurchaseInvoiceNI(116, 'Purchase Invoice NI'),
  DirectInventoryTransferTemp(117, 'Direct Inventory Transfer Temp'),
  SalesEnquiry(118, 'Sales Enquiry'),
  SalesProforma(119, 'Sales Proforma'),
  ServiceCallTrack(120, 'Service Call Track'),
  CustomerAllocationGainLoss(200, 'Customer Allocation Gain Loss'),
  OpeningBalanceCustomer(202, 'Opening Balance Customer'),
  OpeningBalanceVendor(203, 'Opening Balance Vendor'),
  OpeningBalanceEmployee(204, 'Opening Balance Employee'),
  OpeningBalanceItem(205, 'Opening Balance Item'),
  OpeningBalanceLeave(206, 'Opening Balance Leave'),
  FixedAssetBulkPurchase(207, 'Fixed Asset Bulk Purchase'),
  ExportPickList(208, 'Export Pick List'),
  MaintenanceScheduler(209, 'Maintenance Scheduler'),
  JobMaintenanceSchedule(210, 'Job Maintenance Schedule'),
  JobMaintenanceServiceEntry(211, 'Job Maintenance Service Entry'),
  MaintenanceEntry(212, 'Maintenance Entry'),
  PurchaseCostEntry(213, 'Purchase Cost Entry'),
  ContainerTracking(214, 'Container Tracking'),
  ProjectSubContractPO(215, 'Project Sub Contract PO'),
  CustomerInsuranceReview(216, 'Customer Insurance Review'),
  CLVoucher(217, 'CL Voucher'),
  ProjectSubContractPI(218, 'Project Sub Contract PI'),
  CreditLimitReview(219, 'Credit Limit Review'),
  EmployeeGeneralActivity(220, 'Employee General Activity'),
  EmployeeAppraisal(221, 'Employee Appraisal'),
  EmployeePerformance(222, 'Employee Performance'),
  BOLList(223, 'BOL List'),
  Requisition(224, 'Requisition'),
  Mobilization(225, 'Mobilization'),
  EquipmentTransfer(226, 'Equipment Transfer'),
  EquipmentWorkOrder(227, 'Equipment Work Order'),
  LegalActivity(228, 'Legal Activity'),
  WorkOrderInventoryIssue(229, 'Work Order Inventory Issue'),
  WorkOrderInventoryReturn(230, 'Work Order Inventory Return'),
  FreightCharges(231, 'Freight Charges'),
  InventoryDismantle(232, 'Inventory Dismantle'),
  ProductPriceBulkUpdate(233, 'Product Price Bulk Update'),
  OpeningChequeReceipt(234, 'Opening Cheque Receipt'),
  OpeningChequePayment(235, 'Opening Cheque Payment'),
  MaterialReservation(236, 'Material Reservation'),
  AllocationDiscount(237, 'Allocation Discount'),
  CustomerAllocationDiscount(238, 'Customer Allocation Discount'),
  VendorAllocationDiscount(239, 'Vendor Allocation Discount'),
  LegalAction(240, 'Legal Action'),
  CustomerUnAllocationAmount(241, 'Customer Un Allocation Amount'),
  VendorUnAllocationAmount(242, 'Vendor Un Allocation Amount'),
  SalesForecasting(243, 'Sales Forecasting'),
  PurchasePrepaymentInvoice(244, 'Purchase Prepayment Invoice'),
  PurchasePrepaymentApplied(245, 'Purchase Prepayment Applied'),
  TaskTransaction(246, 'Task Transaction'),
  TaskTransactionStatus(247, 'Task Transaction Status'),
  TRApplication(248, 'TR Application'),
  Budgeting(249, 'Budgeting'),
  VehicleMileageTrack(250, 'Vehicle Mileage Track'),
  SalesTarget(251, 'Sales Target'),
  CustomerInsuranceClaim(252, 'Customer Insurance Claim'),
  ChequeReceiptMultiple(253, 'Cheque Receipt Multiple'),
  LoanEntry(254, 'Loan Entry'),
  PropertyServiceRequest(255, 'Property Service Request'),
  VendorPriceList(256, 'Vendor Price List'),
  JobManHrsBudgeting(257, 'Job Man Hrs Budgeting'),
  PropertyServiceAssign(258, 'Property Service Assign'),
  SalesInvoiceNI(259, 'Sales Invoice NI'),
  PropertyServiceInvoice(260, 'Property Service Invoice'),
  FixedAssetPurchaseOrder(261, 'Fixed Asset Purchase Order'),
  EmployeeProvision(262, 'Employee Provision'),
  EmployeeEOS(263, 'Employee EOS'),
  Production(264, 'Production'),
  ExportSalesProfoma(265, 'Export Sales Profoma'),
  Shipment(266, 'Shipment'),
  BillDiscount(267, 'Bill Discount'),
  BankCharges(268, 'Bank Charges'),
  PropertyServiceContract(269, 'Property Service Contract'),
  OverdueInvoice(270, 'Overdue Invoice'),
  PropertyCancellationRequest(271, 'Property Cancellation Request'),
  EmployeeReimbursementRequest(272, 'Employee Reimbursement Request'),
  FixedAssetAudit(273, 'Fixed Asset Audit'),
  EmployeeLetterIssue(274, 'Employee Letter Issue'),
  JobBudgetDetail(275, 'Job Budget Detail'),
  EmployeeRoster(276, 'Employee Roster'),
  EmployeeRosterException(277, 'Employee Roster Exception'),
  JobEquipmentTimeTracking(278, 'Job Equipment Time Tracking'),
  ServiceOrder(279, 'Service Order'),
  ServiceDetail(280, 'Service Detail'),
  DeliveryList(281, 'Delivery List'),
  ServiceInvoice(282, 'Service Invoice'),
  ServiceWorkOrder(283, 'Service Work Order'),
  CostAllocation(284, 'Cost Allocation'),
  LeaveRequest(285, 'Leave Request'),
  EmployeeAttendance(286, 'Employee Attendance'),
  EmployeeAttendanceSheet(287, 'Employee Attendance Sheet'),
  EcomPackingList(288, 'Ecom Packing List'),
  assignToDriver(289, 'assign To Driver'),
  ServiceProforma(290, 'Service Proforma'),
  EcomSalesOrder(291, 'Ecom Sales Order'),
  SalaryAddition(292, 'Salary Addition'),
  SalaryDeduction(293, 'Salary Deduction'),
  AirLineTicketRequest(294, 'AirLine Ticket Request'),
  PropertyEnquiry(295, 'Property Enquiry'),
  CandidateRequest(296, 'Candidate Request'),
  CandidateShortList(297, 'Candidate ShortList'),
  EmployeeBenefitExpense(298, 'Employee Benefit Expense'),
  EmployeeDisciplineAction(299, 'Employee Discipline Action'),
  EmployeeAttendanceRequest(300, 'Employee Attendance Request'),
  PropertyUtility(301, 'Property Utility'),
  JobMaterialPlanning(302, 'Job Material Planning'),
  ProjectManPowerPlanning(303, 'Project ManPower Planning'),
  ProjectBudgetPlan(304, 'Project Budget Plan'),
  ProjectEquipmentPlanning(305, 'Project Equipment Planning'),
  ProjectSubContractPlanning(306, 'Project Sub Contract Planning'),
  ProjectEquipmentRequest(307, 'Project Equipment Request'),
  ProjectManPowerRequest(308, 'Project ManPower Request'),
  ProjectBudgetRequest(309, 'Project Budget Request'),
  ProjectSubContractRequest(310, 'Project Sub Contract Request'),
  ProjectSubContractEstimation(311, 'Project Sub Contract Estimation'),
  ProjectSubContractProgressTracking(
      312, 'Project Sub Contract Progress Tracking'),
  PurchaseRequisition(313, 'Purchase Requisition'),
  JobEquipment(314, 'Job Equipment'),
  StockSnapShot(315, 'Stock SnapShot'),
  EmployeeLetterIssueRequest(316, 'Employee Letter Issue Request'),
  EmployeeAnnouncement(317, 'Employee Announcement'),
  EmployeeCancelationRequest(318, 'Employee Cancelation Request'),
  EmployeeCancelation(319, 'Employee Cancelation'),
  CommisionCalculation(320, 'Commision Calculation'),
  Appointment(321, 'Appointment'),
  LandLordPaymentBooking(322, 'LandLord Payment Booking'),
  EmployeeSalaryRevisionRequest(330, 'EmployeeSalaryRevisionRequest'),
  EmployeeSalaryRevision(331, 'EmployeeSalaryRevision'),
  LoyaltyPointAdjustment(323, 'Loyalty Point Adjustment'),
  ItemTransaction(334, 'Item Transaction');

  const SysdocType(this.value, this.name);
  final int value;
  final String name;
}

enum CompanyOptions {
  TakeLastSalesPrice(162, 'Take Last Sales Price'),
  AttendanceRadius(11206, 'Attendance Radius'),
  LocalSalesFlow(56, 'LocalSalesFlow');

  const CompanyOptions(this.value, this.name);
  final int value;
  final String name;
}

enum SalesFlows {
  DirectInvoice(0, 'DirectInvoice'),
  SOThenInvoiceThenDN(1, 'SOThenInvoiceThenDN'),
  SOThenDNThenInvoice(2, 'SOThenDNThenInvoice');

  const SalesFlows(this.value, this.name);
  final int value;
  final String name;
}

enum TransactionType {
  None(0, 'None'),
  LoadingSheet(1, 'LoadingSheet'),
  Merchandiser(2, 'Merchandiser');

  const TransactionType(this.value, this.name);
  final int value;
  final String name;
}
