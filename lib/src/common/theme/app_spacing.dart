import 'package:flutter/material.dart';

/// A collection of constants representing various spacing units

abstract class AppSpacing {
  /// The default unit of spacing, in points (pt).
  static const double spaceUnit = 16;

  /// A spacing value of 1pt.
  static const double xxxs = 0.0625 * spaceUnit;

  /// A spacing value of 2pt.
  static const double xxs = 0.125 * spaceUnit;

  /// A spacing value of 4pt.
  static const double xs = 0.25 * spaceUnit;

  /// A spacing value of 8pt.
  static const double sm = 0.5 * spaceUnit;

  /// A spacing value of 12pt.
  static const double md = 0.75 * spaceUnit;

  /// A spacing value of 16pt.
  static const double lg = spaceUnit;

  /// A spacing value of 24pt.
  static const double xlg = 1.5 * spaceUnit;

  /// A spacing value of 40pt.
  static const double xxlg = 2.5 * spaceUnit;

  /// A spacing value of 64pt.
  static const double xxxlg = 4 * spaceUnit;
}

/// SizedBox of width
///
/// A gap of width 1pt
const gapW1 = SizedBox(width: AppSpacing.xxxs);

/// A gap of width 2pt
const gapW2 = SizedBox(width: AppSpacing.xxs);

/// A gap of width 4pt
const gapW4 = SizedBox(width: AppSpacing.xs);

/// A gap of width 8pt
const gapW8 = SizedBox(width: AppSpacing.sm);

/// A gap of width 12pt
const gapW12 = SizedBox(width: AppSpacing.md);

/// A gap of width 16pt
const gapW16 = SizedBox(width: AppSpacing.lg);

/// A gap of width 24pt
const gapW24 = SizedBox(width: AppSpacing.xlg);

/// A gap of width 40pt
const gapW40 = SizedBox(width: AppSpacing.xxlg);

/// A gap of width 64pt
const gapW64 = SizedBox(width: AppSpacing.xxxlg);

/// SizedBox of height
///
/// A gap of height 1pt
const gapH1 = SizedBox(height: AppSpacing.xxxs);

/// A gap of height 2pt
const gapH2 = SizedBox(height: AppSpacing.xxs);

/// A gap of height 4pt
const gapH4 = SizedBox(height: AppSpacing.xs);

/// A gap of height 8pt
const gapH8 = SizedBox(height: AppSpacing.sm);

/// A gap of height 12pt
const gapH12 = SizedBox(height: AppSpacing.md);

/// A gap of height 16pt
const gapH16 = SizedBox(height: AppSpacing.lg);

/// A gap of height 24pt
const gapH24 = SizedBox(height: AppSpacing.xlg);

/// A gap of height 40pt
const gapH40 = SizedBox(height: AppSpacing.xxlg);

/// A gap of height 64pt
const gapH64 = SizedBox(height: AppSpacing.xxxlg);
