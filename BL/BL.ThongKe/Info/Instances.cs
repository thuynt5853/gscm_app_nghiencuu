using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Instances
    {
        #region Private Member variables   
        private Decimal _ID;
        private Decimal _COURT_ID;
        private Decimal _REPORT_TIME_ID;
        private String _CASE_NAME;       
        private Decimal _CASES_ID;  
        private Decimal _COLUMN_2;
        private Decimal _COLUMN_3;
        private Decimal _COLUMN_4;
        private Decimal _COLUMN_5;
        private Decimal _COLUMN_6;
        private Decimal _COLUMN_7;
        private Decimal _COLUMN_8;
        private Decimal _COLUMN_9;
        private Decimal _COLUMN_10;
        private Decimal _COLUMN_11;
        private Decimal _COLUMN_12;
        private Decimal _COLUMN_13;
        private Decimal _COLUMN_14;
        private Decimal _COLUMN_15;
        private Decimal _COLUMN_16;
        private Decimal _COLUMN_17;
        private Decimal _COLUMN_18;
        private Decimal _COLUMN_19;
        private Decimal _COLUMN_20;
        private Decimal _COLUMN_21;             
        private String _CREATE_USER;
        private DateTime _CREATE_DATE;
        private Decimal _PARENT_ID;
        private Decimal _INDEX_SORT_INST;
        private Decimal _PARENT_ID_COURT;
        private String _CASE_NAME_S;
        #endregion
        #region Public properties
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
        public Decimal INDEX_SORT_INST
        {
            get
            {
                return _INDEX_SORT_INST;
            }
            set
            {
                _INDEX_SORT_INST = value;
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
        public Decimal COLUMN_2
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
        public Decimal COLUMN_3
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
        public Decimal COLUMN_4
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
        public Decimal COLUMN_5
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
        public Decimal COLUMN_6
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
        public Decimal COLUMN_7
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
        public Decimal COLUMN_8
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
        public Decimal COLUMN_9
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
        public Decimal COLUMN_10
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

        public Decimal COLUMN_11
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
        public Decimal COLUMN_12
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
        public Decimal COLUMN_13
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
        public Decimal COLUMN_14
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
        public Decimal COLUMN_15
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
        public Decimal COLUMN_16
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
        public Decimal COLUMN_17
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
        public Decimal COLUMN_18
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
        public Decimal COLUMN_19
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
        public Decimal COLUMN_20
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

        public Decimal COLUMN_21
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
        #endregion
        #region Constructors
        public Instances()
        {
           
        }
        public Instances(Decimal PARENT_ID, String CREATE_USER, DateTime CREATE_DATE, Decimal ID, Decimal COURT_ID, Decimal REPORT_TIME_ID, Decimal CASES_ID, Decimal COLUMN_2, Decimal COLUMN_3, Decimal COLUMN_4, Decimal COLUMN_5, Decimal COLUMN_6, Decimal COLUMN_7, Decimal COLUMN_8, Decimal COLUMN_9, Decimal COLUMN_10, Decimal COLUMN_11, Decimal COLUMN_12, Decimal COLUMN_13, Decimal COLUMN_14, Decimal COLUMN_15, Decimal COLUMN_16, Decimal COLUMN_17, Decimal COLUMN_18, Decimal COLUMN_19, Decimal COLUMN_20, Decimal COLUMN_21)
        {
            _ID = ID;
            _CREATE_DATE = CREATE_DATE;
            _COURT_ID = COURT_ID;
            _REPORT_TIME_ID = REPORT_TIME_ID;
            _CASES_ID = CASES_ID;
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
            _CREATE_USER = CREATE_USER;
            _PARENT_ID = PARENT_ID;
        }
        #endregion

    }
}
