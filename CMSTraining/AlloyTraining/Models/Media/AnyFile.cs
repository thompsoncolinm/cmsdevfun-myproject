using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAnnotations;
using System;
using System.ComponentModel.DataAnnotations;

namespace AlloyTraining.Models.Media
{
    [ContentType(DisplayName = "Any File",
        GUID = "461b7caf-fa15-47a3-b927-f0028448119d",
        Description = "Drop any filetype to link to")]
    public class AnyFile : MediaData
    {

    }
}