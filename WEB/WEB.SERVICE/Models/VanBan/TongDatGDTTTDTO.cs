using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.VanBan
{
    public class TongDatGdtttDTO
    {
        [JsonProperty("id")]
        public decimal Id { get; set; }

        [JsonProperty("toaAnId")]
        public decimal ToaAnId { get; set; }

        [JsonProperty("tenvanban")]
        public string Tenvanban { get; set; }

        [JsonProperty("soVb")]
        public string SoVb { get; set; }

        [JsonProperty("ngayVb")]
        public DateTime NgayVb { get; set; }

        [JsonProperty("nguoiky")]
        public decimal? Nguoiky { get; set; }

        [JsonProperty("donviphathanh")]
        public string Donviphathanh { get; set; }

        [JsonProperty("doiTuong")]
        public List<DoiTuongGdtttDTO> DoiTuong { get; set; }
    }
}