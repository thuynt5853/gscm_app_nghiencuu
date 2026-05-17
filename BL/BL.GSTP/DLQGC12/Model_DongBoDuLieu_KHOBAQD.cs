using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.DLQGC12
{
    public class Model_DongBoDuLieu_KHOBAQD
    {
        public decimal DONID { get; set; }
        public string LINHVUC { get; set; }
        public decimal CAPXX { get; set; }
        public decimal? LOAIBAQD { get; set; }
        public decimal? IDBAQD { get; set; }
        public decimal? QUANHEPHAPLUATID { get; set; }
        public string SOBAQD { get; set; }
        public DateTime? NGAYBAQD { get; set; }
        public DateTime? NGAYHIEULUCBAQD { get; set; }
        public string MACQ { get; set; }
        public string COQUANQD { get; set; }
        public string TAIKHOANTAO { get; set; }
        public string MAVANBAN { get; set; }
        public decimal? TOAANID { get; set; }
        public string DSBAQDLIENQUAN { get; set; }
        public List<KHOBAQD_DUONGSU> DUONGSU { get; set; } //danh sách đương sự của BAQD
        public string SOTHULY { get; set; }
        public string THAMPHAN { get; set; }
        public string LOAIQDHN { get; set; }
        public int TRANGTHAIBAQD { get; set; }
    }
}