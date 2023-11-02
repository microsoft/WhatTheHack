import Vue from 'vue';
import App from './App';
import router from './router';
import 'at-ui-style';
import AtUI from 'at-ui';


Vue.config.productionTip = false;
Vue.use(AtUI);

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  render: h => h(App)
});

