using System;
using System.Collections.Generic;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class QT_NHOMNGUOIDUNG_HOME
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _NHOMID;
        private Decimal _CHUONGTRINHID;
        private Decimal _XEM;
        private Decimal _XEM_ALL;
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
        public Decimal NHOMID
        {
            get
            {
                return _NHOMID;
            }
            set
            {
                _NHOMID = value;
            }
        }
        public Decimal CHUONGTRINHID
        {
            get
            {
                return _CHUONGTRINHID;
            }
            set
            {
                _CHUONGTRINHID = value;
            }
        }
        public Decimal XEM
        {
            get
            {
                return _XEM;
            }
            set
            {
                _XEM = value;
            }
        }
        public Decimal XEM_ALL
        {
            get
            {
                return _XEM_ALL;
            }
            set
            {
                _XEM_ALL = value;
            }
        }
        #endregion
        #region Constructors
        public QT_NHOMNGUOIDUNG_HOME()
        {
        }
        public QT_NHOMNGUOIDUNG_HOME(Decimal ID, Decimal NHOMID, Decimal CHUONGTRINHID, Decimal XEM, Decimal XEM_ALL)
        {
            _ID = ID;
            _NHOMID = NHOMID;
            _CHUONGTRINHID = CHUONGTRINHID;
            _XEM = XEM;
            _XEM_ALL = XEM_ALL;
        }
        #endregion
    }
}