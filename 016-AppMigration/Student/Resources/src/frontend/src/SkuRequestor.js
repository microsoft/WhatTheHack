import React from "react";

class SkuRequestor extends React.Component {
  constructor(props) {
    super(props);

    this.state = { sku: "", loading: false };

    this.request = this.request.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSku = this.handleSku.bind(this);
  }
  handleSubmit(e) {
    this.request(this.state.sku);
    e.preventDefault();
  }
  handleSku(e) {
    this.setState({ sku: e.target.value });
  }
  request(sku) {
    this.setState({ loading: true });
    fetch(`${process.env.SKU_SERVICE_BASE_URL}/api/inventory/bad/${sku}`)
      .then(data => data.json())
      .then(res => {
        this.setState({ res, loading: false });
      });
  }
  render() {
    return (
      <div className="sku">
        <form onSubmit={this.handleSubmit}>
          <input
            value={this.state.sku}
            onChange={this.handleSku}
            placeholder="SKU"
          />
          <button className="exit-button" type="submit">
            Submit
          </button>
        </form>
        {this.state.loading ? <span className="sku-loading">🛠</span> : null}
        {this.state.res ? (
          <div>
          <pre>
            <code>{JSON.stringify(this.state.res, null, 4)}</code>
          </pre>
          <h3>Injection Sample Code</h3>
          <pre>
            <code>' UNION SELECT Password AS Sku, 0 AS Quantity FROM SecretUsers WHERE Username = 'administrator' --</code>
          </pre>
          </div>
        ) : null}
      </div> 
    );
  }
}

export default SkuRequestor;
