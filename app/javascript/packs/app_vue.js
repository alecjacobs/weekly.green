/* eslint no-console: 0 */

import Vue from 'vue'
import Vuetify from 'vuetify'
import App from '../app.vue'
import store from '../store'
import router from '../router'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('hello'));

  Vue.use(Vuetify, { theme: { primary: '#333' }})

  window.app = window.app || {};
  window.app = new Vue({
    router,
    store,
    el,
    render: h => h(App)
  });
});
