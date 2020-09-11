using ContosoTravel.Web.Application.Data;
using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Interfaces.MVC;
using ContosoTravel.Web.Application.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Controllers.MVC
{
    public class ItineraryController : IItineraryController
    {
        private readonly IItineraryDataProvider _itineraryDataProvider;
        private readonly ICartCookieProvider _cartCookieProvider;
        private readonly CartDisplayProvider _cartDisplayProvider;

        public ItineraryController(IItineraryDataProvider itineraryController, ICartCookieProvider cartCookieProvider, CartDisplayProvider cartDisplayProvider)
        {
            _itineraryDataProvider = itineraryController;
            _cartCookieProvider = cartCookieProvider;
            _cartDisplayProvider = cartDisplayProvider;
        }

        public async Task<ItineraryModel> GetByCartId(CancellationToken cancellationToken)
        {
            string cookieId = _cartCookieProvider.GetCartCookie();
            var itinerary = await _itineraryDataProvider.FindItinerary(cookieId, cancellationToken);

            if (itinerary == null)
            {
                return null;
            }

            return await _cartDisplayProvider.LoadFullItinerary(itinerary, cancellationToken);
        }

        public async Task<ItineraryModel> GetByRecordLocator(string recordLocator, CancellationToken cancellationToken)
        {
            var itinerary = await _itineraryDataProvider.GetItinerary(recordLocator, cancellationToken);
            return await _cartDisplayProvider.LoadFullItinerary(itinerary, cancellationToken);
        }
    }
}
