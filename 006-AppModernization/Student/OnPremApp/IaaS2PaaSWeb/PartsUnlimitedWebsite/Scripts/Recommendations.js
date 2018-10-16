function getRecommendations(productId) {
    $.ajax({
        url: "/Recommendations/GetRecommendations",
        type: "GET",
        data: { productId: productId },
        success: function (data) {
            $("#recommendations-panel").html(data);
        },
        error: function (error) {
            alert("Failed to get recommendations...");
        },
    })
}