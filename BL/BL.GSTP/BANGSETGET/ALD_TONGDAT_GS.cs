using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class ALD_TONGDAT_GS
    {
        private decimal _ID;
        private decimal? _DONID;
        private decimal? _BIEUMAUID;
        private decimal _TOAANID;         
        private decimal? _IS_TD_VKS;
        private DateTime? _IS_TD_VKS_NGAY;
        private DateTime? _NGAYTAO;
        private string _NGUOITAO;
        private DateTime? _NGAYSUA;
        private string _NGUOISUA;
        private string _TENFILE;
        private string _KIEUFILE;
        private string _NOIDUNGFILE;
        private decimal? _FILEID;
        private DateTime? _NGAYDANG_CTTDT;
        private DateTime? _NGAYNHANTONGDAT;
        private decimal? _TRANGTHAI;
        private DateTime? _NGAYTHUHOI;
        private string _LYDOTHUHOI;
        private string _URL_FILE;
        private decimal? _MAPID;
        private string _MAP_TABLE;
        private decimal? _TOA_GIAIQUYET_ID;
        public bool isShow { get; set; } 
        public ALD_TONGDAT_GS()
        {
            isShow = false; 
        }
        public ALD_TONGDAT_GS(decimal ID,
             decimal? DONID,
             decimal? BIEUMAUID,
             decimal TOAANID,
             decimal? IS_TD_VKS,
             DateTime? IS_TD_VKS_NGAY,
             DateTime? NGAYTAO,
             string NGUOITAO,
             DateTime? NGAYSUA,
             string NGUOISUA,
             string TENFILE,
             string KIEUFILE,
             string NOIDUNGFILE,
             decimal? FILEID,
             DateTime? NGAYDANG_CTTDT,
             DateTime? NGAYNHANTONGDAT,
             decimal? TRANGTHAI,
             DateTime? NGAYTHUHOI,
             string LYDOTHUHOI,
             string URL_FILE,
             decimal? MAPID,
             string MAP_TABLE,
             decimal? TOA_GIAIQUYET_ID)
        {
            this.ID = ID;
            this.DONID = DONID;
            this.BIEUMAUID = BIEUMAUID;
            this.TOAANID = TOAANID;
            this.IS_TD_VKS = IS_TD_VKS;
            this.IS_TD_VKS_NGAY = IS_TD_VKS_NGAY;
            this.NGAYTAO = NGAYTAO;
            this.NGUOITAO = NGUOITAO;
            this.NGAYSUA = NGAYSUA;
            this.NGUOISUA = NGUOISUA;
            this.TENFILE = TENFILE;
            this.KIEUFILE = KIEUFILE;
            this.NOIDUNGFILE = NOIDUNGFILE;
            this.FILEID = FILEID;
            this.NGAYDANG_CTTDT = NGAYDANG_CTTDT;
            this.NGAYNHANTONGDAT = NGAYNHANTONGDAT;
            this.TRANGTHAI = TRANGTHAI;
            this._NGAYTHUHOI = NGAYTHUHOI;
            this.LYDOTHUHOI = LYDOTHUHOI;
            this.URL_FILE = URL_FILE;
            this.MAPID = MAPID;
            this.MAP_TABLE = MAP_TABLE;
            this._TOA_GIAIQUYET_ID = TOA_GIAIQUYET_ID;
        }

        public decimal ID
        {
            get
            {
                return _ID;
            }
            set
            {
                _ID = value;
            }
        }
        public decimal? DONID
        {
            get
            {
                return _DONID;
            }
            set
            {
                _DONID = value;
            }
        }
        public decimal? BIEUMAUID
        {
            get
            {
                return _BIEUMAUID;
            }
            set
            {
                _BIEUMAUID = value;
            }
        }
        public decimal TOAANID
        {
            get { return _TOAANID; }
            set { _TOAANID = value; }
        }
        public decimal? IS_TD_VKS
        {
            get { return _IS_TD_VKS; }
            set { _IS_TD_VKS = value; }
        }
        public DateTime? IS_TD_VKS_NGAY
        {
            get { return _IS_TD_VKS_NGAY; }
            set { _IS_TD_VKS_NGAY = value; }
        }
        public DateTime? NGAYTAO
        {
            get { return _NGAYTAO; }
            set { _NGAYTAO = value; }
        }
        public string NGUOITAO
        {
            get { return _NGUOITAO; }
            set { _NGUOITAO = value; }
        }
        public DateTime? NGAYSUA
        {
            get { return _NGAYSUA; }
            set { _NGAYSUA = value; }
        }
        public string NGUOISUA
        {
            get { return _NGUOISUA; }
            set { _NGUOISUA = value; }
        }
        public string TENFILE
        {
            get { return _TENFILE; }
            set { _TENFILE = value; }
        }
        public string KIEUFILE
        {
            get { return _KIEUFILE; }
            set { _KIEUFILE = value; }
        }
        public string NOIDUNGFILE
        {
            get { return _NOIDUNGFILE; }
            set { _NOIDUNGFILE = value; }
        }
        public decimal? FILEID
        {
            get { return _FILEID; }
            set { _FILEID = value; }
        }
        public DateTime? NGAYDANG_CTTDT
        {
            get { return _NGAYDANG_CTTDT; }
            set { _NGAYDANG_CTTDT = value; }
        }
        public DateTime? NGAYNHANTONGDAT
        {
            get { return _NGAYNHANTONGDAT; }
            set { _NGAYNHANTONGDAT = value; }
        }
        public decimal? TRANGTHAI
        {
            get { return _TRANGTHAI; }
            set { _TRANGTHAI = value; }
        }
        public DateTime? NGAYTHUHOI
        {
            get { return _NGAYTHUHOI; }
            set { _NGAYTHUHOI = value; }
        }
        public string LYDOTHUHOI
        {
            get { return _LYDOTHUHOI; }
            set { _LYDOTHUHOI = value; }
        }
        public string URL_FILE
        {
            get { return _URL_FILE; }
            set { _URL_FILE = value; }
        }
        public decimal? MAPID
        {
            get { return _MAPID; }
            set { _MAPID = value; }
        }
        public string MAP_TABLE
        {
            get { return _MAP_TABLE; }
            set { _MAP_TABLE = value; }
        }
        public decimal? TOA_GIAIQUYET_ID
        {
            get { return _TOA_GIAIQUYET_ID; }
            set { _TOA_GIAIQUYET_ID = value; }
        }


    }
}