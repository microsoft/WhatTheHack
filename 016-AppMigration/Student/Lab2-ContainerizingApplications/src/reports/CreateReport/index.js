const { Connection, Request } = require('tedious');

const options = {
  weekday: 'long',
  year: 'numeric',
  month: 'long',
  day: 'numeric'
};

const config = {
  userName: process.env.SQL_USERNAME,
  password: process.env.SQL_PASSWORD,
  server: process.env.SQL_SERVER,
  options: {
    encrypt: true,
    database: process.env.SQL_DATABASE
  }
};

module.exports = function(context, myTimer) {
  getChangedSkus()
    .then(data => {
      if (data.length > 0) {
        sendEmail(context, data);
      } else {
        context.done();
      }
    })
    .catch(err => {
      context.log(`ERROR: ${err}`);
    });
};

/**
 * Sends an email using the Azure Functions binding for SendGrid
 * @param {object} The Function Context
 * @param {object} The data to be passed to the SendGrid template
 */
function sendEmail(context, data) {
  context.done(null, {
    message: {
      /* you can override the to/from settings from function.json here if you would like
        to: 'someone@someplace.com',
        from: 'someone@anotherplace.com'
        */
      personalizations: [
        {
          dynamic_template_data: {
            Subject: `Tailwind SKU Report For ${new Date().toLocaleDateString(
              'en-US',
              options
            )}`,
            Skus: data
          }
        }
      ],
      template_id: process.env.SENDGRID_TEMPLATE_ID
    }
  });
}

/**
 * Executes a query against the database for SKU's changed in the last 24 hours
 * @returns {Promise} Promise object contains result of query
 */
function getChangedSkus() {
  return new Promise((resolve, reject) => {
    const connection = new Connection(config);
    const query = `SELECT Sku, Quantity, CONVERT(varchar, Modified, 0) as Modified
                            FROM Inventory
                            WHERE Modified >= dateadd(day, -1, getdate())`;

    connection.on('connect', err => {
      if (err) reject(err);

      let request = new Request(query, err => {
        if (err) {
          reject(err);
        }
      });

      const results = [];
      request.on('row', columns => {
        let result = {};
        columns.forEach(column => {
          result[column.metadata.colName] = column.value;
        });

        results.push(result);
      });

      request.on('doneProc', (rowCount, more) => {
        resolve(results);
      });

      connection.execSql(request);
    });
  });
}
