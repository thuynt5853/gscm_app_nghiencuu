using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.DM_VOFFICE
{
    public class DMTinhDTO
    {
        [JsonProperty("Id")]
        public decimal id { get; set; }

        [JsonProperty("MaTinh")]
        public string maTinh { get; set; }

        [JsonProperty("TenTinh")]
        public string tenTinh { get; set; }

        [JsonProperty("ParentId")]
        public decimal? parentId { get; set; }

        [JsonProperty("Children")]
        public List<DMTinhDTO> children { get; set; }
    }
}