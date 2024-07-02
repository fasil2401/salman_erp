import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Logistic%20Screen/Inner%20Pages/Container%20Tracker%20Screen/components.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDialog extends StatefulWidget {
  Map<String, dynamic> addressMap;

  MapDialog({required this.addressMap});

  @override
  _MapDialogState createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: popupTitle(
          onTap: () {
            Navigator.pop(context);
          },
          title: 'Location Details'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        widget.addressMap['geometry']['location']['lat'],
                        widget.addressMap['geometry']['location']['lng']),
                    zoom: 15.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('location'),
                      position: LatLng(
                          widget.addressMap['geometry']['location']['lat'],
                          widget.addressMap['geometry']['location']['lng']),
                    ),
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildAddressTile(
                title: 'Address 1',
                content: widget.addressMap['address_components'].length > 0
                    ? widget.addressMap['address_components'][0]['long_name']
                    : ''),
            const SizedBox(
              height: 8,
            ),
            _buildAddressTile(
                title: 'Address 2',
                content: widget.addressMap['address_components'].length > 1
                    ? widget.addressMap['address_components'][1]['long_name']
                    : ''),
            const SizedBox(
              height: 8,
            ),
            _buildAddressTile(
                title: 'Address 3',
                content: widget.addressMap['address_components'].length > 2
                    ? widget.addressMap['address_components'][2]['long_name']
                    : ''),
            const SizedBox(
              height: 8,
            ),
            _buildAddressTile(
                title: 'City',
                content: widget.addressMap['address_components'].length > 3
                    ? widget.addressMap['address_components'][3]['long_name']
                    : ''),
            const SizedBox(
              height: 8,
            ),
            _buildAddressTile(
                title: 'State',
                content: widget.addressMap['address_components'].length > 4
                    ? widget.addressMap['address_components'][4]['long_name']
                    : ''),
            const SizedBox(
              height: 8,
            ),
            _buildAddressTile(
                title: 'Country',
                content: widget.addressMap['address_components'].length > 5
                    ? widget.addressMap['address_components'][5]['long_name']
                    : ''),
    
          ],
        ),
      ),
    );
  }

  Row _buildAddressTile({required String title, required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$title : ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Flexible(
          child: Text(
            content,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedColor),
          ),
        )
      ],
    );
  }
}
