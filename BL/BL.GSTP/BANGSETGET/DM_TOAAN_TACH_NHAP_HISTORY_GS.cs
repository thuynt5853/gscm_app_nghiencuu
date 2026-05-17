using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class DM_TOAAN_TACH_NHAP_HISTORY_GS
    {
        public decimal _ID;
        public decimal _TOAANID;
        public decimal? _TOTOAANID;
        public decimal? _HIEULUC;
        public DateTime? _NGAYHIEULUC;
        public DateTime? _NGAYHETHIEULUC;
        public string _LOAI;
        private DateTime? _NGAYTAO;
        private string _NGUOITAO;
        private string _HANHDONG;

        public DM_TOAAN_TACH_NHAP_HISTORY_GS() { }

        public DM_TOAAN_TACH_NHAP_HISTORY_GS(decimal ID,
             decimal TOAANID,
             decimal? TOTOAANID,
             decimal? HIEULUC,
             DateTime? NGAYHIEULUC,
             DateTime? NGAYHETHIEULUC,
             string LOAI,
             DateTime? NGAYTAO,
             string NGUOITAO,
             string HANHDONG)
        {
            this.ID = ID;
            this.TOAANID = TOAANID;
            this.TOTOAANID = TOTOAANID;
            this.HIEULUC = HIEULUC;
            this.NGAYHIEULUC = NGAYHIEULUC;
            this.NGAYHETHIEULUC = NGAYHETHIEULUC;
            this.LOAI = LOAI;
            this.NGAYTAO = NGAYTAO;
            this.NGUOITAO = NGUOITAO;
            this.HANHDONG = HANHDONG;
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
        public decimal? HIEULUC
        {
            get
            {
                return _HIEULUC;
            }
            set
            {
                _HIEULUC = value;
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
        public DateTime? NGAYHETHIEULUC
        {
            get
            {
                return _NGAYHETHIEULUC;
            }
            set
            {
                _NGAYHETHIEULUC = value;
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
        public string HANHDONG
        {
            get
            {
                return _HANHDONG;
            }
            set
            {
                _HANHDONG = value;
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