using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.VanBan
{
    public class VanBanDenFileDTO
    {

        [JsonProperty("documentId")]
        public string DocumentId { get; set; }

        [JsonProperty("attachment")]
        public string Attachment { get; set; }

        [JsonProperty("contentId")]
        public string ContentId { get; set; }

        [JsonProperty("attachmentName")]
        public string AttachmentName { get; set; }

        [JsonProperty("contentType")]
        public string ContentType { get; set; }

        [JsonProperty("ContentTransferEncoded")]
        public string ContentTransferEncoded { get; set; }

        [JsonProperty("createDate")]
        public DateTime? CreateDate { get; set; }

        [JsonProperty("createUser")]
        public string CreateUser { get; set; }
    }
}