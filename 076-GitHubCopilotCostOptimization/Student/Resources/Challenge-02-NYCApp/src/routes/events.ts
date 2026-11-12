
import { Router } from 'express';
import { events } from '../data/events.js';

export const eventsRouter = Router();

// ✅ STUDENTS MODIFY THIS

 eventsRouter.get('/free-this-week', (_req, res) => {
   res.json({
    count: events.length,
    events
  });
});
