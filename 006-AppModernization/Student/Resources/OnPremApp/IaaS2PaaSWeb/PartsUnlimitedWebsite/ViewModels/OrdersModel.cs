using PartsUnlimited.Models;
using System;
using System.Collections.Generic;

namespace PartsUnlimited.ViewModels
{
    public class OrdersModel
    {
        public bool IsAdminSearch { get; private set; }
        public string InvalidOrderSearch { get; private set; }
        public IEnumerable<Order> Orders { get; private set; }
        public string Username { get; private set; }
        public DateTimeOffset StartDate { get; private set; }
        public DateTimeOffset EndDate { get; private set; }

        public OrdersModel(IEnumerable<Order> orders, string username, DateTimeOffset startDate, DateTimeOffset endDate, string invalidOrderSearch, bool isAdminSearch)
        {
            Orders = orders;
            Username = username;
            StartDate = startDate;
            EndDate = endDate;
            InvalidOrderSearch = invalidOrderSearch;
            IsAdminSearch = isAdminSearch;
        }

    }
}
