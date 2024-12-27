using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAnnotations;
using EPiServer.SpecializedProperties;
using System;
using System.ComponentModel.DataAnnotations;

namespace AlloyTraining.Models.Pages
{
    [ContentType(
        DisplayName = "StartPage",
        GroupName = SiteGroupNames.Specialized, Order = 10,
        GUID = "3a6a3942-e30c-4b3b-9943-c146b56d7b22",
        Description = ""
    )]
    [SiteStartIcon]
    public class StartPage : SitePageData
    {

        [CultureSpecific]
        [Display(Name = "Heading",
        Description = "If the Heading is not set, the page falls back to showing the Name.",
        GroupName = SystemTabNames.Content, Order = 10)]
        public virtual string Heading { get; set; }

        [CultureSpecific]
        [Display(Name = "Main body",
            Description = "The main body uses the XHTML-editor you can insert for example text, images, and tables.",
            GroupName = SystemTabNames.Content, Order = 20)]
        public virtual XhtmlString MainBody { get; set; }

        [CultureSpecific]
        [Display(Name = "Main content area",
            Description = "The main content area contains an ordered collection to content references, for example blocks, media assets, and pages.",
            GroupName = SystemTabNames.Content, Order = 30)]
        public virtual ContentArea MainContentArea { get; set; }

        [CultureSpecific]
        [Display(Name = "Footer text",
            Description = "The footer text is shown at the bottom of the page.",
            GroupName = SiteTabNames.SiteSettings, Order = 40)]
        public virtual String FooterText { get; set; }

    }
}
