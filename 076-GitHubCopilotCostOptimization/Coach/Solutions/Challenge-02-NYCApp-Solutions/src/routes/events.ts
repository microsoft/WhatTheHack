
import { Router } from 'express';
import { events } from '../data/events.js';

export const eventsRouter = Router();

const isWithin7Days = (dateStr) => {
  const today = new Date();
  const eventDate = new Date(dateStr);
  const diff = (eventDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24);
  return diff >= 0 && diff <= 7;
};

// ✅ FINAL IMPLEMENTATION
eventsRouter.get('/free-this-week', (req, res) => {
  const result = events
    .filter(e => e.price === 0)
    .filter(e => isWithin7Days(e.date))
    .sort((a, b) => new Date(a.date) - new Date(b.date));

  res.json({
    count: result.length,
    events: result
  });
});
