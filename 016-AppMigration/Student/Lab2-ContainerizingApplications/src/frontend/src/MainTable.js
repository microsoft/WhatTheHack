import React from "react";
import ProductTable from "./ProductTable";
import Timings from "./Timings";
import SqlInfo from "./SqlInfo";

class MainTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      productsTiming: -1,
      inventoryTiming: -1
    };

    this.setTiming = this.setTiming.bind(this);
  }
  setTiming(productsTiming, inventoryTiming) {
    if (!document.URL.includes("timings")) {
      return;
    }

    const newState = {};

    if (productsTiming) {
      newState.productsTiming = productsTiming;
    }

    if (inventoryTiming) {
      newState.inventoryTiming = inventoryTiming;
    }

    this.setState(newState);
  }
  render() {
    return (
      <div>
        <ProductTable setTiming={this.setTiming} />
        <SqlInfo />
        <Timings
          productsTiming={this.state.productsTiming}
          inventoryTiming={this.state.inventoryTiming}
        />
      </div>
    );
  }
}

export default MainTable;
