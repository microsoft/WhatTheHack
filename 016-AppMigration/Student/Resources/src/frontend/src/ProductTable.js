import React from "react";
import { Column, Table, AutoSizer, InfiniteLoader } from "react-virtualized";
import Modal from "./Modal";
import ProductDetails from "./ProductDetails";

class ProductTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      rows: [],
      start: 1,
      stop: 10,
      selectedRow: null
    };

    this.lastRequestedPage = -1;

    this.modRowsShowing = this.modRowsShowing.bind(this);
    this.getInventory = this.getInventory.bind(this);
    this.handleRowClick = this.handleRowClick.bind(this);
    this.handleModalClick = this.handleModalClick.bind(this);
    this.closeModal = this.closeModal.bind(this);
    this.isRowLoaded = this.isRowLoaded.bind(this);
    this.fetchRows = this.fetchRows.bind(this);
  }
  componentDidMount() {
    this.fetchRows({ stopIndex: 1 });
  }
  fetchRows({ stopIndex }) {
    const page = Math.round(stopIndex / 500);

    if (page <= this.lastRequestedPage || stopIndex >= this.state.totalSize) {
      return;
    }

    this.lastRequestedPage = page;

    const start = Date.now();
    fetch(
      `${
        process.env.PRODUCT_SERVICE_BASE_URL
      }/api/products?pageSize=500&page=${page}`
    )
      .then(data => {
        this.props.setTiming(Date.now() - start);
        return data.json();
      })
      .then(({ items, size }) => {
        this.setState({ rows: this.state.rows.concat(items), totalSize: size });
        this.interval = Date.now() + 2000;

        requestAnimationFrame(this.getInventory);
      })
      .catch(console.error);
  }
  getInventory() {
    if (this.interval > Date.now()) {
      requestAnimationFrame(this.getInventory);
      return;
    }

    const nums = Array.from({ length: this.state.stop - this.state.start + 1 })
      .map((_, index) => {
        const i = index + this.state.start;
        // attempt to fix off by one error
        return (this.state.rows[i] && this.state.rows[i].id) || 0;
      })
      .join(",");
    const start = Date.now();
    fetch(
      `${process.env.INVENTORY_SERVICE_BASE_URL}/api/inventory?skus=${nums}`
    )
      .then(data => {
        this.props.setTiming(null, Date.now() - start);
        return data.json();
      })
      .then(skus => {
        skus.forEach(sku => {
          const item = this.state.rows.find(p => p.id == sku.sku);
          if (item) {
            item.inventory = sku.quantity;
          }
        });

        this.forceUpdate();
        this.interval = Date.now() + 5000;
        requestAnimationFrame(this.getInventory);
      })
      .catch(console.error);
  }
  modRowsShowing({ overscanStartIndex, overscanStopIndex }) {
    this.setState({
      start: overscanStartIndex,
      stop: overscanStopIndex
    });
  }
  handleRowClick(rowEvent) {
    this.setState({ selectedRow: rowEvent.rowData });
  }
  handleModalClick(e) {
    if (e.target.id === "modal-interior") {
      this.closeModal();
    }
  }
  closeModal() {
    this.setState({ selectedRow: null });
  }
  isRowLoaded({ index }) {
    return !!this.state.rows[index];
  }
  render() {
    return (
      <div className="table-container">
        <InfiniteLoader
          rowCount={this.state.totalSize}
          loadMoreRows={this.fetchRows}
          isRowLoaded={this.isRowLoaded}
        >
          {({ onRowsRendered, registerChild }) => (
            <AutoSizer>
              {({ height, width }) => (
                <Table
                  width={width}
                  height={height}
                  headerHeight={60}
                  rowHeight={60}
                  rowCount={this.state.rows.length}
                  ref={registerChild}
                  rowGetter={({ index }) => this.state.rows[index]}
                  onRowsRendered={data => {
                    this.modRowsShowing(data);
                    onRowsRendered(data);
                  }}
                  rowClassName={({ index }) =>
                    index % 2 ? "row-even" : "row-odd"
                  }
                  headerClassName="row-header"
                  onRowClick={this.handleRowClick}
                >
                  <Column width={100} label="ID" dataKey="id" />
                  <Column width={300} label="Name" dataKey="name" />
                  <Column width={300} label="SKU" dataKey="sku" />
                  <Column width={100} label="Price" dataKey="price" />
                  <Column width={200} label="Supplier" dataKey="supplierName" />
                  <Column width={200} label="Inventory" dataKey="inventory" />
                </Table>
              )}
            </AutoSizer>
          )}
        </InfiniteLoader>
        {!this.state.selectedRow ? null : (
          <Modal>
            <div
              role="none"
              onClick={this.handleModalClick}
              id="modal-interior"
            >
              <div>
                <ProductDetails {...this.state.selectedRow} />
                <div className="buttons">
                  <button className="exit-button" onClick={this.closeModal}>
                    Close
                  </button>
                </div>
              </div>
            </div>
          </Modal>
        )}
      </div>
    );
  }
}

export default ProductTable;
