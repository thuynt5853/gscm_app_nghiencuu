using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE.Info
{
    public class Chapters
    {
        #region Private Member variables       
        private Decimal _ID;
        private String _CHAPTER_ID;
        private String _CHAPER_NAME;           
        private String _DESCRIPTION;
        private Decimal _TIMES;  
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
        public Decimal TIMES
        {
            get
            {
                return _TIMES;
            }
            set
            {
                _TIMES = value;
            }
        }
        public String CHAPTER_ID
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
        public String CHAPER_NAME
        {
            get
            {
                return _CHAPER_NAME;
            }
            set
            {
                _CHAPER_NAME = value;
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
        public Chapters()
        {
        }
        public Chapters(Decimal ID,Decimal TIMES, String CHAPTER_ID, String CHAPER_NAME, String DESCRIPTION)
        {
            _ID=ID;
            _CHAPTER_ID = CHAPTER_ID;
            _CHAPER_NAME = CHAPER_NAME;            
            _DESCRIPTION = DESCRIPTION;
            _TIMES= TIMES;
        }
        #endregion

    }
}
