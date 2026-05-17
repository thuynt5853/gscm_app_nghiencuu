using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.VanBan
{
    public class TraKetQuaDTO
    {
        [JsonProperty("tongDatId")]
        public long TongDatId { get; set; }
        [JsonProperty("loaiAnId")]
        public long LoaiAnId { get; set; }
        [JsonProperty("loaiTongDat")]
        public long LoaiTongDat { get; set; }
        [JsonProperty("partiesId")]
        public long PartiesId { get; set; }
        [JsonProperty("sendDate")]
        public DateTime? SendDate { get; set; }
        [JsonProperty("ReceiveDateParties")]
        public DateTime? ReceiveDateParties { get; set; }
        [JsonProperty("returnDate")]
        public DateTime? ReturnDate { get; set; }
        [JsonProperty("reason")]
        public string Reason { get; set; }
    }
}