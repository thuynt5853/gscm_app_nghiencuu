using System;
using System.Collections.Generic;
using System.Text;

namespace BL.THONGKE.Info
{
    public class CriminalChapter
    {
        #region Private Member variables        
        private Decimal _CHAPTER_ID;

        public Decimal CHAPTER_ID
        {
            get { return _CHAPTER_ID; }
            set { _CHAPTER_ID = value; }
        }
        private String _CHAPTER_NAME;

        public String CHAPTER_NAME
        {
            get { return _CHAPTER_NAME; }
            set { _CHAPTER_NAME = value; }
        }

        
        private Decimal _COLUMN_7;

        public Decimal COLUMN_7
        {
            get { return _COLUMN_7; }
            set { _COLUMN_7 = value; }
        }
        private Decimal _COLUMN_8;

        public Decimal COLUMN_8
        {
            get { return _COLUMN_8; }
            set { _COLUMN_8 = value; }
        }
        
        private Decimal _COLUMN_16;

        public Decimal COLUMN_16
        {
            get { return _COLUMN_16; }
            set { _COLUMN_16 = value; }
        }
        private Decimal _COLUMN_17;

        public Decimal COLUMN_17
        {
            get { return _COLUMN_17; }
            set { _COLUMN_17 = value; }
        }
        

        #endregion
    }
}
