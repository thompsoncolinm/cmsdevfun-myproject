using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAnnotations;
using EPiServer.Framework.DataAnnotations;
using System;
using System.ComponentModel.DataAnnotations;

namespace AlloyTraining.Models.Media
{
    [ContentType(DisplayName = "Image File",
        GUID = "703957dd-3084-4c26-a162-f6c92eb4ab6a",
        Description = "Image upload (png, jpeg, jpg, gif)")]
    [MediaDescriptor(ExtensionString = "png, jpeg, jpg, gif")]
    public class ImageFile : ImageData
    {
                [CultureSpecific]
                [Editable(true)]
                public virtual string Description { get; set; }
    }
}