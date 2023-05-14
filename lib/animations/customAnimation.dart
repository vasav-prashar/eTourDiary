import 'package:flutter/material.dart';

class ForwardPageRoute extends PageRouteBuilder {
  final Widget child;

  ForwardPageRoute({
    required this.child,
  }) : super(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context,animation,secondaryAnimation) => child
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child)=>
        SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1,0),end: Offset.zero
          ).animate(animation),
          child: child,);
}

class BackwardPageRoute extends PageRouteBuilder {
  final Widget child;

  BackwardPageRoute({
    required this.child,
  }) : super(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context,animation,secondaryAnimation) => child
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child)=>
        SlideTransition(
          position: Tween<Offset>(begin: const Offset(1,0),end: Offset.zero
          ).animate(animation),
          child: child,);
}