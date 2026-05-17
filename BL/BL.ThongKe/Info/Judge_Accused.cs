using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace BL.THONGKE.Info
{
  public class Judge_Accused
    {
        #region Private Member variables   
        private Decimal _ID;
        private Decimal _TYPES;
        private Decimal _COURT_ID;
        private Decimal _COURT_EXTID;
        private Decimal _REPORT_TIME_ID;
        private Decimal _CASES_ID;
        private String _CASE_NAME;
        private Decimal _PARENT_ID;
        private Decimal _PARENT_ID_COURT;
        private String _CASE_NAME_S;
        private String _COLUMN_1;
        private String _COLUMN_2;
        private String _COLUMN_3;
        private String _COLUMN_4;
        private String _COLUMN_5;
        private String _COLUMN_6;
        private String _COLUMN_7;
        private String _COLUMN_8;
        private String _COLUMN_9;
        private String _COLUMN_10;
        private String _COLUMN_11;
        private String _COLUMN_12;
        private String _COLUMN_13;
        private String _COLUMN_14;
        private String _COLUMN_15;
        private String _COLUMN_16;
        private String _COLUMN_17;
        private String _COLUMN_18;
        private String _COLUMN_19;
        private String _COLUMN_20;
        private String _COLUMN_21;
        private String _CREATE_USER;
        private DateTime _CREATE_DATE;
        private Decimal _ID_LAST_MONTH;
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
        public Decimal TYPES
        {
            get
            {
                return _TYPES;
            }
            set
            {
                _TYPES = value;
            }
        }
        public Decimal COURT_ID
        {
            get
            {
                return _COURT_ID;
            }
            set
            {
                _COURT_ID = value;
            }
        }
        public Decimal COURT_EXTID
        {
            get
            {
                return _COURT_EXTID;
            }
            set
            {
                _COURT_EXTID = value;
            }
        }
        public Decimal REPORT_TIME_ID
        {
            get
            {
                return _REPORT_TIME_ID;
            }
            set
            {
                _REPORT_TIME_ID = value;
            }
        }
        public Decimal CASES_ID
        {
            get
            {
                return _CASES_ID;
            }
            set
            {
                _CASES_ID = value;
            }
        }
        public String CASE_NAME
        {
            get
            {
                return _CASE_NAME;
            }
            set
            {
                _CASE_NAME = value;
            }
        }
        public String CASE_NAME_S
        {
            get
            {
                return _CASE_NAME_S;
            }
            set
            {
                _CASE_NAME_S = value;
            }
        }
        public Decimal PARENT_ID_COURT
        {
            get
            {
                return _PARENT_ID_COURT;
            }
            set
            {
                _PARENT_ID_COURT = value;
            }
        }
        public Decimal PARENT_ID
        {
            get
            {
                return _PARENT_ID;
            }
            set
            {
                _PARENT_ID = value;
            }
        }
        public String COLUMN_1
        {
            get
            {
                return _COLUMN_1;
            }
            set
            {
                _COLUMN_1 = value;
            }
        }
        public String COLUMN_2
        {
            get
            {
                return _COLUMN_2;
            }
            set
            {
                _COLUMN_2 = value;
            }
        }
        public String COLUMN_3
        {
            get
            {
                return _COLUMN_3;
            }
            set
            {
                _COLUMN_3 = value;
            }
        }
        public String COLUMN_4
        {
            get
            {
                return _COLUMN_4;
            }
            set
            {
                _COLUMN_4 = value;
            }
        }
        public String COLUMN_5
        {
            get
            {
                return _COLUMN_5;
            }
            set
            {
                _COLUMN_5 = value;
            }
        }
        public String COLUMN_6
        {
            get
            {
                return _COLUMN_6;
            }
            set
            {
                _COLUMN_6 = value;
            }
        }
        public String COLUMN_7
        {
            get
            {
                return _COLUMN_7;
            }
            set
            {
                _COLUMN_7 = value;
            }
        }
        public String COLUMN_8
        {
            get
            {
                return _COLUMN_8;
            }
            set
            {
                _COLUMN_8 = value;
            }
        }
        public String COLUMN_9
        {
            get
            {
                return _COLUMN_9;
            }
            set
            {
                _COLUMN_9 = value;
            }
        }
        public String COLUMN_10
        {
            get
            {
                return _COLUMN_10;
            }
            set
            {
                _COLUMN_10 = value;
            }
        }

        public String COLUMN_11
        {
            get
            {
                return _COLUMN_11;
            }
            set
            {
                _COLUMN_11 = value;
            }
        }
        public String COLUMN_12
        {
            get
            {
                return _COLUMN_12;
            }
            set
            {
                _COLUMN_12 = value;
            }
        }
        public String COLUMN_13
        {
            get
            {
                return _COLUMN_13;
            }
            set
            {
                _COLUMN_13 = value;
            }
        }
        public String COLUMN_14
        {
            get
            {
                return _COLUMN_14;
            }
            set
            {
                _COLUMN_14 = value;
            }
        }
        public String COLUMN_15
        {
            get
            {
                return _COLUMN_15;
            }
            set
            {
                _COLUMN_15 = value;
            }
        }
        public String COLUMN_16
        {
            get
            {
                return _COLUMN_16;
            }
            set
            {
                _COLUMN_16 = value;
            }
        }
        public String COLUMN_17
        {
            get
            {
                return _COLUMN_17;
            }
            set
            {
                _COLUMN_17 = value;
            }
        }
        public String COLUMN_18
        {
            get
            {
                return _COLUMN_18;
            }
            set
            {
                _COLUMN_18 = value;
            }
        }
        public String COLUMN_19
        {
            get
            {
                return _COLUMN_19;
            }
            set
            {
                _COLUMN_19 = value;
            }
        }
        public String COLUMN_20
        {
            get
            {
                return _COLUMN_20;
            }
            set
            {
                _COLUMN_20 = value;
            }
        }
        public String COLUMN_21
        {
            get
            {
                return _COLUMN_21;
            }
            set
            {
                _COLUMN_21 = value;
            }
        }
        public DateTime CREATE_DATE
        {
            get
            {
                return _CREATE_DATE;
            }
            set
            {
                _CREATE_DATE = value;
            }
        }
        public String CREATE_USER
        {
            get
            {
                return _CREATE_USER;
            }
            set
            {
                _CREATE_USER = value;
            }
        }
        public Decimal ID_LAST_MONTH
        {
            get
            {
                return _ID_LAST_MONTH;
            }
            set
            {
                _ID_LAST_MONTH = value;
            }
        }
        
        #endregion
        #region Constructors
        public Judge_Accused()
        {

        }
        public Judge_Accused(Decimal ID, Decimal TYPES, Decimal COURT_ID, Decimal COURT_EXTID, Decimal REPORT_TIME_ID, Decimal CASES_ID, String CASE_NAME, Decimal PARENT_ID, String COLUMN_1, String COLUMN_2, String COLUMN_3, String COLUMN_4, String COLUMN_5, String COLUMN_6, String COLUMN_7, String COLUMN_8, String COLUMN_9, String COLUMN_10, String COLUMN_11, String COLUMN_12, String COLUMN_13, String COLUMN_14, String COLUMN_15, String COLUMN_16, String COLUMN_17, String COLUMN_18, String COLUMN_19, String COLUMN_20, String COLUMN_21, String CREATE_USER, DateTime CREATE_DATE, Decimal ID_LAST_MONTH)
        {
            _ID = ID;
            _TYPES = TYPES;
            _COURT_ID = COURT_ID;
            _COURT_EXTID = COURT_EXTID;
            _REPORT_TIME_ID = REPORT_TIME_ID;
            _CASES_ID = CASES_ID;
            _CASE_NAME = CASE_NAME;
            _PARENT_ID = PARENT_ID;
            _COLUMN_1 = COLUMN_1;
            _COLUMN_2 = COLUMN_2;
            _COLUMN_3 = COLUMN_3;
            _COLUMN_4 = COLUMN_4;
            _COLUMN_5 = COLUMN_5;
            _COLUMN_6 = COLUMN_6;
            _COLUMN_7 = COLUMN_7;
            _COLUMN_8 = COLUMN_8;
            _COLUMN_9 = COLUMN_9;
            _COLUMN_10 = COLUMN_10;
            _COLUMN_11 = COLUMN_11;
            _COLUMN_12 = COLUMN_12;
            _COLUMN_13 = COLUMN_13;
            _COLUMN_14 = COLUMN_14;
            _COLUMN_15 = COLUMN_15;
            _COLUMN_16 = COLUMN_16;
            _COLUMN_17 = COLUMN_17;
            _COLUMN_18 = COLUMN_18;
            _COLUMN_19 = COLUMN_19;
            _COLUMN_20 = COLUMN_20;
            _COLUMN_21 = COLUMN_21;
            _CREATE_DATE = CREATE_DATE;
            _CREATE_USER = CREATE_USER;
            _ID_LAST_MONTH = ID_LAST_MONTH;
        }
        #endregion
    }
}
