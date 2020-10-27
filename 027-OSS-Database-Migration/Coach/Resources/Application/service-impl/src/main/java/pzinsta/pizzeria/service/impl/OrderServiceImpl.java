package pzinsta.pizzeria.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pzinsta.pizzeria.dao.BakeStyleDAO;
import pzinsta.pizzeria.dao.CrustDAO;
import pzinsta.pizzeria.dao.CustomerDAO;
import pzinsta.pizzeria.dao.CutStyleDAO;
import pzinsta.pizzeria.dao.IngredientDAO;
import pzinsta.pizzeria.dao.OrderDAO;
import pzinsta.pizzeria.dao.OrderItemDAO;
import pzinsta.pizzeria.dao.PizzaSizeDAO;
import pzinsta.pizzeria.model.order.Cart;
import pzinsta.pizzeria.model.order.Order;
import pzinsta.pizzeria.model.order.OrderEvent;
import pzinsta.pizzeria.model.order.OrderEventType;
import pzinsta.pizzeria.model.order.OrderItem;
import pzinsta.pizzeria.model.order.Review;
import pzinsta.pizzeria.model.pizza.BakeStyle;
import pzinsta.pizzeria.model.pizza.Crust;
import pzinsta.pizzeria.model.pizza.CutStyle;
import pzinsta.pizzeria.model.pizza.Ingredient;
import pzinsta.pizzeria.model.pizza.IngredientType;
import pzinsta.pizzeria.model.pizza.Pizza;
import pzinsta.pizzeria.model.pizza.PizzaItem;
import pzinsta.pizzeria.model.pizza.PizzaSide;
import pzinsta.pizzeria.model.pizza.PizzaSize;
import pzinsta.pizzeria.service.OrderService;
import pzinsta.pizzeria.service.dto.PizzaOrderDTO;
import pzinsta.pizzeria.service.dto.ReviewDTO;
import pzinsta.pizzeria.service.exception.OrderNotFoundException;
import pzinsta.pizzeria.service.impl.strategy.TrackingNumberGenerationStrategy;

import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static java.util.stream.Collectors.toList;

@Service("orderService")
public class OrderServiceImpl implements OrderService {

    private CrustDAO crustDAO;
    private PizzaSizeDAO pizzaSizeDAO;
    private BakeStyleDAO bakeStyleDAO;
    private CutStyleDAO cutStyleDAO;
    private IngredientDAO ingredientDAO;
    private OrderDAO orderDAO;
    private CustomerDAO customerDAO;
    private OrderItemDAO orderItemDAO;

    private Cart cart;

    @Value("${pizza.quantity.min}")
    private int minQuantity;

    @Value("${pizza.quantity.max}")
    private int maxQuantity;

    private TrackingNumberGenerationStrategy trackingNumberGenerationStrategy;

    @Override
    @Transactional(readOnly = true)
    public Collection<Crust> getCrusts() {
        return crustDAO.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Collection<PizzaSize> getPizzaSizes() {
        return pizzaSizeDAO.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Collection<BakeStyle> getBakeStyles() {
        return bakeStyleDAO.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Collection<CutStyle> getCutStyles() {
        return cutStyleDAO.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Collection<Ingredient> getIngredients() {
        return ingredientDAO.findAll();
    }

    @Override
    public Collection<Integer> getQuantities() {
        return IntStream.rangeClosed(minQuantity, maxQuantity).boxed().collect(toList());
    }

    @Override
    public void addOrderItemToCart(PizzaOrderDTO pizzaOrderDTO) {
        cart.addOrderItem(createOrderItem(pizzaOrderDTO));
    }

    @Override
    public void removeOrderItem(int orderItemIndex) {
        cart.removeOrderItemById(orderItemIndex);
    }

    @Override
    public void emptyCart() {
        cart.reset();
    }

    @Override
    public void replaceOrderItem(int orderItemIndex, PizzaOrderDTO pizzaOrderDTO) {
        cart.removeOrderItemById(orderItemIndex);
        cart.addOrderItem(createOrderItem(pizzaOrderDTO));
    }

    @Override
    public PizzaOrderDTO getPizzaOrderDTOByOrderItemId(int orderItemIndex) {
        return createPizzaOrderDTO(cart.getOrderItemById(orderItemIndex).orElseThrow(RuntimeException::new));
    }

    @Override
    @Transactional(readOnly = true)
    public IngredientType getIngredientTypeByIngredientId(Long ingredientId) {
        return ingredientDAO.findById(ingredientId).orElseThrow(RuntimeException::new).getIngredientType();
    }

    @Override
    @Transactional(readOnly = true)
    public Ingredient getIngredientById(Long ingredientId) {
        return ingredientDAO.findById(ingredientId).orElseThrow(RuntimeException::new);
    }

    @Override
    @Transactional
    public Order postOrder(Order order) {
        OrderEvent orderEvent = new OrderEvent();
        orderEvent.setOccurredOn(Instant.now());
        orderEvent.setOrderEventType(OrderEventType.PURCHASED);
        order.getOrderEvents().add(orderEvent);
        order = orderDAO.saveOrUpdate(order);
        order.setTrackingNumber(trackingNumberGenerationStrategy.generatetrackingNumber(order));
        return order;
    }

    @Override
    @Transactional(readOnly = true)
    public Order getOrderByTrackingNumber(String trackingNumber) {
        return orderDAO.findByTrackingNumber(trackingNumber).orElseThrow(OrderNotFoundException::new);
    }

    @Override
    @Transactional
    public void addReviewToOrderByTrackingNumber(String trackingNumber, ReviewDTO reviewDTO) {
        Order order = orderDAO.findByTrackingNumber(trackingNumber).orElseThrow(OrderNotFoundException::new);
        Review review = Optional.ofNullable(order.getReview()).orElseGet(Review::new);
        review.setOrder(order);
        review.setMessage(reviewDTO.getMessage());
        review.setRating(reviewDTO.getRating());
        review.setImages(reviewDTO.getFiles());
        order.setReview(review);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<PizzaOrderDTO> getPizzaOrderDTOByOrderItemId(Long orderItemId) {
        return orderItemDAO.findById(orderItemId).map(this::createPizzaOrderDTO);
    }

    private PizzaOrderDTO createPizzaOrderDTO(OrderItem orderItem) {
        PizzaOrderDTO pizzaOrderDTO = new PizzaOrderDTO();
        pizzaOrderDTO.setId(orderItem.getId());
        pizzaOrderDTO.setQuantity(orderItem.getQuantity());

        Pizza pizza = orderItem.getPizza();
        pizzaOrderDTO.setBakeStyleId(pizza.getBakeStyle().getId());
        pizzaOrderDTO.setCrustId(pizza.getCrust().getId());
        pizzaOrderDTO.setCutStyleId(pizza.getCutStyle().getId());
        pizzaOrderDTO.setPizzaSizeId(pizza.getSize().getId());

        pizzaOrderDTO.setLeftSideIngredientIdByQuantity(getIngredientsByQuantity(pizza.getLeftPizzaSide()));
        pizzaOrderDTO.setRightSideIngredientIdByQuantity(getIngredientsByQuantity(pizza.getRightPizzaSide()));

        return pizzaOrderDTO;
    }

    private Map<Long, Integer> getIngredientsByQuantity(PizzaSide pizzaSide) {
        return pizzaSide.getPizzaItems().stream().collect(Collectors.toMap(pizzaItem -> pizzaItem.getIngredient().getId(), PizzaItem::getQuantity));
    }

    private OrderItem createOrderItem(PizzaOrderDTO pizzaOrderDTO) {
        OrderItem orderItem = new OrderItem();
        orderItem.setPizza(createPizza(pizzaOrderDTO));
        orderItem.setQuantity(pizzaOrderDTO.getQuantity());
        return orderItem;
    }

    private Pizza createPizza(PizzaOrderDTO pizzaOrderDTO) {
        Pizza pizza = new Pizza();

        pizza.setBakeStyle(getBakeStyle(pizzaOrderDTO.getBakeStyleId()));
        pizza.setCrust(getCrust(pizzaOrderDTO.getCrustId()));
        pizza.setCutStyle(getCutStyle(pizzaOrderDTO.getCutStyleId()));
        pizza.setSize(getPizzaSize(pizzaOrderDTO.getPizzaSizeId()));

        pizza.setLeftPizzaSide(createPizzaSide(pizzaOrderDTO.getLeftSideIngredientIdByQuantity()));
        pizza.setRightPizzaSide(createPizzaSide(pizzaOrderDTO.getRightSideIngredientIdByQuantity()));

        return pizza;
    }

    private PizzaSize getPizzaSize(Long pizzaSizeId) {
        return pizzaSizeDAO.findById(pizzaSizeId).orElseThrow(RuntimeException::new);
    }

    private CutStyle getCutStyle(Long cutStyleId) {
        return cutStyleDAO.findById(cutStyleId).orElseThrow(RuntimeException::new);
    }

    private Crust getCrust(Long crustId) {
        return crustDAO.findById(crustId).orElseThrow(RuntimeException::new);
    }

    private BakeStyle getBakeStyle(Long bakeStyleId) {
        return bakeStyleDAO.findById(bakeStyleId).orElseThrow(RuntimeException::new);
    }

    private PizzaSide createPizzaSide(Map<Long, Integer> ingredientIdByQuantity) {
        PizzaSide pizzaSide = new PizzaSide();
        List<PizzaItem> pizzaItems = ingredientIdByQuantity.entrySet().stream().map(this::createPizzaItem).collect(toList());
        pizzaSide.setPizzaItems(pizzaItems);
        return pizzaSide;
    }

    private PizzaItem createPizzaItem(Map.Entry<Long, Integer> longIntegerEntry) {
        Ingredient ingredient = ingredientDAO.findById(longIntegerEntry.getKey()).orElseThrow(RuntimeException::new);
        PizzaItem pizzaItem = new PizzaItem();
        pizzaItem.setQuantity(longIntegerEntry.getValue());
        pizzaItem.setIngredient(ingredient);
        return pizzaItem;
    }

    public int getMaxQuantity() {
        return maxQuantity;
    }

    public void setMaxQuantity(int maxQuantity) {
        this.maxQuantity = maxQuantity;
    }

    public int getMinQuantity() {
        return minQuantity;
    }

    public void setMinQuantity(int minQuantity) {
        this.minQuantity = minQuantity;
    }

    public CrustDAO getCrustDAO() {
        return crustDAO;
    }


    @Autowired
    public void setCrustDAO(CrustDAO crustDAO) {
        this.crustDAO = crustDAO;
    }

    public PizzaSizeDAO getPizzaSizeDAO() {
        return pizzaSizeDAO;
    }

    @Autowired
    public void setPizzaSizeDAO(PizzaSizeDAO pizzaSizeDAO) {
        this.pizzaSizeDAO = pizzaSizeDAO;
    }

    public BakeStyleDAO getBakeStyleDAO() {
        return bakeStyleDAO;
    }

    @Autowired
    public void setBakeStyleDAO(BakeStyleDAO bakeStyleDAO) {
        this.bakeStyleDAO = bakeStyleDAO;
    }

    public CutStyleDAO getCutStyleDAO() {
        return cutStyleDAO;
    }

    @Autowired
    public void setCutStyleDAO(CutStyleDAO cutStyleDAO) {
        this.cutStyleDAO = cutStyleDAO;
    }

    public IngredientDAO getIngredientDAO() {
        return ingredientDAO;
    }

    @Autowired
    public void setIngredientDAO(IngredientDAO ingredientDAO) {
        this.ingredientDAO = ingredientDAO;
    }

    public OrderDAO getOrderDAO() {
        return orderDAO;
    }

    @Autowired
    public void setOrderDAO(OrderDAO orderDAO) {
        this.orderDAO = orderDAO;
    }

    public Cart getCart() {
        return cart;
    }

    @Autowired
    public void setCart(Cart cart) {
        this.cart = cart;
    }

    public CustomerDAO getCustomerDAO() {
        return customerDAO;
    }

    @Autowired
    public void setCustomerDAO(CustomerDAO customerDAO) {
        this.customerDAO = customerDAO;
    }

    public TrackingNumberGenerationStrategy getTrackingNumberGenerationStrategy() {
        return trackingNumberGenerationStrategy;
    }

    @Autowired
    public void setTrackingNumberGenerationStrategy(TrackingNumberGenerationStrategy trackingNumberGenerationStrategy) {
        this.trackingNumberGenerationStrategy = trackingNumberGenerationStrategy;
    }

    public OrderItemDAO getOrderItemDAO() {
        return orderItemDAO;
    }

    @Autowired
    public void setOrderItemDAO(OrderItemDAO orderItemDAO) {
        this.orderItemDAO = orderItemDAO;
    }
}
