import 'package:flutter/material.dart';

class SwipeToBackPage extends StatelessWidget {
  /// Creates a SwipeToBackPage
  const SwipeToBackPage(
      {super.key,
      required this.child,
      this.onBack,
      this.pageTurnCurve = Curves.ease,
      this.pageTurnDuration = const Duration(milliseconds: 100),
      this.widthBack = 20});

  final Widget child;

  /// Handle action when page pop
  final VoidCallback? onBack;

  /// Duration of animation
  final Duration pageTurnDuration;

  /// Animation
  final Curve pageTurnCurve;

  /// width of zone back can be used
  final double widthBack;

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: 1);
    var canPop = false;

    void onPageChanged(int page) {
      if (page == 0) {
        pageController.jumpToPage(1);
        onBack?.call();
      }
    }

    void goForward() {
      pageController.nextPage(duration: pageTurnDuration, curve: pageTurnCurve);
    }

    void goBack() {
      pageController.previousPage(
          duration: pageTurnDuration, curve: pageTurnCurve);
    }

    return GestureDetector(
      // Using the DragEndDetails allows us to only fire once per swipe.
      onHorizontalDragEnd: (details) {
        canPop = false;
        if (details.primaryVelocity! < 0 && canPop) {
          // Page forwards
          goForward();
        } else if (details.primaryVelocity! > 0 && canPop) {
          // Page backwards
          goBack();
        }
        pageController.jumpToPage(1);
      },
      onHorizontalDragCancel: () {
        canPop = false;
      },
      onHorizontalDragDown: (details) {
        if (details.localPosition.dx < widthBack) {
          canPop = true;
        }
      },
      onHorizontalDragUpdate: (details) {
        if (canPop) {
          final offset =
              MediaQuery.of(context).size.width - details.localPosition.dx;
          pageController.jumpTo(offset);
        }
      },
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: false,
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          Container(color: Colors.transparent,),
          child,
        ],
      ),
    );
  }
}
