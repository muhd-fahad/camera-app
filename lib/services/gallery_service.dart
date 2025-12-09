import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryService {
  Future<List<AssetEntity>> getAllPhotos() async {
    // Ask for permission
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    debugPrint('PhotoManager permission state: $ps');

    // hasAccess covers full + limited
    if (!ps.hasAccess) {
      debugPrint('No access to gallery (permission denied or limited incorrectly).');
      // Optionally: PhotoManager.openSetting();
      return [];
    }

    // Optional: make sure we don't filter out small images
    final filterOption = FilterOptionGroup(
      imageOption: const FilterOption(
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
    );

    // Fetch all image albums
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: filterOption,
      // don't use onlyAll here – some devices behave differently
    );

    debugPrint('Found ${albums.length} image albums.');
    for (final a in albums) {
      debugPrint('Album: ${a.name}, isAll: ${a.isAll}');
    }

    if (albums.isEmpty) {
      debugPrint('No image albums returned by PhotoManager.');
      return [];
    }

    // Prefer the "All" album, otherwise take the first
    final AssetPathEntity allPhotosAlbum = albums.firstWhere(
          (a) => a.isAll,
      orElse: () => albums.first,
    );

    // Refresh to get correct assetCount
    await allPhotosAlbum.fetchPathProperties();
    final int totalAssets = await allPhotosAlbum.assetCountAsync;
    debugPrint('Selected album: ${allPhotosAlbum.name}, assetCount: $totalAssets');

    if (totalAssets == 0) {
      debugPrint('Album has 0 assets.');
      return [];
    }

    // Get everything (you can paginate later if needed)
    final List<AssetEntity> photos =
    await allPhotosAlbum.getAssetListPaged(page: 0, size: totalAssets);

    debugPrint('Fetched ${photos.length} photos from gallery.');
    return photos;
  }
}
