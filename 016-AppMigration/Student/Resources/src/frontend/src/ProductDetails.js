import React from "react";

class ProductDetails extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      inventoryMod: 0,
      loading: false
    };

    this.increment = this.mod.bind(this, true);
    this.decrement = this.mod.bind(this, false);
  }
  componentDidUpdate(prevProps) {
    if (prevProps.inventory !== this.props.inventory) {
      this.setState({ inventoryMod: 0 });
    }
  }
  mod(increment) {
    this.setState({ loading: true });
    fetch(
      `${process.env.INVENTORY_SERVICE_BASE_URL}/api/inventory/${this.props.id}/${
        increment ? "increment" : "decrement"
      }`,
      {
        method: "POST"
      }
    ).then(() => {
      this.setState({
        inventoryMod: increment
          ? this.state.inventoryMod + 1
          : this.state.inventoryMod - 1,
        loading: false
      });
    }, console.error);
  }
  render() {
    const {
      name,
      supplierName,
      inventory,
      sku,
      price,
      shortDescription,
      longDescription,
      unitDescription,
      dimensions,
      weightInPounds,
      reorderAmount,
      status,
      location,
      productType,
      digital,
      images
    } = this.props;
    const { inventoryMod, loading } = this.state;
    return (
      <div className="details">
        <div className="details-main">
          <div>
            <h1>{name}</h1>
            <h2>{supplierName}</h2>
          </div>
          <div>
            <h1 className="inventory">
              {inventory ? inventory + inventoryMod : ""}
            </h1>
            <div
              className={`details-buttons${
                loading || !inventory ? " loading" : ""
              }`}
            >
              <button
                disabled={loading || !inventory}
                onClick={this.increment}
                className="plus mod-button"
              >
                +
              </button>
              <button
                disabled={loading || !inventory}
                onClick={this.decrement}
                className="minus mod-button"
              >
                -
              </button>
            </div>
          </div>
        </div>
        <div className="details-images">
          {images.map(({ url, caption, id }) => (
            <img className="details-image" src={url} alt={caption} key={id} />
          ))}
        </div>
        <div className="details-info">
          <ul>
            <li>
              <strong>SKU:</strong> {sku}
            </li>
            <li>
              <strong>Price:</strong> {price}
            </li>
            <li>
              <strong>Digital:</strong> {digital ? "True" : "False"}
            </li>
            <li>
              <strong>Dimensions:</strong> {dimensions}
            </li>
            <li>
              <strong>Weight:</strong> {weightInPounds} lbs
            </li>
            <li>
              <strong>Reorder Amount:</strong> {reorderAmount}
            </li>
            <li>
              <strong>Status:</strong> {status}
            </li>
            <li>
              <strong>Location:</strong> {location}
            </li>
            <li>
              <strong>Product Type:</strong> {productType}
            </li>
            <li>
              <strong>Unit Description:</strong> {unitDescription}
            </li>
            <li>
              <strong>Short Description:</strong> {shortDescription}
            </li>
            <li>
              <strong>Long Description:</strong> {longDescription}
            </li>
          </ul>
        </div>
      </div>
    );
  }
}

export default ProductDetails;
