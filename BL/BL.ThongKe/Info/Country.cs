using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BL.THONGKE.Info
{
   public class Country 
    {
        #region Private Member variables         
        private Decimal _ID;
        private Decimal _Row_;
        private Decimal _TotalRecord;
        private String _KEYS_NAME;
        private String _COUNTRY_NAME;
        private String _COUNTRY_NAME_VN;        
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
        public String KEYS_NAME
        {
            get
            {
                return _KEYS_NAME;
            }
            set
            {
                _KEYS_NAME = value;
            }
        }
        public String COUNTRY_NAME
        {
            get
            {
                return _COUNTRY_NAME;
            }
            set
            {
                _COUNTRY_NAME = value;
            }
        }
        public String COUNTRY_NAME_VN
        {
            get
            {
                return _COUNTRY_NAME_VN;
            }
            set
            {
                _COUNTRY_NAME_VN = value;
            }
        }          
        #endregion
        #region Constructors
        public Country()
        {
        }
        public Country(Decimal ID, String KEYS_NAME, String NAME_VN, String COUNTRY_NAME_VN)
        {
            _ID=ID;
            _KEYS_NAME = KEYS_NAME;
            _COUNTRY_NAME = COUNTRY_NAME;
            _COUNTRY_NAME_VN = COUNTRY_NAME_VN;           
        }
        #endregion
    }
}
