using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.VanBan
{
    public class ThuHoiRequestDTO
    {

        [JsonProperty("reallocateReason")]
        public string Reason{ get; set; }

        [JsonProperty("reallocateUser")]
        public string UserReall { get; set; }

        [JsonProperty("reallocateDate")]
        public DateTime? DateReall { get; set; }

        [JsonProperty("allocatedList")]
        public List<decimal> AllocatedList { get; set; }
    }
}