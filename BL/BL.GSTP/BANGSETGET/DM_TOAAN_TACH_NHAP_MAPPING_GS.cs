using System;

namespace BL.GSTP.BANGSETGET
{
    public class DM_TOAAN_TACH_NHAP_MAPPING_GS
    {
        public decimal _ID;
        public string _LOAI;
        public decimal _TOAANID;
        public decimal? _TOTOAANID;
        public DateTime? _NGAYHIEULUC;
        public string _GHICHU;
        private DateTime? _NGAYTAO;
        private string _NGUOITAO;

        public DM_TOAAN_TACH_NHAP_MAPPING_GS() { }

        public DM_TOAAN_TACH_NHAP_MAPPING_GS(decimal ID,
             decimal TOAANID,
             string LOAI,
             decimal? TOTOAANID,
             DateTime? NGAYHIEULUC,
             string GHICHU,
             DateTime? NGAYTAO,
             string NGUOITAO)
        {
            this.ID = ID;
            this.LOAI = LOAI;
            this.TOAANID = TOAANID;
            this.TOTOAANID = TOTOAANID;
            this.NGAYHIEULUC = NGAYHIEULUC;
            this.GHICHU = GHICHU;
            this.NGAYTAO = NGAYTAO;
            this.NGUOITAO = NGUOITAO;
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
        public string LOAI
        {
            get
            {
                return _LOAI;
            }
            set
            {
                _LOAI = value;
            }
        }
        public decimal TOAANID
        {
            get
            {
                return _TOAANID;
            }
            set
            {
                _TOAANID = value;
            }
        }
        public decimal? TOTOAANID
        {
            get
            {
                return _TOTOAANID;
            }
            set
            {
                _TOTOAANID = value;
            }
        }

        public DateTime? NGAYHIEULUC
        {
            get
            {
                return _NGAYHIEULUC;
            }
            set
            {
                _NGAYHIEULUC = value;
            }
        }

        public string GHICHU
        {
            get
            {
                return _GHICHU;
            }
            set
            {
                _GHICHU = value;
            }
        }

        public string NGUOITAO
        {
            get
            {
                return _NGUOITAO;
            }
            set
            {
                _NGUOITAO = value;
            }
        }
        public DateTime? NGAYTAO
        {
            get
            {
                return _NGAYTAO;
            }
            set
            {
                _NGAYTAO = value;
            }
        }
    }
}