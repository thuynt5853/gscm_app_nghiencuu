using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.DM_VOFFICE
{
    public class DM_LoaiVanBanDTO
    {

        [JsonProperty("Id")]
        public decimal id { get; set; }

        [JsonProperty("MaLoaiVanBan")]
        public string maLoaiVanBan { get; set; }

        [JsonProperty("TenLoaiVanBan")]
        public string tenLoaiVanBan { get; set; }

        [JsonProperty("Children")]
        public List<DM_LoaiVanBanDTO> children { get; set; }

        [JsonProperty("ToaAnId")]
        public decimal? toaAnId { get; set; }

        [JsonProperty("ParentToaAnId")]
        public decimal? capChaId { get; set; }
    }
}