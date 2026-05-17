using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;

namespace BL.THONGKE.Info
{
   public class Plugin_Country
    {
        #region Private Member variables       
        private Decimal _ID_PLUGIN;
        private Decimal _ID_COUNTRY;       
        #endregion    
        #region Public properties      
        public Decimal ID_PLUGIN
        {
            get
            {
                return _ID_PLUGIN;
            }
            set
            {
                _ID_PLUGIN = value;
            }
        }
        public Decimal ID_COUNTRY
        {
            get
            {
                return _ID_COUNTRY;
            }
            set
            {
                _ID_COUNTRY = value;
            }
        }       
        #endregion
        #region Constructors
        public Plugin_Country()
        {
        }
        public Plugin_Country(Decimal ID_PLUGIN, Decimal ID_COUNTRY)
        {         
            _ID_PLUGIN = ID_PLUGIN;
            _ID_COUNTRY = ID_COUNTRY;                 
        }
        #endregion
   }
}
