using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Users
    {
        #region Private Member variables 
        private Decimal _Row_;
        private Decimal _TotalRecord;
        private Decimal _ID;
        private String _USERNAME;
        private String _PASSWORD;
        private String _FULLNAME;
        private String _ID_JOBTITLE;        
        private Decimal _SEX;
        private String _ADDRESS;
        private Decimal _ID_DEPARTMENT;
        private String _PHONE;
        private String _MOBILE;
        private String _EMAIL;
        private Decimal _ID_PERMISSION;
        private String _DESCRIPTION;
        private DateTime _CREATE_DATE;
        private Decimal _ENABLE;
        private Decimal _STATUS;
        private Decimal _ID_COURT;
        private Decimal _ID_PARTS;
        private String _COURT_NAME ;
        private String _TYPE;
        private String _BIRTHDAY;
        public Decimal _USER_TYPE;
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
        public Decimal USER_TYPE
        {
            get
            {
                return _USER_TYPE;
            }
            set
            {
                _USER_TYPE = value;
            }
        }
        public String BIRTHDAY
        {
            get
            {
                return _BIRTHDAY;
            }
            set
            {
                _BIRTHDAY = value;
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
        public String TYPE
        {
            get
            {
                return _TYPE;
            }
            set
            {
                _TYPE = value;
            }
        }
        public Decimal ID_PARTS
        {
            get
            {
                return _ID_PARTS;
            }
            set
            {
                _ID_PARTS = value;
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
        public String USERNAME
        {
            get
            {
                return _USERNAME;
            }
            set
            {
                _USERNAME = value;
            }
        }
        public String FULLNAME
        {
            get
            {
                return _FULLNAME;
            }
            set
            {
                _FULLNAME = value;
            }
        }
        public String PASSWORD
        {
            get
            {
                return _PASSWORD;
            }
            set
            {
                _PASSWORD = value;
            }
        }
        public String ID_JOBTITLE
        {
            get
            {
                return _ID_JOBTITLE;
            }
            set
            {
                _ID_JOBTITLE = value;
            }
        }     
        public Decimal SEX
        {
            get
            {
                return _SEX;
            }
            set
            {
                _SEX = value;
            }
        }
        public String ADDRESS
        {
            get
            {
                return _ADDRESS;
            }
            set
            {
                _ADDRESS = value;
            }
        }
        public Decimal ID_DEPARTMENT
        {
            get
            {
                return _ID_DEPARTMENT;
            }
            set
            {
                _ID_DEPARTMENT = value;
            }
        }
        public String PHONE
        {
            get
            {
                return _PHONE;
            }
            set
            {
                _PHONE = value;
            }
        }
        public String MOBILE
        {
            get
            {
                return _MOBILE;
            }
            set
            {
                _MOBILE = value;
            }
        }
        public String EMAIL
        {
            get
            {
                return _EMAIL;
            }
            set
            {
                _EMAIL = value;
            }
        }
        public Decimal ID_PERMISSION
        {
            get
            {
                return _ID_PERMISSION;
            }
            set
            {
                _ID_PERMISSION = value;
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
        public Decimal STATUS
        {
            get
            {
                return _STATUS;
            }
            set
            {
                _STATUS = value;
            }
        }
        public Decimal ID_COURT
        {
            get
            {
                return _ID_COURT;
            }
            set
            {
                _ID_COURT = value;
            }
        }
        #endregion
        #region Constructors
        public Users()
        {
        }
        public Users(String BIRTHDAY, String COURT_NAME, Decimal ID, String USERNAME, String PASSWORD, String FULLNAME, String ID_JOBTITLE, Decimal SEX, String ADDRESS, Decimal ID_DEPARTMENT, String PHONE, String MOBILE, String EMAIL, Decimal ID_PERMISSION, String DESCRIPTION, DateTime CREATE_DATE, Decimal ENABLE, Decimal STATUS, Decimal ID_COURT)
        {            
            _ID=ID;
            _USERNAME=USERNAME;
            _PASSWORD=PASSWORD;
            _FULLNAME=FULLNAME;
            _ID_JOBTITLE=ID_JOBTITLE;          
            _SEX=SEX;
            _ADDRESS=ADDRESS;
            _ID_DEPARTMENT=ID_DEPARTMENT;
            _PHONE=PHONE;
            _MOBILE=MOBILE;
            _EMAIL=EMAIL;
            _ID_PERMISSION = ID_PERMISSION;
            _DESCRIPTION=DESCRIPTION;
            _CREATE_DATE=CREATE_DATE;
            _ENABLE=ENABLE;
            _STATUS = STATUS;
            _ID_COURT = ID_COURT;
            _ID_PARTS = ID_PARTS;
            _COURT_NAME = COURT_NAME;
            _BIRTHDAY = BIRTHDAY;            
        }
        #endregion

    }
}
