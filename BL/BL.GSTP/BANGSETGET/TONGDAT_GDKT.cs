using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class TONGDAT_GDKT
    {
        private decimal _ID;
        private decimal _VUAN_ID;
        private decimal? _GIAIDOAN;
        private string _ID_HS_TLDON;
        private string _LOAIVB;
        private decimal? _LOAIANID;
        private string _TENVANBAN;
        private string _SOVB;
        private DateTime? _NGAYVB;
        private string _NGUOIKY;
        private decimal? _DONVIPHATHANH_ID;
        private string _DONVIPHATHANH;
        private decimal? _TOAANID;
        private DateTime? _NGAYTHUHOI;
        private string _LYDOTHUHOI;
        private DateTime? _NGAYTAO;
        private string _NGUOITAO;
        private DateTime? _NGAYSUA;
        private string _NGUOISUA;

        public TONGDAT_GDKT()
        {

        }
        public TONGDAT_GDKT(decimal ID, decimal VUAN_ID, decimal GIAIDOAN, string ID_HS_TLDON, string LOAIVB, decimal LOAIANID, string TENVANBAN, string SOVB, DateTime NGAYVB,
            string NGUOIKY, decimal DONVIPHATHANH_ID, string DONVIPHATHANH, decimal TOAANID, DateTime NGAYTHUHOI, string LYDOTHUHOI, DateTime NGAYTAO, string NGUOITAO, DateTime NGAYSUA, string NGUOISUA)
        {
            this.ID = ID;
            this.VUAN_ID = VUAN_ID;
            this.GIAIDOAN = GIAIDOAN;
            this.ID_HS_TLDON = ID_HS_TLDON;
            this.LOAIVB = LOAIVB;
            this.LOAIANID = LOAIANID;
            this.TENVANBAN = TENVANBAN;
            this.SOVB = SOVB;
            this.NGAYVB = NGAYVB;
            this.NGUOIKY = NGUOIKY;
            this.DONVIPHATHANH_ID = DONVIPHATHANH_ID;
            this.DONVIPHATHANH = DONVIPHATHANH;
            this.TOAANID = TOAANID;
            this.NGAYTHUHOI = NGAYTHUHOI;
            this.LYDOTHUHOI = LYDOTHUHOI;
            this.NGAYTAO = NGAYTAO;
            this.NGUOITAO = NGUOITAO;
            this.NGAYSUA = NGAYSUA;
            this.NGUOISUA = NGUOISUA;
        }

        public Decimal ID
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
        public Decimal VUAN_ID
        {
            get
            {
                return _VUAN_ID;
            }
            set
            {
                _VUAN_ID = value;
            }
        }
        public Decimal? GIAIDOAN
        {
            get
            {
                return _GIAIDOAN;
            }
            set
            {
                _GIAIDOAN = value;
            }
        }
        public string ID_HS_TLDON
        {
            get
            {
                return _ID_HS_TLDON;
            }
            set
            {
                _ID_HS_TLDON = value;
            }
        }
        public String LOAIVB
        {
            get
            {
                return _LOAIVB;
            }
            set
            {
                _LOAIVB = value;
            }
        }
        public Decimal? LOAIANID
        {
            get
            {
                return _LOAIANID;
            }
            set
            {
                _LOAIANID = value;
            }
        }
        public String TENVANBAN
        {
            get
            {
                return _TENVANBAN;
            }
            set
            {
                _TENVANBAN = value;
            }
        }
        public String SOVB
        {
            get
            {
                return _SOVB;
            }
            set
            {
                _SOVB = value;
            }
        }
        public DateTime? NGAYVB
        {
            get
            {
                return _NGAYVB;
            }
            set
            {
                _NGAYVB = value;
            }
        }
        public string NGUOIKY
        {
            get
            {
                return _NGUOIKY;
            }
            set
            {
                _NGUOIKY = value;
            }
        }
        public Decimal? DONVIPHATHANH_ID
        {
            get
            {
                return _DONVIPHATHANH_ID;
            }
            set
            {
                _DONVIPHATHANH_ID = value;
            }
        }
        public Decimal? TOAANID
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
        public string DONVIPHATHANH
        {
            get
            {
                return _DONVIPHATHANH;
            }
            set
            {
                _DONVIPHATHANH = value;
            }
        }
        public string LYDOTHUHOI
        {
            get
            {
                return _LYDOTHUHOI;
            }
            set
            {
                _LYDOTHUHOI = value;
            }
        }
        public DateTime? NGAYTHUHOI
        {
            get
            {
                return _NGAYTHUHOI;
            }
            set
            {
                _NGAYTHUHOI = value;
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
        public DateTime? NGAYSUA
        {
            get
            {
                return _NGAYSUA;
            }
            set
            {
                _NGAYSUA = value;
            }
        }
        public string NGUOISUA
        {
            get
            {
                return _NGUOISUA;
            }
            set
            {
                _NGUOISUA = value;
            }
        }
    }
}