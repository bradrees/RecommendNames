// <auto-generated />
// This file was generated by a T4 template.
// Don't change it directly as your change would get overwritten.  Instead, make changes
// to the .tt file (i.e. the T4 template) and save it to regenerate this file.

// Make sure the compiler doesn't complain about missing Xml comments
#pragma warning disable 1591
#region T4MVC

using System;
using System.Diagnostics;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using System.Web.Mvc.Html;
using System.Web.Routing;
using T4MVC;
namespace WebRole.Controllers {
    public partial class HomeController {
        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public HomeController() { }

        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        protected HomeController(Dummy d) { }

        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        protected RedirectToRouteResult RedirectToAction(ActionResult result) {
            var callInfo = result.GetT4MVCResult();
            return RedirectToRoute(callInfo.RouteValueDictionary);
        }

        [NonAction]
        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public System.Web.Mvc.PartialViewResult RelatedNames() {
            return new T4MVC_PartialViewResult(Area, Name, ActionNames.RelatedNames);
        }
        [NonAction]
        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public System.Web.Mvc.HttpStatusCodeResult AddGenderInfo() {
            return new T4MVC_HttpStatusCodeResult(Area, Name, ActionNames.AddGenderInfo);
        }
        [NonAction]
        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public System.Web.Mvc.JsonResult GetNamesByPrefix() {
            return new T4MVC_JsonResult(Area, Name, ActionNames.GetNamesByPrefix);
        }

        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public HomeController Actions { get { return MVC.Home; } }
        [GeneratedCode("T4MVC", "2.0")]
        public readonly string Area = "";
        [GeneratedCode("T4MVC", "2.0")]
        public readonly string Name = "Home";

        static readonly ActionNamesClass s_actions = new ActionNamesClass();
        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public ActionNamesClass ActionNames { get { return s_actions; } }
        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public class ActionNamesClass {
            public readonly string Index = "Index";
            public readonly string RelatedNames = "RelatedNames";
            public readonly string About = "About";
            public readonly string AddGenderInfo = "AddGenderInfo";
            public readonly string GetNamesByPrefix = "GetNamesByPrefix";
        }


        static readonly ViewNames s_views = new ViewNames();
        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public ViewNames Views { get { return s_views; } }
        [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
        public class ViewNames {
            public readonly string About = "~/Views/Home/About.cshtml";
            public readonly string Index = "~/Views/Home/Index.cshtml";
            public readonly string RelatedNames = "~/Views/Home/RelatedNames.cshtml";
        }
    }

    [GeneratedCode("T4MVC", "2.0"), DebuggerNonUserCode]
    public class T4MVC_HomeController: WebRole.Controllers.HomeController {
        public T4MVC_HomeController() : base(Dummy.Instance) { }

        public override System.Web.Mvc.ActionResult Index() {
            var callInfo = new T4MVC_ActionResult(Area, Name, ActionNames.Index);
            return callInfo;
        }

        public override System.Web.Mvc.PartialViewResult RelatedNames(string include, string exclude, string block) {
            var callInfo = new T4MVC_PartialViewResult(Area, Name, ActionNames.RelatedNames);
            callInfo.RouteValueDictionary.Add("include", include);
            callInfo.RouteValueDictionary.Add("exclude", exclude);
            callInfo.RouteValueDictionary.Add("block", block);
            return callInfo;
        }

        public override System.Web.Mvc.ActionResult About() {
            var callInfo = new T4MVC_ActionResult(Area, Name, ActionNames.About);
            return callInfo;
        }

        public override System.Web.Mvc.HttpStatusCodeResult AddGenderInfo(string name, bool isMale) {
            var callInfo = new T4MVC_HttpStatusCodeResult(Area, Name, ActionNames.AddGenderInfo);
            callInfo.RouteValueDictionary.Add("name", name);
            callInfo.RouteValueDictionary.Add("isMale", isMale);
            return callInfo;
        }

        public override System.Web.Mvc.JsonResult GetNamesByPrefix(string term) {
            var callInfo = new T4MVC_JsonResult(Area, Name, ActionNames.GetNamesByPrefix);
            callInfo.RouteValueDictionary.Add("term", term);
            return callInfo;
        }

    }
}

#endregion T4MVC
#pragma warning restore 1591