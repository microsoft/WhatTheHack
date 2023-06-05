import Vue from 'vue';
import Router from 'vue-router';
import Home from '../components/Home';
import Rating from '../components/Rating';
import Leaderboard from '../components/Leaderboard';
import Footer from '../components/Footer';

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      components: { main: Home, footer: Footer}
    },
    {
      path: '/rating',
      name: 'Rating',
      components: { main: Rating, footer: Footer} 
    },
    {
      path: '/leaderboard',
      name: 'Leaderboard',
      components: { main: Leaderboard, footer: Footer}
    }
  ]
})
