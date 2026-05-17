using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WEB.Service.Models.VanBan
{
    public class VanBanDenThuHoiDTO
    {

        [JsonProperty("MESSAGE")]
        public string Message { get; set; }

        [JsonProperty("NOTE")]
        public string Note { get; set; }

        [JsonProperty("DOCUMENT_ID")]
        public long? DocumentId { get; set; }

        [JsonProperty("RECEIVE_GROUP_ID")]
        public long? ReceiveGroupId { get; set; }

        [JsonProperty("PROCESS_ID")]
        public long? ProcessId { get; set; }

        [JsonProperty("SEND_DATE")]
        public DateTime? SendDate { get; set; }

       
    }
}