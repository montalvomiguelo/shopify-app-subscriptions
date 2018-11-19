import React from 'react';
import ReactDOM from 'react-dom';
import '@shopify/polaris/styles.css';
import {AppProvider} from '@shopify/polaris';

import App from '../components/App';

const shopOrigin = document.querySelector('meta[name="ShopOrigin"]').content;
const apiKey = document.querySelector('meta[name="APIKey"]').content;
const forceRedirect = !!document.querySelector('meta[name="ForceRedirect"]');

ReactDOM.render(
  <AppProvider shopOrigin={shopOrigin} apiKey={apiKey} forceRedirect={forceRedirect}>
    <App />
  </AppProvider>,
  document.getElementById('root')
);
