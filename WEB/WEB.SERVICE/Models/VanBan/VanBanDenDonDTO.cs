using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WEB.Service.Models.VanBan
{
    public class VanBanDenDonDTO
    {

        // thong tin bi thu
        [JsonProperty("document_receive_id")]
        public long? documentReceiveId { get; set; }

        [JsonProperty("receive_type_name")]
        public string receiveTypeName { get; set; }

        [JsonProperty("receive_dept_id")]
        public long? receiveDeptId { get; set; }

        [JsonProperty("receive_user_id")]
        public long? receiveUserId { get; set; }

        [JsonProperty("document_type_id")]
        public decimal documentTypeId { get; set; }

        [JsonProperty("book_number")]
        public long? bookNumber { get; set; }

        [JsonProperty("create_time")]
        public DateTime? createTime { get; set; }

        [JsonProperty("send_date")]
        public DateTime? sendDate { get; set; }

        [JsonProperty("zip_code")]
        public string zipCode { get; set; }

        [JsonProperty("date_post_mark")]
        public DateTime? datePostMark { get; set; }

        [JsonProperty("weight")]
        public string weight { get; set; }

        [JsonProperty("publish_agency_name")]
        public string publishAgencyName { get; set; }

        [JsonProperty("province_letters_id")]
        public long? provinceLettersId { get; set; }

        [JsonProperty("district_letters_id")]
        public long? districtLettersId { get; set; }

        [JsonProperty("details_letters")]
        public string detailsLetters { get; set; }

        [JsonProperty("book_name")]
        public string bookName { get; set; }

        [JsonProperty("note")]
        public string note { get; set; }

        [JsonProperty("court_id")]
        public long? courtId { get; set; }

        // thong tin nguoi khoi kien

        [JsonProperty("petitioner_type")]
        public long? petitionerType { get; set; }

        [JsonProperty("petitioner_id")]
        public long? petitionerId { get; set; }

        [JsonProperty("parties_name")]
        public string partiesName { get; set; }

        [JsonProperty("id_number")]
        public string idNumber { get; set; }

        [JsonProperty("birthday")]
        public Nullable<decimal> birthday { get; set; }

        [JsonProperty("gender")]
        public long? gender { get; set; }

        [JsonProperty("number_of_petitions")]
        public long? numberOfPetitions { get; set; }

        [JsonProperty("tabernacle_province_id")]
        public long? tabernacleProvinceId { get; set; }

        [JsonProperty("residence_id")]
        public long? residenceId { get; set; }

        [JsonProperty("residence")]
        public string residence { get; set; }

        [JsonProperty("email")]
        public string email { get; set; }

        [JsonProperty("telephone")]
        public string telephone { get; set; }

        [JsonProperty("type_of_sentence")]
        public long? typeOfSentence { get; set; }

        [JsonProperty("content_lawsuit")]
        public string contentLawsuit { get; set; }

        [JsonProperty("tax_code")]
        public string taxCode { get; set; }

        [JsonProperty("representative")]
        public string representative { get; set; }

        [JsonProperty("position")]
        public string position { get; set; }

        // Thong tin nguoi bi kien

        [JsonProperty("petitioner_type_accused")]
        public long? petitionerTypeAccused { get; set; }

        [JsonProperty("sued_id")]
        public long? suedId { get; set; }

        [JsonProperty("parties_name_accused")]
        public string partiesNameAccused { get; set; }

        [JsonProperty("id_number_accused")]
        public string idNumberAccused { get; set; }

        [JsonProperty("birthday_accused")]
        public Nullable<decimal> birthdayAccused { get; set; }

        [JsonProperty("gender_accused")]
        public long? genderAccused { get; set; }

        [JsonProperty("tabernacle_province_id_accused")]
        public long? tabernacleProvinceIdAccused { get; set; }

        [JsonProperty("residence_id_accused")]
        public long? residenceIdAccused { get; set; }

        [JsonProperty("residence_accused")]
        public string residenceAccused { get; set; }

        [JsonProperty("tax_code_accused")]
        public string taxCodeAccused { get; set; }

        [JsonProperty("representative_accused")]
        public string representativeAccused { get; set; }

        [JsonProperty("position_accused")]
        public string positionAccused { get; set; }

        // thong tin gui nhan
        [JsonProperty("receive_group_id")]
        public long? receiveGroupId { get; set; }

        [JsonProperty("receiveGroup")]
        public string receiveGroup { get; set; }

        [JsonProperty("sendGroupId")]
        public long? sendGroupId { get; set; }

        [JsonProperty("sendGroup")]
        public string sendGroup { get; set; }

        [JsonProperty("send_user")]
        public string sendUser { get; set; }

        [JsonProperty("send_user_id")]
        public long? sendUserId { get; set; }

        // thong tin ban an/quyet dinh

        [JsonProperty("baqd")]
        public long? baqd { get; set; }

        [JsonProperty("baqd_number")]
        public string baqdNumber { get; set; }

        [JsonProperty("baqd_date")]
        public DateTime? baqdDate { get; set; }

        [JsonProperty("court_baqd_id")]
        public long? courBaqdId { get; set; }

        [JsonProperty("court_baqd_name")]
        public string courtBaqdName { get; set; }

        [JsonProperty("trial_level")]
        public long? trialLevel { get; set; }

        [JsonProperty("case_name")]
        public string caseName { get; set; }

        [JsonProperty("proceedings_id")]
        public string proceedingsId { get; set; }

        [JsonProperty("accused")]
        public string accused { get; set; }

        [JsonProperty("defendant")]
        public string defendant { get; set; }

        [JsonProperty("criminal_id")]
        public long? criminalId { get; set; }

        [JsonProperty("regal_relations")]
        public string regalRalations { get; set; }

    }
}