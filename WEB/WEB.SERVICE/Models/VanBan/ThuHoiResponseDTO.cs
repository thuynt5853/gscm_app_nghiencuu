using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.VanBan
{
    public class ThuHoiResponseDTO
    {

        [JsonProperty("Message")]
        public string Message{ get; set; }

        [JsonProperty("Status")]
        public string Status { get; set; }

        [JsonProperty("AllocatedList")]
        public List<decimal> AllocatedList { get; set; }

        [JsonProperty("ExecutedList")]
        public List<decimal> ExecutedList { get; set; }
    }
}