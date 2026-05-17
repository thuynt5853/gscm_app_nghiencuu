using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Roles
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _ID_FUNCTIONS;
        private Decimal _ID_PERMISSION;             
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
         public Decimal ID_FUNCTIONS
        {
            get
            {
                return _ID_FUNCTIONS;
            }
            set
            {
                _ID_FUNCTIONS = value;
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
        #endregion
        #region Constructors
        public Roles()
        {
        }
        public Roles(Decimal ID, Decimal ID_FUNCTIONS, Decimal ID_PERMISSION)
        {
            _ID=ID;
            _ID_FUNCTIONS = ID_FUNCTIONS;
            _ID_PERMISSION = ID_PERMISSION;            
        }
        #endregion

    }
}
