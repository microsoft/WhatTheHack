import React from "react";

const Timings = props => {
  if (!document.URL.includes("timings")) {
    return null;
  }

  return (
    <div className="timings">
      <div>
        products: {props.productsTiming}
        ms
      </div>
      <div>
        inventory: {props.inventoryTiming}
        ms
      </div>
    </div>
  );
};

export default Timings;
