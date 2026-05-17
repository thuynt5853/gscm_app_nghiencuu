using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Report_Times
    {
        #region Private Member variables   
        private Decimal _Row_;
        private Decimal _TotalRecord;
        private Decimal _ID;
        private String _TIME_ID;
        private String _TIME_NAME;
        private DateTime _TIME_FROM;       
        private DateTime _TIME_TO; 
        private String _DESCRIPTION;
        private Decimal _INDEX_SORT;
        private Decimal _ENABLE;
        private Decimal _TYPES_REPORT;
        #endregion
        #region Public properties        
        public Decimal Row_
        {
            get
            {
                return _Row_;
            }
            set
            {
                _Row_ = value;
            }
        }
        public Decimal TotalRecord
        {
            get
            {
                return _TotalRecord;
            }
            set
            {
                _TotalRecord = value;
            }
        }
        public Decimal ENABLE
        {
            get
            {
                return _ENABLE;
            }
            set
            {
                _ENABLE = value;
            }
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
        public Decimal INDEX_SORT
        {
            get
            {
                return _INDEX_SORT;
            }
            set
            {
                _INDEX_SORT = value;
            }
        }
        public String TIME_ID
        {
            get
            {
                return _TIME_ID;
            }
            set
            {
                _TIME_ID = value;
            }
        }
        public String TIME_NAME
        {
            get
            {
                return _TIME_NAME;
            }
            set
            {
                _TIME_NAME = value;
            }
        }
        public DateTime TIME_FROM
        {
            get
            {
                return _TIME_FROM;
            }
            set
            {
                _TIME_FROM = value;
            }
        }  
        public DateTime TIME_TO
        {
            get
            {
                return _TIME_TO;
            }
            set
            {
                _TIME_TO = value;
            }
        }      
        public String DESCRIPTION
        {
            get
            {
                return _DESCRIPTION;
            }
            set
            {
                _DESCRIPTION = value;
            }
        }
        public Decimal TYPES_REPORT
        {
            get
            {
                return _TYPES_REPORT;
            }
            set
            {
                _TYPES_REPORT = value;
            }
        }
        #endregion
        #region Constructors
        public Report_Times()
        {
        }
        public Report_Times(Decimal ENABLE, Decimal ID, Decimal INDEX_SORT, String TIME_ID, String TIME_NAME, DateTime TIME_FROM, DateTime TIME_TO, String DESCRIPTION, Decimal TYPES_REPORT)
        {
            _ID=ID;
            _TIME_ID = TIME_ID;
            _TIME_NAME = TIME_NAME;
            _TIME_FROM = TIME_FROM;
            _TIME_TO = TIME_TO;
            _DESCRIPTION=DESCRIPTION;
            _INDEX_SORT = INDEX_SORT;
            _ENABLE = ENABLE;
            _TYPES_REPORT = TYPES_REPORT;
        }
        #endregion

    }
}
