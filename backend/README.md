# Backend Server

This is a minimal Node.js server that provides:

- HTTP join and answer endpoints
- Server-sent events (SSE) for real-time updates

## Run

```
node server.js
```

## Endpoints

- `POST /api/sessions/{id}/join`
- `GET /api/sessions/{id}`
- `POST /api/sessions/{id}/answer`
- `GET /events?sessionId={id}&playerId={id}`
