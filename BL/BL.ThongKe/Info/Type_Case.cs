using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace BL.THONGKE.Info
{
    public class Type_Case
    {
        #region Private Member variables       
        private Decimal _ID;
        private String _NAME;
        private Decimal _ORDERS;        
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
        public String NAME
        {
            get
            {
                return _NAME;
            }
            set
            {
                _NAME = value;
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
        #endregion
        #region Constructors
        public Type_Case()
        {

        }
        public Type_Case(Decimal ID,String NAME,Decimal ORDERS)
        {
            _ID = ID;
            _NAME = NAME;
            _ORDERS = ORDERS;
        }
        #endregion
    }
}
