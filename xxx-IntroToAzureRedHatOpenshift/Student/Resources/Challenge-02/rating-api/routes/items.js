var express = require("express");
var async = require("async");
var router = express.Router();
var jsonResponse = require("../models/jsonResponse");
var mongoose = require("mongoose");
var Rate = mongoose.model("Rate");
var Item = mongoose.model("Item");
var Site = mongoose.model("Site");

/* Default GET JSON for Mongo API */
router.get("/", function(req, res, next) {
  var response = new jsonResponse("Default /api endpoint for rating-api", 200, []);
  res.json(response).status(response.status);
});

/* Get all items */
router.get("/items", function(req, res, next) {
  Item.find({})
    .then(function(items) {
      var response = new jsonResponse("ok", 200, items);
      res.json(response).status(response.status);
    })
    .catch(next);
});

/* CPU intensive endpoint */
router.get("/loadtest", function(req, res, next) {
  var x = 0.0001;
  for (var i = 0; i <= 1000000; i++) {
    x += Math.sqrt(x);
  }
  var response = new jsonResponse("Load test /api endpoint for rating-api", 200, x);
  res.json(response).status(response.status);
});

/* GET rated items */
router.get("/items/rated", function(req, res, next) {
  var items = {};
  async.waterfall(
    [
      function(cb) {
        Item.find({}).then(results => {
          for (i = 0; i < results.length; i++) {
            items[results[i]._id] = { 'name': results[i].name, 'img': results[i].img };
            if (i === results.length - 1) {
              cb(null, items);
            }
          }
        });
      },
      function(items, cb) {
        Rate.aggregate([
          {
            $group: {
              _id: "$itemRated",
              stars: { $sum: "$rating" },
              votes: { $sum: 1 }
            }
          },
          { $sort: { stars: -1 } }
        ])
          .then(ratings => {
            cb(null, ratings, items);
          })
          .catch(next);
      }
    ],
    function(err, ratings, items) {
      var output = [];
      for (i = 0; i < ratings.length; i++) {
        var result = {};
        result.name = items[ratings[i]._id].name;
        result.img = items[ratings[i]._id].img;
        result.stars = ratings[i].stars;
        result.votes = ratings[i].votes;
        result.average = ratings[i].stars / ratings[i].votes;
        result.halfstar = Math.round((ratings[i].stars / ratings[i].votes)*2)/2;
        output.push(result);
        if (i === ratings.length - 1) {
          var response = new jsonResponse("ok", 200, output);
          res.json(response).status(response.status);
        }
      }
    }
  );
});

/* GET site info by short code */
router.get("/sites/:code", function(req, res, next) {
  Site.findOne({ shortCode: req.params.code })
    .then(function(site) {
      var response = new jsonResponse("ok", 200, site);
      res.json(response).status(response.status);
    })
    .catch(next);
});

/* POST create single item doc */
router.post("/item", function(req, res, next) {
  var item = new Item(req.body);
  item
    .save()
    .then(function(item) {
      var response = new jsonResponse("ok", 200, item);
      res.json(response).status(response.status);
    })
    .catch(next);
});

/* POST rating array */
router.post("/rate", function(req, res, next) {
  var input = req.body;
  var ratings = [];
  var ip = input.userIp;
  for (var i = 0, len = input.ratings.length; i < len; i++) {
    var rate = new Rate({
      rating: input.ratings[i].rating,
      raterIp: ip,
      itemRated: input.ratings[i].id
    });
    console.dir('Saving rating' + rate);
    rate.save().then(function(rate) {
      ratings.push(rate);
    });
  }
  var response = new jsonResponse("ok", 200, ratings);
  res.json(response).status(response.status);
});

module.exports = router;
