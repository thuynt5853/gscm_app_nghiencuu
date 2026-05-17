using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class TimeCriminals
    {
        #region Private Member variables       
        private Decimal _ID;
        private String _TIME_NAME;       
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
        public String TIME_NAME
        {
            get
            {
                return _TIME_NAME;
            }
            set
            {
                _TIME_NAME = value;
            }
        }                              
        #endregion
        #region Constructors
        public TimeCriminals()
        {
        }
        public TimeCriminals(Decimal ID, String TIME_NAME)
        {
            _ID=ID;
            _TIME_NAME = TIME_NAME;           
        }
        #endregion

    }
}
