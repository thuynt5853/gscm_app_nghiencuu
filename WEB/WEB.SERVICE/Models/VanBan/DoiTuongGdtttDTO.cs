using Newtonsoft.Json;

namespace WEB.Service.Models.VanBan
{
    public class DoiTuongGdtttDTO
    {
        [JsonProperty("tucachtotung")]
        public string Tucachtotung { get; set; }

        [JsonProperty("noinhanid")]
        public decimal NoinhanId { get; set; }

        [JsonProperty("noinhan")]
        public string Noinhan { get; set; }

        [JsonProperty("hinhthucgui")]
        public decimal Hinhthucgui { get; set; }

        [JsonProperty("phathanhlai_id")]
        public decimal Phathanhlai_id { get; set; }

        [JsonProperty("diachi")]
        public string Diachi { get; set; }
    }
}