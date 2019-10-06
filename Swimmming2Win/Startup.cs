using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Swimmming2Win.Startup))]
namespace Swimmming2Win
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
