# Message Protocol

All WebSocket messages are JSON with an `event` field.

## Client → Server

### `join`

```json
{
  "event": "join",
  "sessionId": "abc123",
  "playerName": "Ada"
}
```

### `answer_submit`

```json
{
  "event": "answer_submit",
  "sessionId": "abc123",
  "playerId": "p001",
  "questionId": "q1",
  "answerId": "a2"
}
```

## Server → Client

### `join_confirmed`

```json
{
  "event": "join_confirmed",
  "sessionId": "abc123",
  "playerId": "p001",
  "status": "active"
}
```

### `question`

```json
{
  "event": "question",
  "questionId": "q1",
  "text": "What is 2 + 2?",
  "answers": [
    { "id": "a1", "text": "3" },
    { "id": "a2", "text": "4" }
  ]
}
```

### `score_update`

```json
{
  "event": "score_update",
  "playerId": "p001",
  "score": 10
}
```

### `leaderboard_update`

```json
{
  "event": "leaderboard_update",
  "entries": [
    { "playerId": "p001", "playerName": "Ada", "score": 10, "rank": 1 },
    { "playerId": "p002", "playerName": "Ben", "score": 8, "rank": 2 }
  ]
}
```

### `error`

```json
{
  "event": "error",
  "code": "invalid_session",
  "message": "Quiz ID is invalid."
}
```
