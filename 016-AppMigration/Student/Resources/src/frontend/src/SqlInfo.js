import React from "react";

class SqlInfo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      info: {},
      enabled: process.env.DISPLAY_SQL_INFO
    };
  }

  componentDidMount() {
    this.fetchInfo();
  }

  fetchInfo() {
    if (this.state.enabled) {
      fetch(
        `${process.env.INVENTORY_SERVICE_BASE_URL}/api/info`
      )
      .then(data => data.json())
      .then(info => this.setState({ info: info }));
    }
  }
  
  render() {
    return (this.state.enabled) ?
      <div className="sql-info">{this.state.info.dataSource} | {this.state.info.databaseEdition}</div> :
      <div></div>;
  }
}

export default SqlInfo;