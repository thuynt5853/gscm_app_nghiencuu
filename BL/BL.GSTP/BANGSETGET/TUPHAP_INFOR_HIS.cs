using System;
using System.Collections.Generic;

namespace BL.GSTP.BANGSETGET
{
    public class TUPHAP_INFOR_HIS
    {
        #region Private Member variables  
        private Decimal _DONVI_THA_ID;
        private Decimal _USERID;
        private String _TEN_TK_THU_HUONG;
        private String _TEN_DONVI;
        private String _DIA_CHI;
        private String _DIEN_THOAI;
        private String _EMAIL;
        private String _MA_DINH_DANH;
        private String _SO_TK;
        private String _TEN_KHO_BAC;
        private String _MA_KHO_BAC;
        private String _MA_LH_THU;
        private String _TEN_LH_THU;
        private String _NGUOI_SUA;
        private String _NGAY_SUA;
        #endregion
        #region Public properties
        public Decimal DONVI_THA_ID
        {
            get
            {
                return _DONVI_THA_ID;
            }
            set
            {
                _DONVI_THA_ID = value;
            }
        }
        public Decimal USERID
        {
            get
            {
                return _USERID;
            }
            set
            {
                _USERID = value;
            }
        }
        public String TEN_TK_THU_HUONG
        {
            get
            {
                return _TEN_TK_THU_HUONG;
            }
            set
            {
                _TEN_TK_THU_HUONG = value;
            }
        }
        public String TEN_DONVI
        {
            get
            {
                return _TEN_DONVI;
            }
            set
            {
                _TEN_DONVI = value;
            }
        }
        public String DIA_CHI
        {
            get
            {
                return _DIA_CHI;
            }
            set
            {
                _DIA_CHI = value;
            }
        }
        public String DIEN_THOAI
        {
            get
            {
                return _DIEN_THOAI;
            }
            set
            {
                _DIEN_THOAI = value;
            }
        }
        public String EMAIL
        {
            get
            {
                return _EMAIL;
            }
            set
            {
                _EMAIL = value;
            }
        }
        public String MA_DINH_DANH
        {
            get
            {
                return _MA_DINH_DANH;
            }
            set
            {
                _MA_DINH_DANH = value;
            }
        }
        public String SO_TK
        {
            get
            {
                return _SO_TK;
            }
            set
            {
                _SO_TK = value;
            }
        }
        public String TEN_KHO_BAC
        {
            get
            {
                return _TEN_KHO_BAC;
            }
            set
            {
                _TEN_KHO_BAC = value;
            }
        }
        public String MA_KHO_BAC
        {
            get
            {
                return _MA_KHO_BAC;
            }
            set
            {
                _MA_KHO_BAC = value;
            }
        }
        public String MA_LH_THU
        {
            get
            {
                return _MA_LH_THU;
            }
            set
            {
                _MA_LH_THU = value;
            }
        }
        public String TEN_LH_THU
        {
            get
            {
                return _TEN_LH_THU;
            }
            set
            {
                _TEN_LH_THU = value;
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
        public TUPHAP_INFOR_HIS()
        {

        }
        public TUPHAP_INFOR_HIS(Decimal DONVI_THA_ID, Decimal USERID, String TEN_TK_THU_HUONG, String DIA_CHI, String DIEN_THOAI, String EMAIL,
        String MA_DINH_DANH, String SO_TK,String TEN_KHO_BAC,String MA_KHO_BAC, String MA_LH_THU,String TEN_LH_THU,String NGUOI_SUA)
        {
            _DONVI_THA_ID = DONVI_THA_ID;
            _USERID = USERID;
            _TEN_TK_THU_HUONG = TEN_TK_THU_HUONG;
            _TEN_DONVI = TEN_DONVI;
            _DIA_CHI = DIA_CHI;
            _DIEN_THOAI = DIEN_THOAI;
            _EMAIL = EMAIL;
            _MA_DINH_DANH = MA_DINH_DANH;
            _SO_TK = SO_TK;
            _TEN_KHO_BAC = TEN_KHO_BAC;
            _MA_KHO_BAC = MA_KHO_BAC;
            _MA_LH_THU = MA_LH_THU;
            _TEN_LH_THU = TEN_LH_THU;
            _NGUOI_SUA = NGUOI_SUA;
        }
        #endregion
    }
}