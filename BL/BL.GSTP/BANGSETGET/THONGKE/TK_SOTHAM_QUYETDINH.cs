//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web;

//namespace BL.GSTP.BANGSETGET.THONGKE
//{
//    public class TK_SOTHAM_QUYETDINH
//    {
//        public decimal ID { get; set; }
//        public Nullable<decimal> QUYETDINHID { get; set; }
//        public Nullable<decimal> DONID { get; set; }
//        public Nullable<decimal> LOAIAN { get; set; }
//        public Nullable<decimal> YEUTONUOCNGOAI { get; set; }
//        public Nullable<decimal> APDUNGANLE { get; set; }
//        public Nullable<decimal> ISVKSTHAMGIA { get; set; }
//        public Nullable<decimal> ISHOAGIAITHANH { get; set; }
//        public Nullable<decimal> TK_SOTIEN { get; set; }
//        public Nullable<decimal> TK_BACYEUCAUKK { get; set; }
//        public Nullable<decimal> TK_CHAPNHAN1PHAN { get; set; }
//        public Nullable<decimal> TK_CHAPNHANTOANBO { get; set; }
//        public Nullable<decimal> TK_ISDOITHOAI { get; set; }
//        public Nullable<decimal> TK_ISBOITHUONG { get; set; }
//        public Nullable<decimal> TK_ISKIENCOQUANNN { get; set; }
//        public Nullable<decimal> TK_SOQDTRAIPLBIHUY { get; set; }
//        public Nullable<decimal> SOCONDUOI7TUOI { get; set; }
//        public Nullable<decimal> SOCONDUOI18LANU { get; set; }
//        public Nullable<decimal> TONGSOCONDUOI18TUOI { get; set; }
//        public Nullable<decimal> TK_ISKHONGCHAPNHAN { get; set; }
//        public Nullable<decimal> TK_ISCHAPNHANDON { get; set; }
//        public Nullable<decimal> TK_ISKHONGCONGNHANVC { get; set; }
//        public Nullable<decimal> TK_CHOLYHON { get; set; }
//        public Nullable<decimal> TK_ISCHAPNHAN_KQKHAC { get; set; }
//        public Nullable<decimal> TK_ISCHAPNHAN { get; set; }

//        public Nullable<System.DateTime> NGAYTAO { get; set; }
//        public Nullable<System.DateTime> NGAYSUA { get; set; }
//        public string NGUOITAO { get; set; }
//        public string NGUOISUA { get; set; }

//    }
//}

using System;

namespace BL.GSTP.BANGSETGET.THONGKE
{
    public class TK_SOTHAM_QUYETDINH
    {
        public decimal ID { get; set; }
        public decimal? LOAIAN { get; set; }
        public decimal? QUYETDINHID { get; set; }
        public decimal? YEUTONUOCNGOAI { get; set; }
        public decimal? APDUNGANLE { get; set; }
        public decimal? TK_ISVKSCOKN_KDCN { get; set; }
        public decimal? TK_ISVKSRUTKN_DSKR { get; set; }
        public decimal? ISVKSTHAMGIA { get; set; }
        public decimal? ISHOAGIAITHANH { get; set; }
        public decimal? TK_SOTIEN { get; set; }
        public decimal? TK_BACYEUCAUKK { get; set; }
        public decimal? TK_CHAPNHAN1PHAN { get; set; }
        public decimal? TK_CHAPNHANTOANBO { get; set; }
        public decimal? TK_ISDOITHOAI { get; set; }
        public decimal? TK_ISBOITHUONG { get; set; }
        public decimal? TK_ISKIENCOQUANNN { get; set; }
        public decimal? TK_SOQDTRAIPLBIHUY { get; set; }
        public decimal? SOCONDUOI7TUOI { get; set; }
        public decimal? SOCONDUOI18LANU { get; set; }
        public decimal? TONGSOCONDUOI18TUOI { get; set; }
        public decimal? TK_ISKHONGCHAPNHAN { get; set; }
        public decimal? TK_ISCHAPNHANDON { get; set; }
        public decimal? TK_ISKHONGCONGNHANVC { get; set; }
        public decimal? TK_CHOLYHON { get; set; }
        public decimal? TK_ISCHAPNHAN { get; set; }
        public DateTime? NGAYTAO { get; set; }
        public DateTime? NGAYSUA { get; set; }
        public string NGUOITAO { get; set; }
        public string NGUOISUA { get; set; }
        public decimal? DONID { get; set; }
        public decimal? TK_ISCHAPNHAN_KQKHAC { get; set; }
        public string SOANLE { get; set; }
        public decimal? TK_ISKHONGCHAPNHAN_KQKHAC { get; set; }
    }
}
