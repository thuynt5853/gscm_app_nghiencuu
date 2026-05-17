using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class GDTTT_DON_GIAONHAN_THS
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _DONID;
        private Decimal _NGUOICHUYEN_ID;
        private Decimal _NGUOINHAN_ID;
        private DateTime _NGAYCHUYEN;
        private DateTime _NGAYNHAN;
        private Decimal _TRANGTHAI;     
        private String _GHICHU;

       
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
        public Decimal NGUOICHUYEN_ID
        {
            get
            {
                return _NGUOICHUYEN_ID;
            }
            set
            {
                _NGUOICHUYEN_ID = value;
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
        public DateTime NGAYCHUYEN
        {
            get
            {
                return _NGAYCHUYEN;
            }
            set
            {
                _NGAYCHUYEN = value;
            }
        }
       
        public Decimal TRANGTHAI
        {
            get
            {
                return _TRANGTHAI;
            }
            set
            {
                _TRANGTHAI = value;
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
       
       
        #endregion

        #region Constructors
        public GDTTT_DON_GIAONHAN_THS()
        {

        }
        public GDTTT_DON_GIAONHAN_THS(Decimal ID, Decimal DONID, Decimal NGUOICHUYEN_ID, Decimal NGUOINHAN_ID, DateTime NGAYNHAN, 
            DateTime NGAYCHUYEN, Decimal TRANGTHAI,String GHICHU)
        {
            _ID = ID;
            _DONID = DONID;
            _NGUOICHUYEN_ID = NGUOICHUYEN_ID;
            _NGUOINHAN_ID = NGUOINHAN_ID;
            _NGAYNHAN = NGAYNHAN;
            _NGAYCHUYEN = NGAYCHUYEN;
            _TRANGTHAI = TRANGTHAI;
            _GHICHU = GHICHU;
        }
        #endregion

    }
}