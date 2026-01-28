# Data Flow

## Join Flow

1. Client submits quiz ID to `POST /api/sessions/{id}/join`.
2. API validates ID and creates participant entry.
3. Real-time server accepts WebSocket connection.
4. Server sends `join_confirmed` with session state.

## Gameplay Flow

1. Server pushes `question` event to all participants.
2. Client submits `answer_submit` event with selection.
3. Server validates answer and updates score.
4. Server broadcasts `score_update`.

## Leaderboard Flow

1. Score update triggers leaderboard recompute.
2. Server broadcasts `leaderboard_update`.
3. Clients update leaderboard UI and highlight self.

## Reconnect Flow

1. Client detects disconnect and reconnects.
2. Server restores participant state.
3. Server sends `session_state` and latest leaderboard.
