using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class QT_NHOMNGUOIDUNG_ISHOME
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _NHOMID;
        private Decimal _VIEW_TK;
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
        public Decimal VIEW_TK
        {
            get
            {
                return _VIEW_TK;
            }
            set
            {
                _VIEW_TK = value;
            }
        }
        #endregion
        #region Constructors
        public QT_NHOMNGUOIDUNG_ISHOME()
        {
        }
        public QT_NHOMNGUOIDUNG_ISHOME(Decimal ID, Decimal NHOMID, Decimal VIEW_TK)
        {
            _ID = ID;
            _NHOMID = NHOMID;
            _VIEW_TK = VIEW_TK;
        }
        #endregion
    }
}