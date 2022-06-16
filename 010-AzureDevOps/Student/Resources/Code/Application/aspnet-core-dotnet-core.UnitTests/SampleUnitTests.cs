using aspnet_core_dotnet_core.Controllers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace aspnet_core_dotnet_core.UnitTests
{
    [TestClass]
    public class SampleUnitTests
    {
        [TestMethod]
        public void IndexPageTest()
        {
            var controller = new HomeController();
            IActionResult result = controller.Index();
            Assert.AreEqual(null, controller.ViewData["Message"]);
        }

        [TestMethod]
        public void AboutPageTest()
        {
            var controller = new HomeController();
            IActionResult result = controller.About();
            Assert.AreEqual("Your application description page.", controller.ViewData["Message"]);
        }

        [TestMethod]
        public void ContactPageTest()
        {
            var controller = new HomeController();
            IActionResult result = controller.Contact();
            Assert.AreEqual("Your contact page.", controller.ViewData["Message"]);
        }
    }
}
