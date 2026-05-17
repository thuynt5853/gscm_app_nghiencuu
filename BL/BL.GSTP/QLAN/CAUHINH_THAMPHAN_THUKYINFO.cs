using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.QLAN
{
    public class CAUHINH_THAMPHAN_THUKYINFO
    {
        public decimal ID { get; set; }
        public Nullable<decimal> THAMPHAMID { get; set; }
        public Nullable<decimal> THUKYID { get; set; }
        public Nullable<decimal> DONVIID { get; set; }
        public Nullable<System.DateTime> NGAYTAO { get; set; }
        public string NGUOITAO { get; set; }
        public Nullable<System.DateTime> NGAYSUA { get; set; }
        public string NGUOISUA { get; set; }
        public string THAMPHAN { get; set; }
        public string THUKY { get; set; }
    }
}