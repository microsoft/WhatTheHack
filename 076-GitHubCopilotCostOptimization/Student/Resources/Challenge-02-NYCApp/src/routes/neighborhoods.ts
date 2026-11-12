
import { Router } from 'express';
import { neighborhoods } from '../data/neighborhoods.js';

export const neighborhoodsRouter = Router();

neighborhoodsRouter.get('/', (_req, res) => {
  res.json(neighborhoods);
});
