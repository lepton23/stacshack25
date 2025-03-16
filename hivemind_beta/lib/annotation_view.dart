import 'package:flutter/material.dart';
import 'annotation.dart';

class AnnotationView extends StatelessWidget {
  const AnnotationView({super.key, required this.annotation});

  final Annotation annotation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
              ),
              child: Text(annotation.message.body),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('${annotation.distanceFromUser.toInt()} m')],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

