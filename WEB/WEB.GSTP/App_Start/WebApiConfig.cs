using System.Web.Http;
using WEB.Service.Handler;

namespace WEB.GSTP
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
            config.MessageHandlers.Add(new LogRequestAndResponseHandler());

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{MaDongBo}",
                defaults: new { MaDongBo = RouteParameter.Optional }
            );
        }
    }
}
