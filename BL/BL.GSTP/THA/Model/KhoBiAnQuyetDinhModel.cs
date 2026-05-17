using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.THA.Model
{
    public class KhoBiAnQuyetDinhModel
    {
        public string SODINHDANH { get; set; }
        public string HOVATEN { get; set; }
        public DateTime? NGAYSINH { get; set; }
        public int? GIOITINH { get; set; }
        public string NOIDKKS { get; set; }
        public string NOIDKKSMATINH { get; set; }
        public string NOIDKKSTINH { get; set; }
        public string NOIDKKSMAXA { get; set; }
        public string NOIDKKSXA { get; set; }
        public string NOICUTRU { get; set; }
        public string NOICUTRUMATINH { get; set; }
        public string NOICUTRUTINH { get; set; }
        public string NOICUTRUMAXA { get; set; }
        public string NOICUTRUXA { get; set; }
        public string SOHOCHIEU { get; set; }
        public string HOTENCHA { get; set; }
        public string HOTENME { get; set; }
        public string HOTENVOCHONG { get; set; }

        public string SOBANAN { get; set; }
        public DateTime? NGAYBANAN { get; set; }
        public string MADONVIBANAN { get; set; }
        public string TENDONVIBANAN { get; set; }
        public string DANHSACHTOIDANH { get; set; }
        public string HINHPHATCHINH { get; set; }
        public string MAHINHPHATCHINH { get; set; }
        public string TENHINHPHATCHINH { get; set; }
        public string THAMSOHINHPHAT { get; set; }
        public string DANHSACHHINHPHATBS { get; set; }
        public string TINHTRANGTHA { get; set; }
        public DateTime? NGAYTHA { get; set; }
        public string MANOITHA { get; set; }
        public string TENNOITHA { get; set; }
        public string TRANGTHAITHA { get; set; }
        public decimal? BIANID { get; set; }
        public decimal? THABIANID { get; set; }

        //quyết định
        public decimal? KHOBIAN_QUYETDINHID { get; set; }
        public decimal? IDQD { get; set; }
        public int? LOAIQUYETDINH { get; set; }
        public string LOAIQUYETDINHTEN { get; set; }
        public string SOQDINH { get; set; }
        public DateTime? NGAYQDINH { get; set; }
        public string MADVI { get; set; }
        public string TENDVI { get; set; }
        public string TRICHYEUNOIDUNG { get; set; }

        public string TAIKHOANTAO { get; set; }
    }
}