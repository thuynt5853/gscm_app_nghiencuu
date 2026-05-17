using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.VanBan
{
    public class MoKhoaTongDatDTO
    {
        [JsonProperty("tongDatId")]
        public decimal TongDatId { get; set; }
        [JsonProperty("duongSuId")]
        public decimal DuongSuId { get; set; }
    }
}