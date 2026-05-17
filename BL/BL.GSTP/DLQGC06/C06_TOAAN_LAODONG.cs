using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.DLQGC06
{
    /* GTEL-HUNGNQ 01-10-2025 Đồng bộ C06 cho án Lao Động */
    public class C06_TOAAN_LAODONG
    {
        public Nullable<decimal> ID { get; set; }
        public string SOBANANORQD { get; set; }
        public string NGAYRABANAN { get; set; }
        public string MADONVIRABANAN { get; set; }
        public string TENDONVIRABANAN { get; set; }
        public string BQD { get; set; }
        public Nullable<decimal> ANPHI { get; set; }
        public string NGAYHIEULUCBA { get; set; }
        public string HOTENDUONGSU { get; set; }
        public string SOGIAYTODUONGSU { get; set; }
        public string NGAYSINHDUONGSU { get; set; }
        public string MAQUOCTICHDUONGSU { get; set; }
        public string TENQUOCTICHDUONGSU { get; set; }
        public string MATHANHPHOTINHDUONGSU { get; set; }
        public string TENTHANHPHOTINHDUONGSU { get; set; }
        public string MAQUANHUYENDUONGSU { get; set; }
        public string TENQUANHUYENDUONGSU { get; set; }
        public string MAPHUONGXADUONGSU { get; set; }
        public string TENPHUONGXADUONGSU { get; set; }
        public string DIACHIDUONGSU { get; set; }
        public string TRANGTHAIALD { get; set; }
        public string TRANGTHAIJOBSHARE { get; set; }
        public Nullable<decimal> VUANID { get; set; }
        public Nullable<decimal> DUONGSUID { get; set; }
        public Nullable<DateTime> NGAYGUI { get; set; }
        public string TAIKHOANGUI { get; set; }
        public Nullable<DateTime> NGAYDONGBO { get; set; }
        public string TENVUAN { get; set; }
        public string THULY { get; set; }
        public string STATUS { get; set; }
        public string GHICHU { get; set; }
        public string MAQUANHEPHAPLUAT { get; set; }
        public string TENQUANHEPHAPLUAT { get; set; }
        public string MATUCACHTOTUNG { get; set; }
        public string TENTUCACHTOTUNG { get; set; }
        public string CAPXX { get; set; }
        public string LOAIBAQD { get; set; }
        public string NGUOIGUILAI { get; set; }
        public DateTime? NGAYGUILAI { get; set; }
        public string NGUOITHUHOI { get; set; }
        public DateTime? NGAYTHUHOI { get; set; }
    }
}