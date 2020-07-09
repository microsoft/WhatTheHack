const { Connection, Request } = require('tedious');

const config = {
  userName: process.env.USERNAME,
  password: process.env.PASSWORD,
  server: process.env.SERVER,
  options: {
    encrypt: true,
    database: process.env.DATABASE
  }
};

module.exports = function(context, req) {
  context.done(null, {
    message: {
      to: 'burke.holland@microsoft.com',
      subject: `Thanks`,
      content: [
        {
          type: 'text/plain',
          value: 'YOLO'
        }
      ]
    }
  });

  //   const connection = new Connection(config);
  //   const query = `SELECT Sku, Quantity, Modified
  //                    FROM Inventory
  //                    WHERE Modified >= dateadd(day, -1, getdate())`;

  //   connection.on('connect', err => {
  //     if (err) handleError(context, err);

  //     let request = new Request(query, err => {
  //       if (err) {
  //         handleError(contenxt, err);
  //       }
  //     });

  //     const results = [];
  //     request.on('row', columns => {
  //       let result = {};
  //       columns.forEach(column => {
  //         if (column.value === null) {
  //           console.log('NULL');
  //         } else {
  //           result[column.metadata.colName] = column.value;
  //         }
  //       });

  //       results.push(result);
  //     });

  //     request.on('doneProc', (rowCount, more) => {
  //       context.res = {
  //         body: results
  //       };

  //       context.done();
  //     });

  //     connection.execSql(request);
  //   });
};

function handleError(context, message) {
  context.res = {
    status: 400,
    body: message
  };

  context.done();
}
