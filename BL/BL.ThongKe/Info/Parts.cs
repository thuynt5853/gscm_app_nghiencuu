using System;
using System.Collections.Generic;
using System.Text;
namespace BL.THONGKE.Info
{
    public class Parts
    {
        #region Private Member variables         
        private Decimal _ID;
        private String _ID_PART;
        private String _PART_NAME;       
        private Decimal _ID_DEPARTMENT;
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
        public String ID_PART
        {
            get
            {
                return _ID_PART;
            }
            set
            {
                _ID_PART = value;
            }
        }
        public String PART_NAME
        {
            get
            {
                return _PART_NAME;
            }
            set
            {
                _PART_NAME = value;
            }
        }
        public Decimal ID_DEPARTMENT
        {
            get
            {
                return _ID_DEPARTMENT;
            }
            set
            {
                _ID_DEPARTMENT = value;
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
        public Parts()
        {
        }
        public Parts(Decimal ID, String ID_PART, String PART_NAME, Decimal ID_DEPARTMENT, String DESCRIPTION)
        {
            _ID=ID;
            _ID_PART = ID_PART;
            _PART_NAME = PART_NAME;
            _ID_DEPARTMENT = ID_DEPARTMENT;           
            _DESCRIPTION=DESCRIPTION;
        }
        #endregion

    }
}
