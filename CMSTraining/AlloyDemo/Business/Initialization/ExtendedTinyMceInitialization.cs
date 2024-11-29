using AlloyDemo.Models.Blocks;
using AlloyDemo.Models.Pages;
using AlloyDemo.Models.Media;
using EPiServer.Cms.TinyMce.Core;
using EPiServer.Framework;
using EPiServer.Framework.Initialization;
using EPiServer.ServiceLocation;
using System.Drawing;
using EPiServer;
using EPiServer.Core;

namespace AlloyDemo.Business.Initialization
{
    [ModuleDependency(typeof(TinyMceInitialization))]
    public class ExtendedTinyMceInitialization : IConfigurableModule
    {
        private IContentEvents _contentEvents;

        public void Initialize(InitializationEngine context)
        {
            _contentEvents = ServiceLocator.Current.GetInstance<IContentEvents>();
            _contentEvents.CreatingContent += ContentEventsOnCreatingContent;
        }

        private void ContentEventsOnCreatingContent(object sender, ContentEventArgs contentEventArgs)
        {
            if (contentEventArgs.Content is ImageFile imageFile && imageFile.BinaryData != null)
            {
                using (var image = Image.FromStream(imageFile.BinaryData.OpenRead()))
                {
                    imageFile.Width = image.Width;
                    imageFile.Height = image.Height;
                }
            }
        }

        public void Uninitialize(InitializationEngine context)
        {
            _contentEvents.CreatingContent -= ContentEventsOnCreatingContent;
        }

        public void ConfigureContainer(ServiceConfigurationContext context)
        {
            context.Services.Configure<TinyMceConfiguration>(config =>
            {
                // Add content CSS to the default settings.
                // Add the advanced list styles, table, and code plugins and append buttons
                // for inserting and editing tables and showing source code to the toolbar
                config.Default()
                    .AddPlugin("advlist table code image")
                    .AppendToolbar("table code image")
                    .AddSetting("entity_encoding", "raw")
                    .AddSetting("images_file_types", "jpeg,jpg,jpe,jfi,jif,jfif,png,gif,bmp,webp")
                    .ContentCss("/static/css/editor.css");

                // This will clone the default settings object and extend it by
                // limiting the block formats for the MainBody property of an ArticlePage.
                config.For<ArticlePage>(t => t.MainBody)
                    .BlockFormats("Paragraph=p;Header 1=h1;Header 2=h2;Header 3=h3");

                // Passing a second argument to For<> will clone the given settings object
                // instead of the default one and extend it with some basic toolbar commands.
                config.For<EditorialBlock>(t => t.MainBody, config.Empty())
                    .AddEpiserverSupport()
                    .DisableMenubar()
                    .Toolbar("bold italic underline strikethrough");
            });
        }
    }
}