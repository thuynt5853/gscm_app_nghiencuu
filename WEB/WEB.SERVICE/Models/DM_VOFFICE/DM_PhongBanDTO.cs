using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models.DM_VOFFICE
{
    public class DM_PhongBanDTO : ICloneable
    {

        [JsonProperty("Id")]
        public decimal id { get; set; }

        [JsonProperty("DeptCode")]
        public string deptCode { get; set; }

        [JsonProperty("DeptName")]
        public string deptName { get; set; }

        [JsonProperty("IdentifyCode")]
        public string identifyCode { get; set; }

        [JsonProperty("Address")]
        public string address { get; set; }

        [JsonProperty("Telephone")]
        public string telephone { get; set; }

        [JsonProperty("Fax")]
        public string fax { get; set; }

        [JsonProperty("ParentId")]
        public decimal? parentId { get; set; }

        [JsonProperty("DeptType")]
        public string deptType { get; set; }

        [JsonProperty("IsActive")]
        public decimal? isActive { get; set; }

        [JsonProperty("Children")]
        public List<DM_PhongBanDTO> children;


        [JsonProperty("Type")]
        public string type { get; set; }

        public object Clone()
        {
            DM_PhongBanDTO clone = new DM_PhongBanDTO();
            clone.id = id;
            clone.deptCode = deptCode;
            clone.deptName = deptName;
            clone.identifyCode = identifyCode;
            clone.address = address;
            clone.telephone = telephone;
            clone.fax = fax;
            clone.parentId = parentId;
            clone.deptType = deptType;
            clone.isActive = isActive;
            clone.type = type;
            List<DM_PhongBanDTO> newList = new List<DM_PhongBanDTO>();
            children?.ForEach((child) => newList.Add((DM_PhongBanDTO) child.Clone()));
            clone.children = newList;
            return clone;
        }
    }
}