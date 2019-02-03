using ContosoTravel.Web.Application.Data;
using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Interfaces.MVC;
using ContosoTravel.Web.Application.Models;
using System.Threading;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Application.Controllers.MVC
{
    public class CartController : ICartController
    {
        private readonly ICartDataProvider _cartDataProvider;
        private readonly ICartCookieProvider _cartCookieProvider;
        private readonly IItineraryController _itineraryController;
        private readonly IPurchaseService _purchaseService;
        private readonly CartDisplayProvider _cartDisplayProvider;

        public CartController(ICartDataProvider cartDataProvider, ICartCookieProvider cartCookieProvider, IItineraryController itineraryController, IPurchaseService purchaseService, CartDisplayProvider cartDisplayProvider)
        {
            _cartDataProvider = cartDataProvider;
            _cartCookieProvider = cartCookieProvider;
            _itineraryController = itineraryController;
            _purchaseService = purchaseService;
            _cartDisplayProvider = cartDisplayProvider;
        }

        // Make sure to return an empty cart if there isn't a purchased Itinerary 
        public async Task<CartModel> Index(CancellationToken cancellationToken)
        {
            string cartId = _cartCookieProvider.GetCartCookie();
            var cart = await _cartDataProvider.GetCart(cartId, cancellationToken);

            if (cart != null)
            {
                return await _cartDisplayProvider.LoadFullCart<CartModel>(cart, cancellationToken);
            }
            
            if ( (await _itineraryController.GetByCartId(cancellationToken)) == null )
            {
                return new CartModel() { Id = System.Guid.Parse(cartId) };
            }

            return null;
        }

        public async Task<bool> Purchase(System.DateTimeOffset PurchasedOn, CancellationToken cancellationToken)
        {
            string cartId = _cartCookieProvider.GetCartCookie();
            var cart = await _cartDataProvider.GetCart(cartId, cancellationToken);

            if ( cart == null )
            {
                return false;
            }

            return await _purchaseService.SendForProcessing(cart.Id, PurchasedOn, cancellationToken);
        }
    }
}
