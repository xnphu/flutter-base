import 'package:base/presentation/base/index.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var enabled = true;
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: enabled,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 19.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                    ),
                    Container(
                      width: 40,
                      height: 19.0,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 19.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 19.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 120,
                        height: 19.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: AppColors.grayE5,
        ),
      ],
    );
  }
}
