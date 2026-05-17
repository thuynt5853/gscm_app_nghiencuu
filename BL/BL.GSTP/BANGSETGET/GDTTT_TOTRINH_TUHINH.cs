using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class GDTTT_TOTRINH_TUHINH
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _USER_ID;
        private Decimal _TUHINH_ID;

        
        // Thông tin tờ trình
        private String _SOTT;
        private DateTime _NGAYTT;
        private String _DX_TTV;
        private Decimal _CAPTRINH;
        private Decimal _LANHDAOID;
        private DateTime _NGAYTRINH;
        private DateTime _NGAYDUKIENBC;
        private DateTime _NGAYNHANTT;
        private DateTime _NGAYTRATT;

        private Decimal _LOAIYK;
        private String _NOIDUNGYKIEN;
        private Decimal _CAPTRINHTIEP;
        private Decimal _TRINHTIEP_LANHDAO_ID;
        private String _GHICHU;
        private Decimal _LANTRINH;
       
        #endregion

        #region Public properties

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
        public Decimal USER_ID
        {
            get
            {
                return _USER_ID;
            }
            set
            {
                _USER_ID = value;
            }
        }
        public Decimal TUHINH_ID
        {
            get
            {
                return _TUHINH_ID;
            }
            set
            {
                _TUHINH_ID = value;
            }

        }
        public String SOTT
        {
            get
            {
                return _SOTT;
            }
            set
            {
                _SOTT = value;
            }
        }
        public DateTime NGAYTT
        {
            get
            {
                return _NGAYTT;  
            }
            set
            {
                _NGAYTT = value;
            }
        } 
        public String DX_TTV
        {
            get
            {
                return _DX_TTV;
            }
            set
            {
                _DX_TTV = value;
            }
        }
        public Decimal CAPTRINH
        {
            get
            {
                return _CAPTRINH;
            }
            set
            {
                _CAPTRINH = value;
            }

        }
        public Decimal LANHDAOID
        {
            get
            {
                return _LANHDAOID;
            }
            set
            {
                _LANHDAOID = value;
            }
        }   
        public DateTime NGAYTRINH
        {
            get
            {
                return _NGAYTRINH;
            }
            set
            {
                _NGAYTRINH = value;
            }
        }
        public DateTime NGAYDUKIENBC
        {
            get
            {
                return _NGAYDUKIENBC;
            }
            set
            {
                _NGAYDUKIENBC = value;
            }
        }
        public DateTime NGAYNHANTT
        {
            get
            {
                return _NGAYNHANTT;
            }
            set
            {
                _NGAYNHANTT = value;
            }
        }
        public DateTime  NGAYTRATT
        {
            get
            {
                return _NGAYTRATT;
            }
            set
            {
                _NGAYTRATT = value;
            }
        }
        public Decimal LOAIYK
        {
            get
            {
                return _LOAIYK;
            }
            set
            {
                _LOAIYK = value;
            }
        }
        public String NOIDUNGYKIEN
        {
            get
            {
                return _NOIDUNGYKIEN;
            }
            set
            {
                _NOIDUNGYKIEN = value;
            }
        }
        // Phân công giải quyết
        public Decimal CAPTRINHTIEP
        {
            get
            {
                return _CAPTRINHTIEP;
            }
            set
            {
                _CAPTRINHTIEP = value;
            }
        }
        public Decimal TRINHTIEP_LANHDAO_ID
        {
            get
            {
                return _TRINHTIEP_LANHDAO_ID;
            }
            set
            {
                _TRINHTIEP_LANHDAO_ID = value;
            }
        }
        public String GHICHU
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
        public Decimal LANTRINH
        {
            get
            {
                return _LANTRINH;
            }
            set
            {
                _LANTRINH = value;
            }
        }
       
        #endregion

        #region Constructors
        public GDTTT_TOTRINH_TUHINH()
        {

        }
        public GDTTT_TOTRINH_TUHINH(Decimal ID, Decimal USER_ID, Decimal TUHINH_ID, String SOTT, DateTime NGAYTT, String DX_TTV, Decimal CAPTRINH,
            Decimal LANHDAOID,DateTime NGAYTRINH, DateTime NGAYDUKIENBC, DateTime NGAYNHANTT, DateTime NGAYTRATT, Decimal LOAIYK, String NOIDUNGYKIEN, 
            Decimal CAPTRINHTIEP, Decimal TRINHTIEP_LANHDAO_ID, String GHICHU, Decimal LANTRINH)
        {
            _ID = ID;
            _USER_ID = USER_ID;
            _TUHINH_ID = TUHINH_ID;
            _SOTT = SOTT;
            _NGAYTT = NGAYTT;
            _DX_TTV = DX_TTV;
            _CAPTRINH = CAPTRINH;
            _LANHDAOID = LANHDAOID;
            _NGAYTRINH = NGAYTRINH;
            _NGAYDUKIENBC = NGAYDUKIENBC;
            _NGAYNHANTT = NGAYNHANTT;
            _NGAYTRATT = NGAYTRATT;
            _LOAIYK = LOAIYK;
            _NOIDUNGYKIEN = NOIDUNGYKIEN;
            _CAPTRINHTIEP = CAPTRINHTIEP;
            _TRINHTIEP_LANHDAO_ID = TRINHTIEP_LANHDAO_ID;
            _GHICHU = GHICHU;
            _LANTRINH = LANTRINH;
        }
        #endregion

    }
}