using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace BL.THONGKE.Info
{
  public class Judge_Criminal
    {

        #region Private Member variables
        private Decimal _ID;
        private Decimal _TYPES;
        private Decimal _COURT_ID;
        private Decimal _COURT_EXTID;
        private Decimal _REPORT_TIME_ID;
        private Decimal _CASES_ID;
        private String _CRIMINAL_ID;
        private String  _CASE_NAME;
        private String _COURT_NAME;
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
        private Decimal _COLUMN_50;
        private Decimal _COLUMN_51;
        private Decimal _COLUMN_52;
        private Decimal _COLUMN_53;
        private Decimal _COLUMN_54;
        private Decimal _COLUMN_55;
        private Decimal _COLUMN_56;
        private Decimal _COLUMN_57;
        private Decimal _COLUMN_58;
        private Decimal _COLUMN_59;
        private Decimal _COLUMN_60;
        private Decimal _COLUMN_61;
        private Decimal _COLUMN_62;
        private Decimal _COLUMN_63;
        private Decimal _COLUMN_64;
        private Decimal _COLUMN_65;
        private Decimal _COLUMN_66;
        private Decimal _COLUMN_67;
        private Decimal _COLUMN_68;
        private Decimal _COLUMN_69;
        private Decimal _COLUMN_70;
        private Decimal _COLUMN_71;
        private Decimal _COLUMN_72;
        private Decimal _COLUMN_73;
        private Decimal _COLUMN_74;
        private Decimal _COLUMN_75;
        private Decimal _COLUMN_76;
        private Decimal _COLUMN_77;
        private Decimal _COLUMN_78;
        private Decimal _COLUMN_79;
        private Decimal _COLUMN_80;
        private Decimal _COLUMN_81;
        private Decimal _COLUMN_82;
        private Decimal _COLUMN_83;
        private Decimal _COLUMN_84;
        private Decimal _COLUMN_85;
        private Decimal _COLUMN_86;
        private Decimal _COLUMN_87;
        private Decimal _COLUMN_88;
        private Decimal _COLUMN_89;
        private Decimal _COLUMN_90;
        private Decimal _COLUMN_91;
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
        public String CRIMINAL_ID
        {
            get
            {
                return _CRIMINAL_ID;
            }
            set
            {
                _CRIMINAL_ID = value;
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
        public String COURT_NAME
        {
            get
            {
                return _COURT_NAME;
            }
            set
            {
                _COURT_NAME = value;
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
        public Decimal COLUMN_50
        {
            get
            {
                return _COLUMN_50;
            }
            set
            {
                _COLUMN_50 = value;
            }
        }
        public Decimal COLUMN_51
        {
            get
            {
                return _COLUMN_51;
            }
            set
            {
                _COLUMN_51 = value;
            }
        }
        public Decimal COLUMN_52
        {
            get
            {
                return _COLUMN_52;
            }
            set
            {
                _COLUMN_52 = value;
            }
        }
        public Decimal COLUMN_53
        {
            get
            {
                return _COLUMN_53;
            }
            set
            {
                _COLUMN_53 = value;
            }
        }
        public Decimal COLUMN_54
        {
            get
            {
                return _COLUMN_54;
            }
            set
            {
                _COLUMN_54 = value;
            }
        }
        public Decimal COLUMN_55
        {
            get
            {
                return _COLUMN_55;
            }
            set
            {
                _COLUMN_55 = value;
            }
        }
        public Decimal COLUMN_56
        {
            get
            {
                return _COLUMN_56;
            }
            set
            {
                _COLUMN_56 = value;
            }
        }
        public Decimal COLUMN_57
        {
            get
            {
                return _COLUMN_57;
            }
            set
            {
                _COLUMN_57 = value;
            }
        }
        public Decimal COLUMN_58
        {
            get
            {
                return _COLUMN_58;
            }
            set
            {
                _COLUMN_58 = value;
            }
        }
        public Decimal COLUMN_59
        {
            get
            {
                return _COLUMN_59;
            }
            set
            {
                _COLUMN_59 = value;
            }
        }
        public Decimal COLUMN_60
        {
            get
            {
                return _COLUMN_60;
            }
            set
            {
                _COLUMN_60 = value;
            }
        }
        public Decimal COLUMN_61
        {
            get
            {
                return _COLUMN_61;
            }
            set
            {
                _COLUMN_61 = value;
            }
        }
        public Decimal COLUMN_62
        {
            get
            {
                return _COLUMN_62;
            }
            set
            {
                _COLUMN_62 = value;
            }
        }
        public Decimal COLUMN_63
        {
            get
            {
                return _COLUMN_63;
            }
            set
            {
                _COLUMN_63 = value;
            }
        }
        public Decimal COLUMN_64

        {
            get
            {
                return _COLUMN_64;
            }
            set
            {
                _COLUMN_64 = value;
            }
        }
        public Decimal COLUMN_65
        {
            get
            {
                return _COLUMN_65;
            }
            set
            {
                _COLUMN_65 = value;
            }
        }
        public Decimal COLUMN_66
        {
            get
            {
                return _COLUMN_66;
            }
            set
            {
                _COLUMN_66 = value;
            }
        }
        public Decimal COLUMN_67
        {
            get
            {
                return _COLUMN_67;
            }
            set
            {
                _COLUMN_67 = value;
            }
        }
        public Decimal COLUMN_68
        {
            get
            {
                return _COLUMN_68;
            }
            set
            {
                _COLUMN_68 = value;
            }
        }
        public Decimal COLUMN_69
        {
            get
            {
                return _COLUMN_69;
            }
            set
            {
                _COLUMN_69 = value;
            }
        }
        public Decimal COLUMN_70
        {
            get
            {
                return _COLUMN_70;
            }
            set
            {
                _COLUMN_70 = value;
            }
        }
        public Decimal COLUMN_71
        {
            get
            {
                return _COLUMN_71;
            }
            set
            {
                _COLUMN_71 = value;
            }
        }
        public Decimal COLUMN_72
        {
            get
            {
                return _COLUMN_72;
            }
            set
            {
                _COLUMN_72 = value;
            }
        }
        public Decimal COLUMN_73
        {
            get
            {
                return _COLUMN_73;
            }
            set
            {
                _COLUMN_73 = value;
            }
        }
        public Decimal COLUMN_74
        {
            get
            {
                return _COLUMN_74;
            }
            set
            {
                _COLUMN_74 = value;
            }
        }
        public Decimal COLUMN_75
        {
            get
            {
                return _COLUMN_75;
            }
            set
            {
                _COLUMN_75 = value;
            }
        }
        public Decimal COLUMN_76
        {
            get
            {
                return _COLUMN_76;
            }
            set
            {
                _COLUMN_76 = value;
            }
        }
        public Decimal COLUMN_77
        {
            get
            {
                return _COLUMN_77;
            }
            set
            {
                _COLUMN_77 = value;
            }
        }
        public Decimal COLUMN_78
        {
            get
            {
                return _COLUMN_78;
            }
            set
            {
                _COLUMN_78 = value;
            }
        }
        public Decimal COLUMN_79
        {
            get
            {
                return _COLUMN_79;
            }
            set
            {
                _COLUMN_79 = value;
            }
        }
        public Decimal COLUMN_80
        {
            get
            {
                return _COLUMN_80;
            }
            set
            {
                _COLUMN_80 = value;
            }
        }
        public Decimal COLUMN_81
        {
            get
            {
                return _COLUMN_81;
            }
            set
            {
                _COLUMN_81 = value;
            }
        }
        public Decimal COLUMN_82
        {
            get
            {
                return _COLUMN_82;
            }
            set
            {
                _COLUMN_82 = value;
            }
        }
        public Decimal COLUMN_83
        {
            get
            {
                return _COLUMN_83;
            }
            set
            {
                _COLUMN_83 = value;
            }
        }
        public Decimal COLUMN_84
        {
            get
            {
                return _COLUMN_84;
            }
            set
            {
                _COLUMN_84 = value;
            }
        }
        public Decimal COLUMN_85
        {
            get
            {
                return _COLUMN_85;
            }
            set
            {
                _COLUMN_85 = value;
            }
        }
        public Decimal COLUMN_86
        {
            get
            {
                return _COLUMN_86;
            }
            set
            {
                _COLUMN_86 = value;
            }
        }
        public Decimal COLUMN_87
        {
            get
            {
                return _COLUMN_87;
            }
            set
            {
                _COLUMN_87 = value;
            }
        }
        public Decimal COLUMN_88
        {
            get
            {
                return _COLUMN_88;
            }
            set
            {
                _COLUMN_88 = value;
            }
        }
        public Decimal COLUMN_89
        {
            get
            {
                return _COLUMN_89;
            }
            set
            {
                _COLUMN_89 = value;
            }
        }
        public Decimal COLUMN_90
        {
            get
            {
                return _COLUMN_90;
            }
            set
            {
                _COLUMN_90 = value;
            }
        }
        public Decimal COLUMN_91
        {
            get
            {
                return _COLUMN_91;
            }
            set
            {
                _COLUMN_91 = value;
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
        public Judge_Criminal()
        {

        }
        public Judge_Criminal(Decimal ID, Decimal TYPES, Decimal COURT_ID,Decimal COURT_EXTID, Decimal REPORT_TIME_ID, Decimal CASES_ID, String CASE_NAME, Decimal COLUMN_1, Decimal COLUMN_2, Decimal COLUMN_3, Decimal COLUMN_4, Decimal COLUMN_5, Decimal COLUMN_6, Decimal COLUMN_7, Decimal COLUMN_8, Decimal COLUMN_9, Decimal COLUMN_10, Decimal COLUMN_11, Decimal COLUMN_12, Decimal COLUMN_13, Decimal COLUMN_14, Decimal COLUMN_15, Decimal COLUMN_16, Decimal COLUMN_17, Decimal COLUMN_18, Decimal COLUMN_19, Decimal COLUMN_20, Decimal COLUMN_21, Decimal COLUMN_22, Decimal COLUMN_23, Decimal COLUMN_24, Decimal COLUMN_25, Decimal COLUMN_26, Decimal COLUMN_27, Decimal COLUMN_28, Decimal COLUMN_29, Decimal COLUMN_30, Decimal COLUMN_31, Decimal COLUMN_32, Decimal COLUMN_33, Decimal COLUMN_34, Decimal COLUMN_35, Decimal COLUMN_36, Decimal COLUMN_37, Decimal COLUMN_38, Decimal COLUMN_39, Decimal COLUMN_40, Decimal COLUMN_41, Decimal COLUMN_42, Decimal COLUMN_43, Decimal COLUMN_44, Decimal COLUMN_45, Decimal COLUMN_46, Decimal COLUMN_47, Decimal COLUMN_48, Decimal COLUMN_49, Decimal COLUMN_50, Decimal COLUMN_51, Decimal COLUMN_52, Decimal COLUMN_53, Decimal COLUMN_54, Decimal COLUMN_55, Decimal COLUMN_56, Decimal COLUMN_57, Decimal COLUMN_58, Decimal COLUMN_59, Decimal COLUMN_60, Decimal COLUMN_61, Decimal COLUMN_62, Decimal COLUMN_63, Decimal COLUMN_64, Decimal COLUMN_65, Decimal COLUMN_66, Decimal COLUMN_67, Decimal COLUMN_68, Decimal COLUMN_69, Decimal COLUMN_70, Decimal COLUMN_71, Decimal COLUMN_72, Decimal COLUMN_73, Decimal COLUMN_74, Decimal COLUMN_75, Decimal COLUMN_76, Decimal COLUMN_77, Decimal COLUMN_78, Decimal COLUMN_79, Decimal COLUMN_80, Decimal COLUMN_81, Decimal COLUMN_82, Decimal COLUMN_83, Decimal COLUMN_84, Decimal COLUMN_85,Decimal COLUMN_86, Decimal COLUMN_87, Decimal COLUMN_88, Decimal COLUMN_89, Decimal COLUMN_90, Decimal COLUMN_91, String CREATE_USER, DateTime CREATE_DATE)
        {
            _ID = ID;
            _TYPES = TYPES;        
            _COURT_ID = COURT_ID;
            _COURT_EXTID = COURT_EXTID;
            _REPORT_TIME_ID = REPORT_TIME_ID;
            _CASES_ID = CASES_ID;
            _CASE_NAME = CASE_NAME;
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
            _COLUMN_50 = COLUMN_50;
            _COLUMN_51 = COLUMN_51;
            _COLUMN_52 = COLUMN_52;
            _COLUMN_53 = COLUMN_53;
            _COLUMN_54 = COLUMN_54;
            _COLUMN_55 = COLUMN_55;
            _COLUMN_56 = COLUMN_56;
            _COLUMN_57 = COLUMN_57;
            _COLUMN_58 = COLUMN_58;
            _COLUMN_59 = COLUMN_59;
            _COLUMN_60 = COLUMN_60;
            _COLUMN_61 = COLUMN_61;
            _COLUMN_62 = COLUMN_62;
            _COLUMN_63 = COLUMN_63;
            _COLUMN_64 = COLUMN_64;
            _COLUMN_65 = COLUMN_65;
            _COLUMN_66 = COLUMN_66;
            _COLUMN_67 = COLUMN_67;
            _COLUMN_68 = COLUMN_68;
            _COLUMN_69 = COLUMN_69;
            _COLUMN_70 = COLUMN_70;
            _COLUMN_71 = COLUMN_71;
            _COLUMN_72 = COLUMN_72;
            _COLUMN_73 = COLUMN_73;
            _COLUMN_74 = COLUMN_74;
            _COLUMN_75 = COLUMN_75;
            _COLUMN_76 = COLUMN_76;
            _COLUMN_77 = COLUMN_77;
            _COLUMN_78 = COLUMN_78;
            _COLUMN_79 = COLUMN_79;
            _COLUMN_80 = COLUMN_80;
            _COLUMN_81 = COLUMN_81;
            _COLUMN_82 = COLUMN_82;
            _COLUMN_83 = COLUMN_83;
            _COLUMN_84 = COLUMN_84;
            _COLUMN_85 = COLUMN_85;
            _COLUMN_86 = COLUMN_86;
            _COLUMN_87 = COLUMN_87;
            _COLUMN_88 = COLUMN_88;
            _COLUMN_89 = COLUMN_89;
            _COLUMN_90 = COLUMN_90;
            _COLUMN_91 = COLUMN_91;
            _CREATE_DATE = CREATE_DATE;
            _CREATE_USER = CREATE_USER;         
        }
        #endregion
    }
}
