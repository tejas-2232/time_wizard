import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/services/timer_service.dart';
import 'package:timetrack/theme/app_theme.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = Provider.of<TimerService>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Circular progress indicator
            CircularProgressIndicator(
              value: timerService.isIdle ? 0 : null,
              strokeWidth: 8,
              color: _getTimerColor(timerService.state),
              backgroundColor: isDarkMode 
                  ? AppColors.neutral700 
                  : AppColors.neutral200,
            ),
            
            // Timer text
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timerService.formattedTime,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getTimerStateText(timerService.state),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getTimerColor(timerService.state),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getTimerColor(TimerState state) {
    switch (state) {
      case TimerState.running:
        return AppColors.success;
      case TimerState.paused:
        return AppColors.warning;
      case TimerState.idle:
        return AppColors.primary;
    }
  }
  
  String _getTimerStateText(TimerState state) {
    switch (state) {
      case TimerState.running:
        return 'RUNNING';
      case TimerState.paused:
        return 'PAUSED';
      case TimerState.idle:
        return 'READY';
    }
  }
}