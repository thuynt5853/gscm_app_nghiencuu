using System;
using System.Collections.Generic;
using System.Text;

namespace BL.THONGKE.Info
{
   public class Cases
    {
         #region Private Member variables         
        private Decimal _ID;
        private String _CASE_ID;
        private String _CASE_NAME;
        private Decimal _STYLES;
        private Decimal _OPTIONS;
        private Decimal _PARENT_ID;
        private Decimal _ORDERS;       
        private String _DESCRIPTIONS;
        private Decimal _ENABLE;
        #endregion
        #region Public properties 
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
        public String DESCRIPTIONS
        {
            get
            {
                return _DESCRIPTIONS;
            }
            set
            {
                _DESCRIPTIONS = value;
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
        public String CASE_ID
        {
            get
            {
                return _CASE_ID;
            }
            set
            {
                _CASE_ID = value;
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
        public Decimal STYLES
        {
            get
            {
                return _STYLES;
            }
            set
            {
                _STYLES = value;
            }
        }
        public Decimal OPTIONS
        {
            get
            {
                return _OPTIONS;
            }
            set
            {
                _OPTIONS = value;
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
        #endregion
        #region Constructors
        public Cases()
        {
        }
        public Cases(Decimal ORDERS, Decimal PARENT_ID, String DESCRIPTIONS, Decimal ID, String CASE_ID, String CASE_NAME, Decimal STYLES, Decimal OPTIONS, Decimal ENABLE)
        {
            _ID=ID;
            _CASE_NAME = CASE_ID;
            _CASE_NAME = CASE_NAME;
            _STYLES = STYLES;
            _OPTIONS = OPTIONS;
            _DESCRIPTIONS = DESCRIPTIONS;
            _PARENT_ID = PARENT_ID;
            _ORDERS = ORDERS;
            _ENABLE = ENABLE;
        }
        #endregion
    }
}
