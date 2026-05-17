using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace BL.THONGKE.Info
{
   public class Judge_Report
    {

        #region Private Member variables       
        private String _Text_Report;
        #endregion
        #region Public properties   
        public String Text_Report
        {
            get
            {
                return _Text_Report;
            }
            set
            {
                _Text_Report = value;
            }
        }        
        #endregion
          #region Constructors
        public Judge_Report()
        {

        }
        public Judge_Report(String Text_Report)
        {
            _Text_Report = Text_Report;
        }
        #endregion
    }
}
