import "react-app-polyfill/ie11";
import "react-app-polyfill/stable";

import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import App from "./App";
import { Provider } from "react-redux";
import { basicReduxStore } from "./reduxStore";

ReactDOM.render(
  <Provider store={basicReduxStore}>
    <App />
  </Provider>,
  document.getElementById("root")
);