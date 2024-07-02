import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';
import 'package:get/get.dart';

// final homeController = Get.put(HomeController());

class InventoryScreenItems {
  static const String productsId = 'micItem';
  static const String itemListId = 'milItem';
  static const String stockId = 'itemStockListLocationWiseToolStripMenuItem';
  static const String inventoryLedgerId = 'mriInvLeg';
  static const String itemCatalogueId = 'mriItemCatalog';
  static const String inventoryValuationId =
      'inventoryValuationToolStripMenuItem';
  static const String inventoryAgingSummaryId =
      'inventoryAgingSummaryToolStripMenuItem';
  static const String topSellingProductsId = 'productTopListToolStripMenuItem';

  static List<ScreenItemModel> inventoryItems = [
    ScreenItemModel(
        title: 'Products',
        menuId: productsId,
        screenId: InventoryScreenId.productDetails,
        route: '${RouteManager.productDetail}',
        icon: AppIcons.box),
    ScreenItemModel(
        title: 'Stock',
        menuId: stockId,
        screenId: InventoryScreenId.productStockPivotListReport,
        route: '${RouteManager.itemStock}',
        icon: AppIcons.stock),
    ScreenItemModel(
        title: 'Item List',
        menuId: itemListId,
        screenId: InventoryScreenId.productListForm,
        route: '${RouteManager.itemList}',
        icon: AppIcons.stock),
  ];

  static List<ScreenItemModel> reportItems = [
    ScreenItemModel(
        title: 'Inventory Ledger',
        menuId: inventoryLedgerId,
        screenId: InventoryScreenId.inventoryLedger,
        route: '${RouteManager.inventoryLedger}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Item Catalogue',
        menuId: itemCatalogueId,
        screenId: InventoryScreenId.productCatalog,
        route: '${RouteManager.itemCatalogue}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Inventory valuation',
        menuId: inventoryValuationId,
        screenId: InventoryScreenId.productStockList,
        route: '${RouteManager.inventoryValuation}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Inventory aging summary',
        menuId: inventoryAgingSummaryId,
        screenId: InventoryScreenId.inventoryAging,
        route: '${RouteManager.inventoryAging}',
        icon: AppIcons.report),
    ScreenItemModel(
        title: 'Top selling products',
        menuId: topSellingProductsId,
        screenId: InventoryScreenId.customerTopListReport,
        route: '${RouteManager.topSellingProducts}',
        icon: AppIcons.report),
  ];
}
