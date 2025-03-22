import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './components/App';
import { VisibilityProvider } from './providers/VisibilityProvider';

const rootElement = document.getElementById('root') as HTMLElement;
const root = ReactDOM.createRoot(rootElement);

root.render(
  <React.StrictMode>
    <VisibilityProvider>
      <App />
    </VisibilityProvider>
  </React.StrictMode>
);
