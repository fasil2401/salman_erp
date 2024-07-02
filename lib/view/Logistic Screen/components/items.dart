import 'package:axolon_erp/model/screen_item_model.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/constants/asset_paths.dart';
import 'package:axolon_erp/utils/constants/screenid.dart';

class LogisticsScreenItems {
  static const String containerTracking = 'containerTrackToolStripMenuItem';
  static List<ScreenItemModel> LogisticsItems = [
    ScreenItemModel(
        title: 'Container Tracker',
        menuId: containerTracking,
        screenId: LogisticScreenId.containerTracking,
        route: '${RouteManager.containerTracker}',
        icon: AppIcons.approved),
  ];
}
