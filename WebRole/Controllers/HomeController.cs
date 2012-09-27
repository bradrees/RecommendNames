using System;
using System.Web.Mvc;

namespace WebRole.Controllers
{
    public partial class HomeController : Controller
    {
        [OutputCache(Duration = 60)]
        public virtual ActionResult Index()
        {
            return View();
        }

        [OutputCache(Duration = 600)]
        public virtual PartialViewResult RelatedNames(string include, string exclude, string block)
        {
            include = String.IsNullOrWhiteSpace(include) ? "michael" : include;
            exclude = exclude ?? String.Empty;
            block = block ?? String.Empty;

            var results = DatabaseService.GetRelatedNames(include, exclude, block);

            return PartialView(results);
        }

        [OutputCache(Duration = 60)]
        public virtual ActionResult About()
        {
            return PartialView();
        }

        public virtual HttpStatusCodeResult AddGenderInfo(string name, bool isMale)
        {
            DatabaseService.AddGenderInformation(name, isMale);
            return new HttpStatusCodeResult(204);
        }

        [OutputCache(Duration = 6000)]
        public virtual JsonResult GetNamesByPrefix(string term)
        {
            var names = DatabaseService.GetNamesByPrefix(term);
            return new JsonResult {Data = names, JsonRequestBehavior = JsonRequestBehavior.AllowGet};
        }
    }
}