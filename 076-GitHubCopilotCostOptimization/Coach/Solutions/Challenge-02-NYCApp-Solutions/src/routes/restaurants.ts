
import { Router } from 'express';
import { restaurants } from '../data/restaurants.js';

export const restaurantsRouter = Router();

restaurantsRouter.get('/', (_req, res) => {
  res.json(restaurants);
});
