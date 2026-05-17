using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models
{
    public class DM_CanBo
    {
        public long Id { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }
        public string Gender { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string IdNumber { get; set; }
        public long PosId { get; set; }
        public string PosName { get; set; }
        public long RoleId { get; set; }
        public string RoleName { get; set; }
        public long DeptId { get; set; }
        public string DeptName { get; set; }
        public long ParentDeptId { get; set; }
        public long Status { get; set; }
    }
}