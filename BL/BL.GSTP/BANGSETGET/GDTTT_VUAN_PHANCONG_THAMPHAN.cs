using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class GDTTT_VUAN_PHANCONG_THAMPHAN
    {
        #region Private Member variables  
        private Decimal _ID;
        private Decimal _THAMPHAN_ID_OLD;
        private DateTime _TUNGAY;
        private Decimal _THAMPHAN_ID_NEW;
        private DateTime _DENNGAY;
        private Decimal _VUANID;
        private Decimal _DONID;
        private String _LYDO;
        private Decimal _GIAIDOAN;
        private Decimal _CANBOSUA_ID;
        private String _SOTT;
        private DateTime _NGAYTT;

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
        public Decimal THAMPHAN_ID_OLD
        {
            get{ return _THAMPHAN_ID_OLD; }
            set{ _THAMPHAN_ID_OLD = value;}
        }
        public DateTime TUNGAY
        {
            get { return _TUNGAY; }
            set { _TUNGAY = value; }
        }
        public Decimal THAMPHAN_ID_NEW
        {
            get { return _THAMPHAN_ID_NEW; }
            set { _THAMPHAN_ID_NEW = value; }
        }
        public DateTime DENNGAY
        {
            get { return _DENNGAY; }
            set { _DENNGAY = value; }
        }
        public Decimal VUANID
        {
            get { return _VUANID; }
            set { _VUANID = value; }
        }

        public Decimal DONID
        {
            get { return _DONID; }
            set { _DONID = value; }
        }
        public String LYDO
        {
            get { return _LYDO; }
            set { _LYDO = value; }
        }
        public Decimal GIAIDOAN
        {
            get { return _GIAIDOAN; }
            set { _GIAIDOAN = value; }
        }
        public Decimal CANBOSUA_ID
        {
            get { return _CANBOSUA_ID; }
            set { _CANBOSUA_ID = value; }
        }
        public String SOTT
        {
            get { return _SOTT; }
            set { _SOTT = value; }
        }
        public DateTime NGAYTT
        {
            get { return _NGAYTT; }
            set { _NGAYTT = value; }
        }
        #endregion
        #region Constructors
        public GDTTT_VUAN_PHANCONG_THAMPHAN() { }
        public GDTTT_VUAN_PHANCONG_THAMPHAN(Decimal ID, Decimal THAMPHAN_ID_OLD, DateTime TUNGAY, Decimal THAMPHAN_ID_NEW, DateTime DENNGAY, Decimal DONID
            , Decimal VUANID, String LYDO, Decimal GIAIDOAN, Decimal CANBOSUA_ID,String SOTT, DateTime NGAYTT)
        {
            _ID = ID;
            _VUANID = VUANID;
            _DONID = DONID;
            _THAMPHAN_ID_OLD = THAMPHAN_ID_OLD;
            _TUNGAY = TUNGAY;
            _THAMPHAN_ID_NEW = THAMPHAN_ID_NEW;
            _DENNGAY = DENNGAY;
            _LYDO = LYDO;
            _GIAIDOAN = GIAIDOAN;
            _CANBOSUA_ID = CANBOSUA_ID;
            _SOTT = SOTT;
            _NGAYTT = NGAYTT;
        }
        #endregion
    }
}