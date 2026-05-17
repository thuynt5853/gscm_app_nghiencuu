using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Functions
    {
        #region Private Member variables 
           private Decimal _ID;
           private String _FUNCTION_NAME;
           private String _URL;
           private String _IMAGES;
           private Decimal _ID_PARENT;
           private Decimal _ORDERS;
           private Decimal _POSTION;
           private Decimal _ENABLE;
           private String _DESCRIPTION;
           private String _ID_ACCESS;
           private String _UrlPath;
           private String _DISTRICT_PROVIN;
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
        public String FUNCTION_NAME
        {
            get
            {
                return _FUNCTION_NAME;
            }
            set
            {
                _FUNCTION_NAME = value;
            }
        }
        public String URL
        {
            get
            {
                return _URL;
            }
            set
            {
                _URL = value;
            }
        }
        public String ID_ACCESS
        {
            get
            {
                return _ID_ACCESS;
            }
            set
            {
                _ID_ACCESS = value;
            }
        }
        public String IMAGES
        {
            get
            {
                return _IMAGES;
            }
            set
            {
                _IMAGES = value;
            }
        }
        public String UrlPath
        {
            get
            {
                return _UrlPath;
            }
            set
            {
                _UrlPath = value;
            }
        }
        public Decimal ID_PARENT
        {
            get
            {
                return _ID_PARENT;
            }
            set
            {
                _ID_PARENT = value;
            }
        }
        public Decimal POSTION
        {
            get
            {
                return _POSTION;
            }
            set
            {
                _POSTION = value;
            }
        } 
        public Decimal ORDERS
        {
            get
            {
                return _ORDERS;
            }
            set
            {
                _ORDERS = value;
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
        public String DISTRICT_PROVIN
        {
            get
            {
                return _DISTRICT_PROVIN;
            }
            set
            {
                _DISTRICT_PROVIN = value;
            }
        }
        #endregion
        #region Constructors
        public Functions()
        {
        }
        public Functions(Decimal ID,String ID_ACCESS,String FUNCTION_NAME, String URL, String IMAGES, Decimal ID_PARENT, Decimal ORDERS, Decimal ENABLE, String DESCRIPTION, Decimal POSTION, String DISTRICT_PROVIN)
        {
            _ID = ID;
            _FUNCTION_NAME = FUNCTION_NAME;
            _URL = URL;
            _IMAGES = IMAGES;
            _ID_PARENT = ID_PARENT;
            _ORDERS = ORDERS;
            _POSTION = POSTION;
            _ENABLE = ENABLE;
            _DESCRIPTION = DESCRIPTION;
            _ID_ACCESS = ID_ACCESS;
            _DISTRICT_PROVIN = DISTRICT_PROVIN;
        }
        #endregion

    }
}
