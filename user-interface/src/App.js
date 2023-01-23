import React from 'react';
import './assets/vendor/font-awesome/css/font-awesome.css';
import './assets/vendor/nucleo/css/nucleo.css';
import './assets/css/argon.min.css';
import './App.css';

import { Provider } from 'react-redux';

import { createAppStore } from './components/state/stores/AppStore';

import { AppRouter } from './components/routers/AppRouter';

import { Web3Provider } from './components/Web3/Web3Provider';

import { enableWeb3 } from './components/Web3/enableWeb3';
import welllo4 from './components/images/coni.png'
// import welllo4 from '../images/coni.png'
const myStyle = {
  backgroundImage: `url(${welllo4})`,
  height: '100vh'
}


const App = () => (
  

  <div className='App bg-info'>

  <Provider store={createAppStore()}>
    {
      enableWeb3()

    }
    <div style={myStyle}>
      <Web3Provider />
      <AppRouter />
    </div>
  </Provider>
  </div>
);
export default App;
