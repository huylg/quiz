import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.success,
    required this.error,
    required this.warning,
    required this.background,
    required this.surface,
  });

  final Color primary;
  final Color success;
  final Color error;
  final Color warning;
  final Color background;
  final Color surface;

  @override
  AppColors copyWith({
    Color? primary,
    Color? success,
    Color? error,
    Color? warning,
    Color? background,
    Color? surface,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      background: background ?? this.background,
      surface: surface ?? this.surface,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      success: Color.lerp(success, other.success, t) ?? success,
      error: Color.lerp(error, other.error, t) ?? error,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
    );
  }
}

@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  @override
  AppSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) {
      return this;
    }
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t),
      sm: lerpDouble(sm, other.sm, t),
      md: lerpDouble(md, other.md, t),
      lg: lerpDouble(lg, other.lg, t),
      xl: lerpDouble(xl, other.xl, t),
    );
  }

  double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

ThemeData buildAppTheme() {
  const colors = AppColors(
    primary: Color(0xFF1E88E5),
    success: Color(0xFF2E7D32),
    error: Color(0xFFD32F2F),
    warning: Color(0xFFFF8F00),
    background: Color(0xFFF7F9FC),
    surface: Color(0xFFFFFFFF),
  );
  const spacing = AppSpacing(
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
  );

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.primary,
      surface: colors.surface,
    ),
    scaffoldBackgroundColor: colors.background,
    extensions: const <ThemeExtension<dynamic>>[
      colors,
      spacing,
    ],
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
      ),
    ),
  );
}
