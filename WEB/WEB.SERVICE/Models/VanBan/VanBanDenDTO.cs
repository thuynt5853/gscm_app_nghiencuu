using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WEB.Service.Models.VanBan
{
    public class VanBanDenDTO
    {

        [JsonProperty("receive_type_name")]
        public long? ReceiveTypeName { get; set; }

        [JsonProperty("receive_dept_id")]
        public long? ReceiveDeptId { get; set; }

        [JsonProperty("receive_user_id")]
        public long? ReceiveUserId { get; set; }

        [JsonProperty("document_type_id")]
        public long? DocumentTypeId { get; set; }

        [JsonProperty("book_number")]
        public long? BookNumber { get; set; }

        [JsonProperty("create_time")]
        public DateTime? CreateTime { get; set; }

        [JsonProperty("send_date")]
        public DateTime SendDate { get; set; }

        [JsonProperty("zip_code")]
        public string ZipCode { get; set; }

        [JsonProperty("date_post_mark")]
        public DateTime? DatePostMark { get; set; }

        [JsonProperty("weight")]
        public string Weight { get; set; }

        [JsonProperty("publish_agency_name")]
        public string PublishAgencyName { get; set; }

        [JsonProperty("province_letters_id")]
        public long? ProvinceLettersId { get; set; }

        [JsonProperty("district_letters_id")]
        public string DistrictLettersId { get; set; }

        [JsonProperty("details_letters")]
        public string DetailsLetters { get; set; }

        [JsonProperty("book_name")]
        public string BookName { get; set; }

        [JsonProperty("note")]
        public string Note { get; set; }

        [JsonProperty("petitioner")]
        public string Petitioner { get; set; }

        [JsonProperty("province_petition_id")]
        public long? ProvincePetitionId { get; set; }

        [JsonProperty("district_petition_id")]
        public string DistrictPetitionId { get; set; }

        [JsonProperty("details_petition")]
        public string DetailsPetition { get; set; }

        [JsonProperty("number_of_petitions")]
        public decimal? NumberOfPetitions { get; set; }

        [JsonProperty("propone_name")]
        public decimal? ProponeName { get; set; }

        [JsonProperty("baqd")]
        public decimal? Baqd { get; set; }

        [JsonProperty("baqd_number")]
        public string BaqdNumber { get; set; }

        [JsonProperty("baqd_date")]
        public DateTime BaqdDate { get; set; }

        [JsonProperty("court_baqd_id")]
        public decimal? CourtBaqdId { get; set; }

        [JsonProperty("trial_level")]
        public decimal? trialLevel { get; set; }

        [JsonProperty("type_of_sentence")]
        public decimal? TypeOfSentence { get; set; }

        [JsonProperty("document_code")]
        public string DocumentCode { get; set; }

        [JsonProperty("publish_date")]
        public DateTime PublishDate { get; set; }

        [JsonProperty("office_name")]
        public string officeName { get; set; }

        [JsonProperty("abstract_field")]
        public string AbstractField { get; set; }

        [JsonProperty("protester_id")]
        public decimal? ProtesterId { get; set; }

        [JsonProperty("receive_group_id")]
        public decimal? ReceiveGroupId { get; set; }

        [JsonProperty("security_id")]
        public string SecurityId { get; set; }

        [JsonProperty("priority_id")]
        public string PriorityId { get; set; }

        [JsonProperty("user_create_name")]
        public string UserCreateName { get; set; }

		[JsonProperty("user_create_id")]
		public decimal? UserCreateId { get; set; }

		[JsonProperty("modified_name")]
        public string ModifiedName { get; set; }

        [JsonProperty("send_group_id")]
        public decimal? SendGroupId { get; set; }

        [JsonProperty("plaintiff")]
        public string Plaintiff { get; set; }

        [JsonProperty("defendant")]
        public string Defendant { get; set; }

        [JsonProperty("regal_relation")]
        public string regalRelation { get; set; }

        [JsonProperty("criminal_id")]
        public decimal? criminalId { get; set; }

        [JsonProperty("transfer_dept_id")]
        public decimal? transferDeptId { get; set; }

        [JsonProperty("document_receive_id")]
        public decimal? documentReceiveId { get; set; }
        [JsonProperty("qla_send_date")]
        public DateTime? qlaSendDate { get; set; }

    }
}