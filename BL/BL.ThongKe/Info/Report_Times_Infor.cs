using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Report_Times_Infor
    {
        #region Private Member variables                 
        private Decimal _ID_REPORT_TIME;
        private Decimal _ID_COURTS;
        private String _USER_WRITE;
        private String _USER_SIGNER;
        private DateTime _DATETIME_ACTIVE;
        private Decimal _TYPE_OF;  
        private Decimal _ACTIVE_REPORT;
        private Decimal _ACTIVE_SEND;//anhvh
        #endregion
        #region Public properties 
        public Decimal ACTIVE_SEND
        {
            get
            {
                return _ACTIVE_SEND;
            }
            set
            {
                _ACTIVE_SEND = value;
            }
        }
        public Decimal ACTIVE_REPORT
        {
            get
            {
                return _ACTIVE_REPORT;
            }
            set
            {
                _ACTIVE_REPORT = value;
            }
        }
        public Decimal TYPE_OF
        {
            get
            {
                return _TYPE_OF;
            }
            set
            {
                _TYPE_OF = value;
            }
        }
        public Decimal ID_REPORT_TIME
        {
            get
            {
                return _ID_REPORT_TIME;
            }
            set
            {
                _ID_REPORT_TIME = value;
            }
        }
        public Decimal ID_COURTS
        {
            get
            {
                return _ID_COURTS;
            }
            set
            {
                _ID_COURTS = value;
            }
        }
        public DateTime DATETIME_ACTIVE
        {
            get
            {
                return _DATETIME_ACTIVE;
            }
            set
            {
                _DATETIME_ACTIVE = value;
            }
        }
        public String USER_WRITE
        {
            get
            {
                return _USER_WRITE;
            }
            set
            {
                _USER_WRITE = value;
            }
        }
        public String USER_SIGNER
        {
            get
            {
                return _USER_SIGNER;
            }
            set
            {
                _USER_SIGNER = value;
            }
        }      
        #endregion
        #region Constructors
        public Report_Times_Infor()
        {
        }
        public Report_Times_Infor(Decimal ACTIVE_SEND, Decimal ACTIVE_REPORT, Decimal TYPE_OF, Decimal ID_REPORT_TIME, Decimal ID_COURTS, String USER_WRITE, String USER_SIGNER, DateTime DATETIME_ACTIVE)
        {
            _ID_REPORT_TIME = ID_REPORT_TIME;
            _ID_COURTS = ID_COURTS;
            _USER_WRITE = USER_WRITE;
            _USER_SIGNER = USER_SIGNER;
            _DATETIME_ACTIVE = DATETIME_ACTIVE;
            _TYPE_OF = TYPE_OF;
            _ACTIVE_SEND = ACTIVE_SEND;
            _ACTIVE_REPORT = ACTIVE_REPORT;
            
        }
        #endregion

    }
}
