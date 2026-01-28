# API Documentation

## HTTP Endpoints

### POST `/api/sessions/{id}/join`

Join a quiz session by ID.

**Request**

```json
{
  "playerName": "Ada"
}
```

**Response**

```json
{
  "sessionId": "abc123",
  "playerId": "p001",
  "status": "active"
}
```

### GET `/api/sessions/{id}`

Get session metadata and current question.

**Response**

```json
{
  "sessionId": "abc123",
  "status": "active",
  "currentQuestionId": "q1"
}
```

### POST `/api/sessions/{id}/answer`

Submit an answer for scoring.

**Request**

```json
{
  "playerId": "p001",
  "questionId": "q1",
  "answerId": "a2"
}
```

**Response**

```json
{
  "status": "ok"
}
```

### GET `/health`

Health check endpoint.

**Response**

```json
{
  "status": "ok"
}
```

## WebSocket

Connect to `/ws` after join. All messages are JSON.

See `docs/message-protocol.md` for event formats.

## Server-Sent Events (SSE)

Connect to `/events?sessionId={id}&playerId={id}` for real-time updates.
