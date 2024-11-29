using EPiServer.Core;
using EPiServer.DataAnnotations;
using EPiServer.Framework.DataAnnotations;
using System.ComponentModel.DataAnnotations;

namespace AlloyDemo.Models.Media
{
    [ContentType(DisplayName = "Image File", GUID = "0A89E464-56D4-449F-AEA8-2BF774AB8730", Description = "")]
    [MediaDescriptor(ExtensionString = "jpg,jpeg,jpe,ico,gif,bmp,png,webp")]
    public class ImageFile : ImageData
    {
        public virtual int Width { get; set; }
        public virtual int Height { get; set; }
        public virtual string Copyright { get; set; }
    }
}
