using System;
using System.Collections.Generic;
using System.Text;

namespace BL.THONGKE.Info
{
    public class Permissions
    {
        #region Private Member variables        
        private Decimal _ID;
        private String _PERMISSION_NAME;
        private Decimal _ENABLE;       
        private DateTime _CREATE_DATE;        
        private String _CREATE_USER;        
        private String _DESCRIPTION;               
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
        public String PERMISSION_NAME
        {
            get
            {
                return _PERMISSION_NAME;
            }
            set
            {
                _PERMISSION_NAME = value;
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
        #endregion
        #region Constructors
        public Permissions()
        {
        }
        public Permissions(Decimal ID, String PERMISSION_NAME, Decimal ENABLE, DateTime CREATE_DATE, String CREATE_USER, String DESCRIPTION)
        {
            _ID=ID;
            _PERMISSION_NAME = PERMISSION_NAME;
            _ENABLE = ENABLE;
            _CREATE_DATE = CREATE_DATE;
            _CREATE_USER = CREATE_USER;
            _DESCRIPTION = DESCRIPTION;                     
        }
        #endregion
    }
}
