using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.DLQGC06
{
    public class C06_TOAAN_HINHSU_MODEL
    {
        public string SOBANANORQD { get; set; }
        public string NGAYRABANAN { get; set; }
        public string MADONVIRABANAN { get; set; }
        public string TENDONVIRABANAN { get; set; }
        public string BQD { get; set; }
        public string DSTOIDANH { get; set; }
        public string MAHINHPHATCHINH { get; set; }
        public string TENHINHPHATCHINH { get; set; }
        public string THAMSOHINHPHATCHINH { get; set; }
        public string DSHINHPHATBOSUNG { get; set; }
        public string NGAYHIEULUCBA { get; set; }
        public string HOTENBICAO { get; set; }
        public string SOGIAYTOBICAO { get; set; }
        public string NGAYSINHBICAO { get; set; }
        public string MAQUOCTICHBICAO { get; set; }
        public string TENQUOCTICHBICAO { get; set; }
        public string MATHANHPHOTINHBICAO { get; set; }
        public string TENTHANHPHOTINHBICAO { get; set; }
        public string MAQUANHUYENBICAO { get; set; }
        public string TENQUANHUYENBICAO { get; set; }
        public string MAPHUONGXABICAO { get; set; }
        public string TENPHUONGXABICAO { get; set; }
        public string DIACHIBICAO { get; set; }
        public string GHICHU { get; set; }
        public decimal VUANID { get; set; }
        public decimal BICANID { get; set; }
        public string TAIKHOANGUI { get; set; }
        public string TENVUAN { get; set; }
        public string THULY { get; set; }
        public string MADONGBOID { get; set; }
        public string CAPXX { get; set; }
        public string ToiDanhTH { get; set; }
        public string HinhPhatTh { get; set; }
        public string ThamPhan { get; set; }
        public string TRANGTHAIAHS { get; set; }
    }
    public class HinhPhatModel
    {
        public string maHinhPhat { get; set; }
        public string tenHinhPhat { get; set; }
        public string thamSoHinhPhat { get; set; }
        public int hinhPhatChinh { get; set; }
    }
    public class ToiDanhModel
    {
        public string maToiDanh { get; set; }
        public string tenToiDanh { get; set; }
        public List<HinhPhatModel> dSachHinhPhat { get; set; }
    }
    public class HinhPhatDisplayModel : HinhPhatModel
    {
        public string loaiHinhPhat { get; set; }
    }
}