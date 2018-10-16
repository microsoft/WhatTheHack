$(function () {
    $.connection.hub.logging = true;
    var announcementsHub = $.connection.Announcement;

    announcementsHub.client.announcement = function (item) {
        var newArrivals = $('a#NewArrivalsPanel');
        newArrivals.attr("href", item.Url); //Set the URL
        newArrivals.text(item.Title); //Set the title
    };

    $.connection.hub.start().done(function () {
        console.log('hub connection open');
    });
});