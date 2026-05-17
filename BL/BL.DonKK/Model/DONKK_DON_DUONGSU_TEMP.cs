using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.DonKK.Model
{
    public class DONKK_DON_DUONGSU_TEMP
    {
        public decimal ID { get; set; }
        public Nullable<decimal> DONKKID { get; set; }
        public string MADUONGSU { get; set; }
        public string TENDUONGSU { get; set; }
        public Nullable<decimal> ISDAIDIEN { get; set; }
        public string TUCACHTOTUNG_MA { get; set; }
        public Nullable<decimal> LOAIDUONGSU { get; set; }
        public string SOCMND { get; set; }
        public Nullable<decimal> QUOCTICHID { get; set; }
        public Nullable<decimal> TAMTRUID { get; set; }
        public string TAMTRUCHITIET { get; set; }
        public Nullable<decimal> HKTTID { get; set; }
        public string HKTTCHITIET { get; set; }
        public Nullable<System.DateTime> NGAYSINH { get; set; }
        public Nullable<decimal> THANGSINH { get; set; }
        public Nullable<decimal> NAMSINH { get; set; }
        public Nullable<decimal> GIOITINH { get; set; }
        public string NGUOIDAIDIEN { get; set; }
        public string CHUCVU { get; set; }
        public string NGUOITAO { get; set; }
        public Nullable<System.DateTime> NGAYTAO { get; set; }
        public string NGUOISUA { get; set; }
        public Nullable<System.DateTime> NGAYSUA { get; set; }
        public Nullable<decimal> NDD_DIACHIID { get; set; }
        public string NDD_DIACHICHITIET { get; set; }
        public Nullable<decimal> ISDON { get; set; }
        public string EMAIL { get; set; }
        public string DIENTHOAI { get; set; }
        public string FAX { get; set; }
        public Nullable<decimal> SINHSONG_NUOCNGOAI { get; set; }
        public Nullable<decimal> HKTTTINHID { get; set; }
        public Nullable<decimal> TAMTRUTINHID { get; set; }
        public string TUCACHTOTUNG { get; set; }
        public string MALOAIVUVIEC { get; set; }
        public Nullable<decimal> DUONGSUID { get; set; }
        public Nullable<decimal> STOPVB { get; set; }
        public Nullable<decimal> NGUOITAOID { get; set; }
        public string DIACHICOQUAN { get; set; }


        //data Thêm 
        public string VALIDATENAMSINH { get; set; }
        public string CHECKCMND { get; set; }
        public string TIEUDE { get; set; }
        public string QUOCTICHNAME { get; set; }
        public string ID_TEMP { get; set; }
        //data grid


    }
}