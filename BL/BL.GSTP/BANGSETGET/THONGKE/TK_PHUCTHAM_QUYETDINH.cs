using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET.THONGKE
{
    public class TK_PHUCTHAM_QUYETDINH
    {
        public decimal ID { get; set; }
        public Nullable<decimal> QUYETDINHID { get; set; }
        public Nullable<decimal> LOAIAN { get; set; }
        public Nullable<decimal> YEUTONUOCNGOAI { get; set; }
        public Nullable<decimal> APDUNGANLE { get; set; }
        public Nullable<decimal> ISVKSTHAMGIA { get; set; }
        public Nullable<decimal> ISHOAGIAITHANH { get; set; }
        public Nullable<decimal> TK_ISVKSRUTKN_DSKR { get; set; }
        public Nullable<decimal> TK_ISVKSCOKN_KDCN { get; set; }
        public Nullable<decimal> TK_KETQUA_CHITIET { get; set; }
        
        public Nullable<decimal> ISTHAMPHAN_HD { get; set; }
        public Nullable<decimal> DONID { get; set; }
        public Nullable<System.DateTime> NGAYTAO { get; set; }
        public Nullable<System.DateTime> NGAYSUA { get; set; }
        public string NGUOITAO { get; set; }
        public string NGUOISUA { get; set; }
        public string SOANLE { get; set; }
    }
}