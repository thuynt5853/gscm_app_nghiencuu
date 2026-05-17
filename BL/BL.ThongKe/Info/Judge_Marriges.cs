using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Judge_Marriges
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
        private Decimal _COLUMN_1;
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
        private Decimal _COLUMN_22;
        private Decimal _COLUMN_23;
        private Decimal _COLUMN_24;
        private Decimal _COLUMN_25;
        private Decimal _COLUMN_26;
        private Decimal _COLUMN_27;
        private Decimal _COLUMN_28;
        private Decimal _COLUMN_29;
        private Decimal _COLUMN_30;
        private Decimal _COLUMN_31;
        private Decimal _COLUMN_32;
        private Decimal _COLUMN_33;
        private Decimal _COLUMN_34;
        private Decimal _COLUMN_35;
        private Decimal _COLUMN_36;
        private Decimal _COLUMN_37;
        private Decimal _COLUMN_38;
        private Decimal _COLUMN_39;
        private Decimal _COLUMN_40;
        private Decimal _COLUMN_41;
        private Decimal _COLUMN_42;
        private Decimal _COLUMN_43;
        private Decimal _COLUMN_44;
        private Decimal _COLUMN_45;
        private Decimal _COLUMN_46;
        private Decimal _COLUMN_47;
        private Decimal _COLUMN_48;
        private Decimal _COLUMN_49;
        private String _CREATE_USER;
        private DateTime _CREATE_DATE;
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
        public Decimal COLUMN_1
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
        public Decimal COLUMN_22
        {
            get
            {
                return _COLUMN_22;
            }
            set
            {
                _COLUMN_22 = value;
            }
        }
        public Decimal COLUMN_23
        {
            get
            {
                return _COLUMN_23;
            }
            set
            {
                _COLUMN_23 = value;
            }
        }
        public Decimal COLUMN_24
        {
            get
            {
                return _COLUMN_24;
            }
            set
            {
                _COLUMN_24 = value;
            }
        }
        public Decimal COLUMN_25
        {
            get
            {
                return _COLUMN_25;
            }
            set
            {
                _COLUMN_25 = value;
            }
        }
        public Decimal COLUMN_26
        {
            get
            {
                return _COLUMN_26;
            }
            set
            {
                _COLUMN_26 = value;
            }
        }
        public Decimal COLUMN_27
        {
            get
            {
                return _COLUMN_27;
            }
            set
            {
                _COLUMN_27 = value;
            }
        }
        public Decimal COLUMN_28
        {
            get
            {
                return _COLUMN_28;
            }
            set
            {
                _COLUMN_28 = value;
            }
        }
        public Decimal COLUMN_29
        {
            get
            {
                return _COLUMN_29;
            }
            set
            {
                _COLUMN_29 = value;
            }
        }
        public Decimal COLUMN_30
        {
            get
            {
                return _COLUMN_30;
            }
            set
            {
                _COLUMN_30 = value;
            }
        }

        public Decimal COLUMN_31
        {
            get
            {
                return _COLUMN_31;
            }
            set
            {
                _COLUMN_31 = value;
            }
        }
        public Decimal COLUMN_32
        {
            get
            {
                return _COLUMN_32;
            }
            set
            {
                _COLUMN_32 = value;
            }
        }
        public Decimal COLUMN_33
        {
            get
            {
                return _COLUMN_33;
            }
            set
            {
                _COLUMN_33 = value;
            }
        }
        public Decimal COLUMN_34
        {
            get
            {
                return _COLUMN_34;
            }
            set
            {
                _COLUMN_34 = value;
            }
        }
        public Decimal COLUMN_35
        {
            get
            {
                return _COLUMN_35;
            }
            set
            {
                _COLUMN_35 = value;
            }
        }
        public Decimal COLUMN_36
        {
            get
            {
                return _COLUMN_36;
            }
            set
            {
                _COLUMN_36 = value;
            }
        }
        public Decimal COLUMN_37
        {
            get
            {
                return _COLUMN_37;
            }
            set
            {
                _COLUMN_37 = value;
            }
        }
        public Decimal COLUMN_38
        {
            get
            {
                return _COLUMN_38;
            }
            set
            {
                _COLUMN_38 = value;
            }
        }
        public Decimal COLUMN_39
        {
            get
            {
                return _COLUMN_39;
            }
            set
            {
                _COLUMN_39 = value;
            }
        }
        public Decimal COLUMN_40
        {
            get
            {
                return _COLUMN_40;
            }
            set
            {
                _COLUMN_40 = value;
            }
        }

        public Decimal COLUMN_41
        {
            get
            {
                return _COLUMN_41;
            }
            set
            {
                _COLUMN_41 = value;
            }
        }
        public Decimal COLUMN_42
        {
            get
            {
                return _COLUMN_42;
            }
            set
            {
                _COLUMN_42 = value;
            }
        }
        public Decimal COLUMN_43
        {
            get
            {
                return _COLUMN_43;
            }
            set
            {
                _COLUMN_43 = value;
            }
        }
        public Decimal COLUMN_44
        {
            get
            {
                return _COLUMN_44;
            }
            set
            {
                _COLUMN_44 = value;
            }
        }
        public Decimal COLUMN_45
        {
            get
            {
                return _COLUMN_45;
            }
            set
            {
                _COLUMN_45 = value;
            }
        }
        public Decimal COLUMN_46
        {
            get
            {
                return _COLUMN_46;
            }
            set
            {
                _COLUMN_46 = value;
            }
        }
        public Decimal COLUMN_47
        {
            get
            {
                return _COLUMN_47;
            }
            set
            {
                _COLUMN_47 = value;
            }
        }
        public Decimal COLUMN_48
        {
            get
            {
                return _COLUMN_48;
            }
            set
            {
                _COLUMN_48 = value;
            }
        }
        public Decimal COLUMN_49
        {
            get
            {
                return _COLUMN_49;
            }
            set
            {
                _COLUMN_49 = value;
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
        #endregion
        #region Constructors
        public Judge_Marriges()
        {
           
        }
        public Judge_Marriges(Decimal ID, Decimal TYPES, Decimal COURT_ID, Decimal COURT_EXTID, Decimal REPORT_TIME_ID, Decimal CASES_ID, String CASE_NAME, Decimal PARENT_ID, Decimal COLUMN_1, Decimal COLUMN_2, Decimal COLUMN_3, Decimal COLUMN_4, Decimal COLUMN_5, Decimal COLUMN_6, Decimal COLUMN_7, Decimal COLUMN_8, Decimal COLUMN_9, Decimal COLUMN_10, Decimal COLUMN_11, Decimal COLUMN_12, Decimal COLUMN_13, Decimal COLUMN_14, Decimal COLUMN_15, Decimal COLUMN_16, Decimal COLUMN_17, Decimal COLUMN_18, Decimal COLUMN_19, Decimal COLUMN_20, Decimal COLUMN_21, Decimal COLUMN_22, Decimal COLUMN_23, Decimal COLUMN_24, Decimal COLUMN_25, Decimal COLUMN_26, Decimal COLUMN_27, Decimal COLUMN_28, Decimal COLUMN_29, Decimal COLUMN_30, Decimal COLUMN_31, Decimal COLUMN_32, Decimal COLUMN_33, Decimal COLUMN_34, Decimal COLUMN_35, Decimal COLUMN_36, Decimal COLUMN_37, Decimal COLUMN_38, Decimal COLUMN_39, Decimal COLUMN_40, Decimal COLUMN_41, Decimal COLUMN_42, Decimal COLUMN_43, Decimal COLUMN_44, Decimal COLUMN_45, Decimal COLUMN_46, Decimal COLUMN_47, Decimal COLUMN_48, Decimal COLUMN_49, String CREATE_USER, DateTime CREATE_DATE)
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
            _COLUMN_22 = COLUMN_22;
            _COLUMN_23 = COLUMN_23;
            _COLUMN_24 = COLUMN_24;
            _COLUMN_25 = COLUMN_25;
            _COLUMN_26 = COLUMN_26;
            _COLUMN_27 = COLUMN_27;
            _COLUMN_28 = COLUMN_28;
            _COLUMN_29 = COLUMN_29;
            _COLUMN_30 = COLUMN_30;
            _COLUMN_31 = COLUMN_31;
            _COLUMN_32 = COLUMN_32;
            _COLUMN_33 = COLUMN_33;
            _COLUMN_34 = COLUMN_34;
            _COLUMN_35 = COLUMN_35;
            _COLUMN_36 = COLUMN_36;
            _COLUMN_37 = COLUMN_37;
            _COLUMN_38 = COLUMN_38;
            _COLUMN_39 = COLUMN_39;
            _COLUMN_40 = COLUMN_40;
            _COLUMN_41 = COLUMN_41;
            _COLUMN_42 = COLUMN_42;
            _COLUMN_43 = COLUMN_43;
            _COLUMN_44 = COLUMN_44;
            _COLUMN_45 = COLUMN_45;
            _COLUMN_46 = COLUMN_46;
            _COLUMN_47 = COLUMN_47;
            _COLUMN_48 = COLUMN_48;
            _COLUMN_49 = COLUMN_49;
            _CREATE_DATE = CREATE_DATE;
            _CREATE_USER = CREATE_USER;
        }
        #endregion

    }
}
