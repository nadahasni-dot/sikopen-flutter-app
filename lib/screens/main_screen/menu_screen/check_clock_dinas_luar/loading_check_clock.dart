import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCheckClock extends StatefulWidget {
  const LoadingCheckClock({Key key}) : super(key: key);

  @override
  _LoadingCheckClockState createState() => _LoadingCheckClockState();
}

class _LoadingCheckClockState extends State<LoadingCheckClock> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 10.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 10.0, right: 10.0, bottom: 4.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Container(
                        width: double.infinity,
                        height: 24.0,
                        color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(thickness: 0.5, color: Colors.black87),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, left: 10.0, right: 10.0, bottom: 4.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Container(
                        width: double.infinity,
                        height: 24.0,
                        color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(thickness: 0.5, color: Colors.black87),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, left: 10.0, right: 10.0, bottom: 4.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Container(
                        width: double.infinity,
                        height: 24.0,
                        color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(thickness: 0.5, color: Colors.black87),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, left: 10.0, right: 10.0, bottom: 4.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Container(
                        width: double.infinity,
                        height: 24.0,
                        color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(thickness: 0.5, color: Colors.black87),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, left: 10.0, right: 10.0, bottom: 10.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Container(
                        width: double.infinity,
                        height: 40.0,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
            child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(color: Colors.yellow))),
      ],
    );
  }
}
