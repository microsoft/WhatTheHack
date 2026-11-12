const dateFromToday = (offsetDays: number) =>
  new Date(Date.now() + offsetDays * 86_400_000).toISOString().slice(0, 10);

export const events = [
  { name: 'Central Park Yoga', date: dateFromToday(1), price: 0 },
  { name: 'Brooklyn Flea Market Walk', date: dateFromToday(2), price: 0 },
  { name: 'Rooftop Movie Night', date: dateFromToday(3), price: 15 },
  { name: 'Jazz in Washington Square Park', date: dateFromToday(10), price: 0 }
];
