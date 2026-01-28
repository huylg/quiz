const http = require('http');
const { randomUUID } = require('crypto');
const { parse } = require('url');

const sessions = new Map();

const sampleQuestions = [
  {
    id: 'q1',
    text: 'What is 2 + 2?',
    answers: [
      { id: 'a1', text: '3' },
      { id: 'a2', text: '4' },
      { id: 'a3', text: '5' },
    ],
    correctAnswerId: 'a2',
    points: 10,
  },
  {
    id: 'q2',
    text: 'Which planet is known as the Red Planet?',
    answers: [
      { id: 'a1', text: 'Mars' },
      { id: 'a2', text: 'Venus' },
      { id: 'a3', text: 'Jupiter' },
    ],
    correctAnswerId: 'a1',
    points: 10,
  },
];

function getSession(sessionId) {
  if (!sessions.has(sessionId)) {
    sessions.set(sessionId, {
      sessionId,
      status: 'active',
      players: new Map(),
      questionIndex: 0,
      clients: new Set(),
      questions: sampleQuestions,
    });
  }
  return sessions.get(sessionId);
}

function leaderboardFor(session) {
  const players = Array.from(session.players.values());
  players.sort((a, b) => {
    const scoreOrder = b.score - a.score;
    if (scoreOrder !== 0) {
      return scoreOrder;
    }
    return a.name.localeCompare(b.name);
  });
  return players.map((player, index) => ({
    playerId: player.id,
    playerName: player.name,
    score: player.score,
    rank: index + 1,
  }));
}

function broadcast(session, event, payload) {
  const message = `event: ${event}\n` +
    `data: ${JSON.stringify(payload)}\n\n`;
  for (const client of session.clients) {
    client.write(message);
  }
}

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    'Content-Type': 'application/json',
  });
  response.end(JSON.stringify(payload));
}

function collectJson(request) {
  return new Promise((resolve, reject) => {
    let body = '';
    request.on('data', (chunk) => {
      body += chunk;
    });
    request.on('end', () => {
      if (!body) {
        resolve({});
        return;
      }
      try {
        resolve(JSON.parse(body));
      } catch (error) {
        reject(error);
      }
    });
  });
}

const server = http.createServer(async (request, response) => {
  const { pathname, query } = parse(request.url, true);

  if (request.method === 'GET' && pathname === '/health') {
    return sendJson(response, 200, { status: 'ok' });
  }

  if (request.method === 'GET' && pathname === '/events') {
    const { sessionId, playerId } = query;
    if (!sessionId || !playerId) {
      return sendJson(response, 400, {
        error: 'sessionId and playerId are required.',
      });
    }
    const session = getSession(sessionId);
    response.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      Connection: 'keep-alive',
    });
    session.clients.add(response);
    broadcast(session, 'join_confirmed', {
      sessionId: session.sessionId,
      playerId,
      status: session.status,
    });
    request.on('close', () => {
      session.clients.delete(response);
    });
    return;
  }

  if (request.method === 'POST' && pathname?.startsWith('/api/sessions/')) {
    const [, , , sessionId, action] = pathname.split('/');
    if (!sessionId) {
      return sendJson(response, 404, { error: 'Session not found.' });
    }
    const session = getSession(sessionId);

    if (!action && request.method === 'POST') {
      return sendJson(response, 404, { error: 'Unknown endpoint.' });
    }

    if (action === 'join') {
      try {
        const body = await collectJson(request);
        const playerName = body.playerName || 'Player';
        const playerId = randomUUID();
        session.players.set(playerId, {
          id: playerId,
          name: playerName,
          score: 0,
        });
        return sendJson(response, 200, {
          sessionId,
          playerId,
          status: session.status,
        });
      } catch (error) {
        return sendJson(response, 400, { error: 'Invalid JSON.' });
      }
    }

    if (action === 'answer') {
      try {
        const body = await collectJson(request);
        const player = session.players.get(body.playerId);
        if (!player) {
          return sendJson(response, 404, { error: 'Player not found.' });
        }
        const question = session.questions.find(
          (item) => item.id === body.questionId,
        );
        if (!question) {
          return sendJson(response, 404, { error: 'Question not found.' });
        }
        const isCorrect = question.correctAnswerId === body.answerId;
        player.score += isCorrect ? question.points : 0;
        session.questionIndex =
          (session.questionIndex + 1) % session.questions.length;
        const scoreUpdate = {
          event: 'score_update',
          playerId: player.id,
          score: player.score,
        };
        broadcast(session, 'score_update', scoreUpdate);
        broadcast(session, 'leaderboard_update', {
          entries: leaderboardFor(session),
        });
        return sendJson(response, 200, { status: 'ok' });
      } catch (error) {
        return sendJson(response, 400, { error: 'Invalid JSON.' });
      }
    }
  }

  if (request.method === 'GET' && pathname?.startsWith('/api/sessions/')) {
    const [, , , sessionId] = pathname.split('/');
    if (!sessionId) {
      return sendJson(response, 404, { error: 'Session not found.' });
    }
    const session = getSession(sessionId);
    const question = session.questions[session.questionIndex];
    return sendJson(response, 200, {
      sessionId,
      status: session.status,
      currentQuestionId: question.id,
    });
  }

  return sendJson(response, 404, { error: 'Not found.' });
});

server.listen(3000, () => {
  console.log('Server listening on http://localhost:3000');
});
