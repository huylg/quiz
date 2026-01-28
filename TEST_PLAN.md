# Test Plan

## Scope

- Join flow
- Answer submission
- Real-time score updates
- Leaderboard updates
- Reconnect behavior

## Test Cases

### User Participation

- Valid quiz ID join succeeds.
- Invalid quiz ID shows error and allows retry.
- Concurrent users can join same session.

### Real-Time Score Updates

- Correct answer increases score by points.
- Incorrect answer does not change score.
- Score remains consistent after reconnect.

### Real-Time Leaderboard

- Leaderboard updates when scores change.
- Ties are ordered deterministically.
- Current user is highlighted.

### Reliability

- WebSocket reconnect restores state.
- Network loss shows reconnecting state.

## Pass Criteria

- Zero critical defects.
- Score update latency p95 <= 500 ms.
- Leaderboard update latency p95 <= 750 ms.
