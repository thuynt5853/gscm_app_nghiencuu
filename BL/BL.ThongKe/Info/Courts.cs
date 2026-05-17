using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Courts
    {
        #region Private Member variables       
        private Decimal _ID;
        private String _COURT_ID;
        private String _COURT_NAME;
        private String _TYPE;
        private Decimal _USER_TYPE;
        private Decimal _PARENT_ID;
        private Decimal _EXPANDEDS;
        #endregion
        #region Public properties 
        public Decimal EXPANDEDS
        {
            get
            {
                return _EXPANDEDS;
            }
            set
            {
                _EXPANDEDS = value;
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
        public String COURT_ID
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
        #endregion
        #region Constructors
        public Courts()
        {
        }
        public Courts(Decimal ID, Decimal PARENT_ID, String COURT_ID, String COURT_NAME, String TYPE, Decimal USER_TYPE)
        {
            _ID=ID;
            _COURT_ID=COURT_ID;
            _COURT_NAME=COURT_NAME;
            _TYPE=TYPE;
            _USER_TYPE = USER_TYPE;
            _PARENT_ID = PARENT_ID;
        }
        #endregion

    }
}
