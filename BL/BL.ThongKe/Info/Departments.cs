using System;
using System.Collections.Generic;
using System.Text;
namespace BL.THONGKE.Info
{
    public class Departments
    {
        #region Private Member variables 
        private Decimal _ID;
        private String _ID_DEPARTMENT;
        private String _DEPARTMENT_NAME;       
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
        public String ID_DEPARTMENT
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
        public String DEPARTMENT_NAME
        {
            get
            {
                return _DEPARTMENT_NAME;
            }
            set
            {
                _DEPARTMENT_NAME = value;
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
        public Departments()
        {
        }
        public Departments(Decimal ID, String ID_DEPARTMENT, String DEPARTMENT_NAME, String DESCRIPTION)
        {
            _ID=ID;
            _ID_DEPARTMENT = ID_DEPARTMENT;
            _DEPARTMENT_NAME = DEPARTMENT_NAME;           
            _DESCRIPTION=DESCRIPTION;
        }
        #endregion

    }
}
