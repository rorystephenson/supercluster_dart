import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapColorBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TileLayerWidget(
      options: TileLayerOptions(
        urlTemplate: '',
        tileProvider: ColorTileProvider(),
      ),
    );
  }
}

class ColorTileProvider extends TileProvider {
  @override
  ImageProvider<Object> getImage(Coords<num> coords, TileLayerOptions options) {
    String base64Image =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAA1JREFUGFdjePv27X8ACVkDx01U27cAAAAASUVORK5CYII=';

    return ResizeImage(
      MemoryImage(base64Decode(base64Image)),
      width: options.tileSize.toInt(),
      height: options.tileSize.toInt(),
    );
  }
}
