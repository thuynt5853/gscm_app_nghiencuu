using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class TUPHAP_ANPHI_CN
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _TUPHAP_ANPHI_ID;       
        private DateTime _NGAY_CHUYEN;
        private String _NGUOI_CHUYEN;
        private String _TRANG_THAI;
        private DateTime _NGAY_THUHOI;
        private String _NGUOI_THUHOI;
        private DateTime _NGAY_TAO;
        private String _NGUOI_TAO;
        private DateTime _NGAY_SUA;
        private String _NGUOI_SUA;
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
        public Decimal TUPHAP_ANPHI_ID
        {
            get
            {
                return _TUPHAP_ANPHI_ID;
            }
            set
            {
                _TUPHAP_ANPHI_ID = value;
            }
        }
        public DateTime NGAY_CHUYEN
        {
            get
            {
                return _NGAY_CHUYEN;
            }
            set
            {
                _NGAY_CHUYEN = value;
            }
        }
        public String NGUOI_CHUYEN
        {
            get
            {
                return _NGUOI_CHUYEN;
            }
            set
            {
                _NGUOI_CHUYEN = value;
            }
        }
        public String TRANG_THAI
        {
            get
            {
                return _TRANG_THAI;
            }
            set
            {
                _TRANG_THAI = value;
            }
        }
        public DateTime NGAY_THUHOI
        {
            get
            {
                return _NGAY_THUHOI;
            }
            set
            {
                _NGAY_THUHOI = value;
            }
        }
        public String NGUOI_THUHOI
        {
            get
            {
                return _NGUOI_THUHOI;
            }
            set
            {
                _NGUOI_THUHOI = value;
            }
        }
        public DateTime NGAY_TAO
        {
            get
            {
                return _NGAY_TAO;
            }
            set
            {
                _NGAY_TAO = value;
            }
        }
        public String NGUOI_TAO
        {
            get
            {
                return _NGUOI_TAO;
            }
            set
            {
                _NGUOI_TAO = value;
            }
        }
        public DateTime NGAY_SUA
        {
            get
            {
                return _NGAY_SUA;
            }
            set
            {
                _NGAY_SUA = value;
            }
        }
        public String NGUOI_SUA
        {
            get
            {
                return _NGUOI_SUA;
            }
            set
            {
                _NGUOI_SUA = value;
            }
        }
        #endregion
        #region Constructors
        public TUPHAP_ANPHI_CN()
        {
        }
        public TUPHAP_ANPHI_CN(Decimal ID, Decimal TUPHAP_ANPHI_ID, DateTime NGAY_CHUYEN, String NGUOI_CHUYEN, String TRANG_THAI, DateTime NGAY_THUHOI, String NGUOI_THUHOI, DateTime NGAY_TAO, String NGUOI_TAO,DateTime NGAY_SUA, String NGUOI_SUA)
        {
            _ID = ID;
            _TUPHAP_ANPHI_ID = TUPHAP_ANPHI_ID;
            _NGAY_CHUYEN = NGAY_CHUYEN;
            _NGUOI_CHUYEN = NGUOI_CHUYEN;
            _TRANG_THAI = TRANG_THAI;
            _NGAY_THUHOI = NGAY_THUHOI;
            _NGUOI_THUHOI = NGUOI_THUHOI;
            _NGAY_TAO = NGAY_TAO;
            _NGUOI_TAO = NGUOI_TAO;
            _NGAY_SUA = NGAY_SUA;
            _NGUOI_SUA = NGUOI_SUA;
        }
        #endregion
    }
}