using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class GDTTT_DON_YEUCAU_BOSUNG
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _DONID;
        private String _NGUOIKY;
        private String _SOTHONGBAO;
        private DateTime _NGAYTHONGBAO;
        private Decimal? _CD_TA_LYDO_ISBAQD;
        private Decimal? _CD_TA_LYDO_ISXACNHAN;
        private Decimal? _CD_TA_LYDO_ISKHAC;
        private String _NOIDUNG;        
        private Decimal _KETQUA;
        private String _NOIDUNGKQ;
        private DateTime _NGAYBOSUNG;
        private DateTime _NGAYTAO;
        private String _NGUOITAO;
        private Decimal _LANTHU;
        #endregion
        #region Constructors
        public GDTTT_DON_YEUCAU_BOSUNG()
        {

        }
        public GDTTT_DON_YEUCAU_BOSUNG(Decimal ID, Decimal DONID, Decimal LANTHU, String NGUOIKY, String SOTHONGBAO, DateTime NGAYTHONGBAO, Decimal? CD_TA_LYDO_ISBAQD, Decimal? CD_TA_LYDO_ISXACNHAN, Decimal? CD_TA_LYDO_ISKHAC, String NOIDUNG, Decimal KETQUA, String NOIDUNGKQ, DateTime NGAYBOSUNG, DateTime NGAYTAO, String NGUOITAO)
        {
            this.ID = ID;
            this.DONID = DONID;
            this.LANTHU = LANTHU;
            this.NGUOIKY = NGUOIKY;
            this.SOTHONGBAO = SOTHONGBAO;
            this.NGAYTHONGBAO = NGAYTHONGBAO;
            this.CD_TA_LYDO_ISBAQD = CD_TA_LYDO_ISBAQD;
            this.CD_TA_LYDO_ISXACNHAN = CD_TA_LYDO_ISXACNHAN;
            this.CD_TA_LYDO_ISKHAC = CD_TA_LYDO_ISKHAC;
            this.NOIDUNG = NOIDUNG;
            this.KETQUA = KETQUA;
            this.NOIDUNGKQ = NOIDUNGKQ;
            this.NGAYBOSUNG = NGAYBOSUNG;
            this.NGAYTAO = NGAYTAO;
            this.NGUOITAO = NGUOITAO;
        }
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
        public Decimal DONID
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
        public Decimal LANTHU
        {
            get
            {
                return _LANTHU;
            }
            set
            {
                _LANTHU = value;
            }
        }
        public String NGUOIKY
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
        public String SOTHONGBAO
        {
            get
            {
                return _SOTHONGBAO;
            }
            set
            {
                _SOTHONGBAO = value;
            }
        }
        public DateTime NGAYTHONGBAO
        {
            get
            {
                return _NGAYTHONGBAO;
            }
            set
            {
                _NGAYTHONGBAO = value;
            }
        }
        public Decimal? CD_TA_LYDO_ISBAQD
        {
            get
            {
                return _CD_TA_LYDO_ISBAQD;
            }
            set
            {
                _CD_TA_LYDO_ISBAQD = value;
            }
        }
        public Decimal? CD_TA_LYDO_ISXACNHAN
        {
            get
            {
                return _CD_TA_LYDO_ISXACNHAN;
            }
            set
            {
                _CD_TA_LYDO_ISXACNHAN = value;
            }
        }
        public Decimal? CD_TA_LYDO_ISKHAC
        {
            get
            {
                return _CD_TA_LYDO_ISKHAC;
            }
            set
            {
                _CD_TA_LYDO_ISKHAC = value;
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
        public Decimal KETQUA
        {
            get
            {
                return _KETQUA;
            }
            set
            {
                _KETQUA = value;
            }
        }
        public String NOIDUNGKQ
        {
            get
            {
                return _NOIDUNGKQ;
            }
            set
            {
                _NOIDUNGKQ = value;
            }
        }
        public DateTime NGAYBOSUNG
        {
            get
            {
                return _NGAYBOSUNG;
            }
            set
            {
                _NGAYBOSUNG = value;
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
        #endregion
    }
}