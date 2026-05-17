using System;
using System.Collections.Generic;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class GDTTT_TUHINH_DON
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _VUANID;
        private Decimal _DUONGSUID;
        private Decimal _HOSO_ANGIAM_ID;
        private String _NGUOIGUI;
        private String _NGUOIGUI_DIACHI;
        private Decimal _NGUOINHAN_ID;
        private DateTime _NGAYTRENDON;
        private DateTime _NGAYNHAN;
        private Decimal _LOAI;
        private String _NOIDUNG;
        private String _TENBIAN;
        private Decimal _NAMSINH;
        private Decimal _TOIDANH_ID;
        private String _TENTOIDANH;
        private String _DIACHI;
        private Decimal _CAPXX_ID;
        private String _SO_BA;
        private DateTime _NGAY_BA;
        private Decimal _TOAXX_ID;

        private String _SO_BAST;
        private DateTime _NGAY_BAST;
        private Decimal _TOAXXST_ID;

        private DateTime _NGAYTAO;
        private Decimal _NGUOITAO_ID;
        private String _NGUOITAO;
        private DateTime _NGAYSUA;
        private Decimal _NGUOISUA_ID;

        private DateTime _NGAYPHANCONGTTV;
        private Decimal _THAMTRAVIENID;
        private String _TENTHAMTRAVIEN;
        private DateTime _NgayNhanTieuHS;
        private DateTime _NgayNhanHS;
        private Decimal _LANHDAOVU;
        private Decimal _THAMPHAN;

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

        
        public Decimal VUANID
        {
            get
            {
                return _VUANID;
            }
            set
            {
                _VUANID = value;
            }
        }
        public Decimal DUONGSUID
        {
            get
            {
                return _DUONGSUID;
            }
            set
            {
                _DUONGSUID = value;
            }
        }
        public Decimal HOSO_ANGIAM_ID
        {
            get
            {
                return _HOSO_ANGIAM_ID;
            }
            set
            {
                _HOSO_ANGIAM_ID = value;
            }
        }
        
        public String NGUOIGUI
        {
            get
            {
                return _NGUOIGUI;
            }
            set
            {
                _NGUOIGUI = value;
            }
        }
        public String NGUOIGUI_DIACHI
        {
            get
            {
                return _NGUOIGUI_DIACHI;
            }
            set
            {
                _NGUOIGUI_DIACHI = value;
            }
        }
        public Decimal NGUOINHAN_ID
        {
            get
            {
                return _NGUOINHAN_ID;
            }
            set
            {
                _NGUOINHAN_ID = value;
            }
        }
        public DateTime NGAYTRENDON
        {
            get
            {
                return _NGAYTRENDON;
            }
            set
            {
                _NGAYTRENDON = value;
            }
        }
        public DateTime NGAYNHAN
        {
            get
            {
                return _NGAYNHAN;
            }
            set
            {
                _NGAYNHAN = value;
            }
        }
        public Decimal LOAI
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
        public String NOIDUNG
        {
            get
            {
                return _NOIDUNG;
            }
            set
            {
                _NOIDUNG = value;
            }
        }
        public String TENBIAN
        {
            get
            {
                return _TENBIAN;
            }
            set
            {
                _TENBIAN = value;
            }
        }
        public Decimal NAMSINH
        {
            get
            {
                return _NAMSINH;
            }
            set
            {
                _NAMSINH = value;
            }
        }
        public Decimal TOIDANH_ID
        {
            get
            {
                return _TOIDANH_ID;
            }
            set
            {
                _TOIDANH_ID = value;
            }
        }
        public String TENTOIDANH
        {
            get
            {
                return _TENTOIDANH;
            }
            set
            {
                _TENTOIDANH = value;
            }
        }
        public String DIACHI
        {
            get
            {
                return _DIACHI;
            }
            set
            {
                _DIACHI = value;
            }
        }
        public Decimal CAPXX_ID
        {
            get
            {
                return _CAPXX_ID;
            }
            set
            {
                _CAPXX_ID = value;
            }
        }
        public String SO_BA
        {
            get
            {
                return _SO_BA;
            }
            set
            {
                _SO_BA = value;
            }
        }
        public DateTime NGAY_BA
        {
            get
            {
                return _NGAY_BA;
            }
            set
            {
                _NGAY_BA = value;
            }
        }
        public Decimal TOAXX_ID
        {
            get
            {
                return _TOAXX_ID;
            }
            set
            {
                _TOAXX_ID = value;
            }
        }

        public String SO_BAST
        {
            get
            {
                return _SO_BAST;
            }
            set
            {
                _SO_BAST = value;
            }
        }
        public DateTime NGAY_BAST
        {
            get
            {
                return _NGAY_BAST;
            }
            set
            {
                _NGAY_BAST = value;
            }
        }
        public Decimal TOAXXST_ID
        {
            get
            {
                return _TOAXXST_ID;
            }
            set
            {
                _TOAXXST_ID = value;
            }
        }

        public DateTime NGAYTAO
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
        public Decimal NGUOITAO_ID
        {
            get
            {
                return _NGUOITAO_ID;
            }
            set
            {
                _NGUOITAO_ID = value;
            }
        }
        public String NGUOITAO
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
        public DateTime NGAYSUA
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
        public Decimal NGUOISUA_ID
        {
            get
            {
                return _NGUOISUA_ID;
            }
            set
            {
                _NGUOISUA_ID = value;
            }
        }
      
        public DateTime NGAYPHANCONGTTV
        {
            get
            {
                return _NGAYPHANCONGTTV;
            }
            set
            {
                _NGAYPHANCONGTTV = value;
            }
        }

        public DateTime NgayNhanTieuHS
        {
            get
            {
                return _NgayNhanTieuHS;
            }
            set
            {
                _NgayNhanTieuHS = value;
            }
        }

        public DateTime NgayNhanHS
        {
            get
            {
                return _NgayNhanHS;
            }
            set
            {
                _NgayNhanHS = value;
            }
        }

        public Decimal THAMTRAVIENID
        {
            get
            {
                return _THAMTRAVIENID;
            }
            set
            {
                _THAMTRAVIENID = value;
            }
        }

        public String TENTHAMTRAVIEN
        {
            get
            {
                return _TENTHAMTRAVIEN;
            }
            set
            {
                _TENTHAMTRAVIEN = value;
            }
        }
        public Decimal LANHDAOVU
        {
            get
            {
                return _LANHDAOVU;
            }
            set
            {
                _LANHDAOVU = value;
            }
        }
        public Decimal THAMPHAN
        {
            get
            {
                return _THAMPHAN;
            }
            set
            {
                _THAMPHAN = value;
            }
        }

        #endregion
        #region Constructors
        public GDTTT_TUHINH_DON()
        {
        }
        public GDTTT_TUHINH_DON(Decimal ID, Decimal VUANID, Decimal DUONGSUID, Decimal HOSO_ANGIAM_ID, String NGUOIGUI, String NGUOIGUI_DIACHI, Decimal NGUOINHAN_ID,
            DateTime NGAYTRENDON, DateTime NGAYNHAN, Decimal LOAI, String NOIDUNG, String TENBIAN, Decimal NAMSINH, Decimal TOIDANH_ID, String TENTOIDANH, String DIACHI,
            Decimal CAPXX_ID, String SO_BA, DateTime NGAY_BA, Decimal TOAXX_ID, String SO_BAST, DateTime NGAY_BAST, Decimal TOAXXST_ID, DateTime NGAYTAO, String NGUOITAO, String NGUOITAO_ID, DateTime NGAYSUA, Decimal NGUOISUA_ID,
            DateTime NGAYPHANCONGTTV, Decimal THAMTRAVIENID, String TENTHAMTRAVIEN, DateTime NgayNhanTieuHS, DateTime NgayNhanHS, Decimal LANHDAOVU, Decimal THAMPHAN)
        {
            _ID = ID;
            _VUANID = VUANID;
            _DUONGSUID = DUONGSUID;
            _HOSO_ANGIAM_ID = HOSO_ANGIAM_ID;
            _NGUOIGUI = NGUOIGUI;
            _NGUOIGUI_DIACHI = NGUOIGUI_DIACHI;
            _NGUOINHAN_ID = NGUOINHAN_ID;
            _NGAYTRENDON = NGAYTRENDON;
            _NGAYNHAN = NGAYNHAN;
            _LOAI = LOAI;
            _NOIDUNG = NOIDUNG;
            _TENBIAN = TENBIAN;
            _NAMSINH = NAMSINH;
            _TOIDANH_ID = TOIDANH_ID;
            _TENTOIDANH = TENTOIDANH;
            _DIACHI = DIACHI;
            _CAPXX_ID = CAPXX_ID;
            _SO_BA = SO_BA;
            _NGAY_BA = NGAY_BA;
            _TOAXX_ID = TOAXX_ID;
            _SO_BAST = SO_BAST;
            _NGAY_BAST = NGAY_BAST;
            _TOAXXST_ID = TOAXXST_ID;

            _NGAYTAO = NGAYTAO;
            _NGUOITAO = NGUOITAO_ID;
            _NGUOITAO = NGUOITAO;
            _NGAYSUA = NGAYSUA;
            _NGUOISUA_ID = NGUOISUA_ID;

            _NGAYPHANCONGTTV = NGAYPHANCONGTTV;
            _THAMTRAVIENID = THAMTRAVIENID;
            _TENTHAMTRAVIEN = TENTHAMTRAVIEN;
            _NgayNhanTieuHS = NgayNhanTieuHS;
            _NgayNhanHS = NgayNhanHS;
            _LANHDAOVU = LANHDAOVU;
            _THAMPHAN = THAMPHAN;
    }
        #endregion
    }
}