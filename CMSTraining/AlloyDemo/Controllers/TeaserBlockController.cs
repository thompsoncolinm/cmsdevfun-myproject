using AlloyDemo.Models.Blocks;
using AlloyDemo.Models.Media;
using EPiServer;
using EPiServer.Core;
using EPiServer.Web.Mvc;
using EPiServer.Web.Routing;
using System.Web.Mvc;

namespace AlloyDemo.Controllers
{
    public class TeaserBlockController : BlockController<TeaserBlock>
    {
        private readonly IContentLoader _contentLoader;
        private readonly UrlResolver _urlResolver;

        public TeaserBlockController(IContentLoader contentLoader, UrlResolver urlResolver)
        {
            _contentLoader = contentLoader;
            _urlResolver = urlResolver;
        }

        public override ActionResult Index(TeaserBlock currentBlock)
        {
            if (currentBlock.Image != null)
            {
                var imageFile = _contentLoader.Get<ImageFile>(currentBlock.Image);
                if (imageFile != null)
                {
                    currentBlock.ImageHeight = imageFile.Height;
                    currentBlock.ImageWidth = imageFile.Width;
                }
            }

            return PartialView(currentBlock);
        }
    }
}