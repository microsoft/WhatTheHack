using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using InventoryService.Api.Models;
using InventoryService.Api.Services;
using Moq;
using Xunit;

namespace InventoryService.Tests
{
    public class InventoryManagerTests
    {
        [Fact]
        public async Task GetInventoryBySkus_ShouldReturnInventory()
        {
            var input = new [] { " sku1 ", "sku2" };
            var dataMock = new Mock<IInventoryData>();
            dataMock
                .Setup(m => m.GetInventoryBySkus(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(new []
                    { 
                        new InventoryItem { Sku = "sku1" },
                        new InventoryItem { Sku = "sku2" }
                    });
            var notificationsMock = new Mock<IInventoryNotificationService>();
            var sut = new InventoryManager(dataMock.Object, null, notificationsMock.Object);

            var actual = await sut.GetInventoryBySkus(input);

            Assert.Equal(new [] { "sku1", "sku2" }, actual.Select(i => i.Sku));
        }

        [Fact]
        public async Task GetInventoryBySkus_ShouldAddMissingSkus()
        {
            var input = new [] { "sku1", "sku2", "sku3" };
            var createdItems = new List<InventoryItem>();
            var dataMock = new Mock<IInventoryData>();
            dataMock
                .Setup(m => m.GetInventoryBySkus(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(new []
                    { 
                        new InventoryItem { Sku = "sku1" }
                    });
            dataMock
                .Setup(m => m.CreateInventory(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<DateTime>()))
                .Callback((string sku, int qty, DateTime modified) => createdItems.Add(new InventoryItem { Sku = sku, Quantity = qty }))
                .ReturnsAsync((string sku, int qty, DateTime modified) => new InventoryItem { Sku = sku, Quantity = qty });
            var notificationsMock = new Mock<IInventoryNotificationService>();
            notificationsMock
                .Setup(m => m.NotifyInventoryChanged(It.IsAny<InventoryItem>()))
                .Returns(Task.CompletedTask);
            var sut = new InventoryManager(dataMock.Object, null, notificationsMock.Object);

            var actual = await sut.GetInventoryBySkus(input);

            Assert.Equal(input, actual.Select(i => i.Sku));
            Assert.Equal(new [] { "sku2", "sku3" }, createdItems.Select(i => i.Sku));
            notificationsMock.Verify(m => m.NotifyInventoryChanged(
                It.Is<InventoryItem>(i => i.Sku == "sku2" && i.Quantity == createdItems.First(c => c.Sku == "sku2").Quantity)));
             notificationsMock.Verify(m => m.NotifyInventoryChanged(
                It.Is<InventoryItem>(i => i.Sku == "sku3" && i.Quantity == createdItems.First(c => c.Sku == "sku3").Quantity)));
           notificationsMock.VerifyNoOtherCalls();
        }

        [Fact]
        public async Task IncrementInventory_IncrementsQuantityByOne()
        {
            var dataMock = new Mock<IInventoryData>();
            dataMock
                .Setup(m => m.UpdateInventory(It.IsAny<string>(), It.IsAny<int>()))
                .ReturnsAsync(new InventoryItem { Sku = "foo", Quantity = 10 });
            var notificationsMock = new Mock<IInventoryNotificationService>();
            notificationsMock
                .Setup(m => m.NotifyInventoryChanged(It.IsAny<InventoryItem>()))
                .Returns(Task.CompletedTask);
            var sut = new InventoryManager(dataMock.Object, null, notificationsMock.Object);

            var result = await sut.IncrementInventory("foo");

            dataMock.Verify(m => m.UpdateInventory("foo", 1), Times.Once);
            dataMock.VerifyNoOtherCalls();
            notificationsMock.Verify(m => m.NotifyInventoryChanged(
                It.Is<InventoryItem>(i => i.Sku == result.Sku && i.Quantity == result.Quantity)));
            notificationsMock.VerifyNoOtherCalls();
        }

        [Fact]
        public async Task DecrementInventory_DecrementsQuantityByOne()
        {
            var dataMock = new Mock<IInventoryData>();
            dataMock
                .Setup(m => m.UpdateInventory(It.IsAny<string>(), It.IsAny<int>()))
                .ReturnsAsync(new InventoryItem());
            var notificationsMock = new Mock<IInventoryNotificationService>();
            notificationsMock
                .Setup(m => m.NotifyInventoryChanged(It.IsAny<InventoryItem>()))
                .Returns(Task.CompletedTask);
            var sut = new InventoryManager(dataMock.Object, null, notificationsMock.Object);

            var result = await sut.DecrementInventory("foo");

            dataMock.Verify(m => m.UpdateInventory("foo", -1), Times.Once);
            dataMock.VerifyNoOtherCalls();
            notificationsMock.Verify(m => m.NotifyInventoryChanged(
                It.Is<InventoryItem>(i => i.Sku == result.Sku && i.Quantity == result.Quantity)));
            notificationsMock.VerifyNoOtherCalls();
        }
    }
}
