using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.VanBan
{
    public class BanHanhDTO
    {
        [JsonProperty("tongDatId")]
        public long TongDatId { get; set; }
        [JsonProperty("tenFile")]
        public string TenFile { get; set; }
        [JsonProperty("voUserName")]
        public string VoUserName { get; set; }
        [JsonProperty("fileContent")]
        public string FileContent { get; set; }
        [JsonProperty("urlFile")]
        public string UrlFile { get; set; }
        [JsonProperty("loaiAnId")]
        public long LoaiAnId { get; set; }
        [JsonProperty("loaiTongDat")]
        public long LoaiTongDat { get; set; }
        [JsonProperty("ttDuongSu")]
        public List<TTDuongSuDTO> TTDuongSuDTOs { get; set; }
    }

    public class TTDuongSuDTO
    {
        [JsonProperty("partiesId")]
        public long PartiesId { get; set; }
        [JsonProperty("sendDate")]
        public DateTime SendDate { get; set; }
    }
}