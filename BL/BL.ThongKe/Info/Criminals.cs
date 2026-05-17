using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Criminals
    {
        #region Private Member variables   
        private Decimal _ID;
        private Decimal _CHAPTER_ID;
        private String _CRIMINAL_ID;           
        private String _CRIMINAL_NAME;
        private Decimal _YOUTH;  
        private Decimal _DEATH;  
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
        public Decimal YOUTH
        {
            get
            {
                return _YOUTH;
            }
            set
            {
                _YOUTH = value;
            }
        }
        public Decimal DEATH
        {
            get
            {
                return _DEATH;
            }
            set
            {
                _DEATH = value;
            }
        }
        public Decimal CHAPTER_ID
        {
            get
            {
                return _CHAPTER_ID;
            }
            set
            {
                _CHAPTER_ID = value;
            }
        }
        public String CRIMINAL_NAME
        {
            get
            {
                return _CRIMINAL_NAME;
            }
            set
            {
                _CRIMINAL_NAME = value;
            }
        }
        public String CRIMINAL_ID
        {
            get
            {
                return _CRIMINAL_ID;
            }
            set
            {
                _CRIMINAL_ID = value;
            }
        }                    
        #endregion
        #region Constructors
        public Criminals()
        {
        }
        public Criminals(Decimal ID, Decimal DEATH, Decimal YOUTH, Decimal CHAPTER_ID, String CRIMINAL_ID, String CRIMINAL_NAME)
        {
            _ID=ID;
            _DEATH = DEATH;
            _YOUTH = YOUTH;
            _CHAPTER_ID = CHAPTER_ID;
            _CRIMINAL_ID = CRIMINAL_ID;
            _CRIMINAL_NAME = CRIMINAL_NAME;
        }
        #endregion

    }
}
