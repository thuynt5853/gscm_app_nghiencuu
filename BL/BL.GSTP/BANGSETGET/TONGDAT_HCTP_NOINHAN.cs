using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class TONGDAT_HCTP_NOINHAN
    {
        #region Private Member variables  
        private decimal _ID;
        private decimal _TONGDAT_HCTP_ID;
        private decimal _DOITUONG;
        private decimal? _NOINHAN_ID;
        private string _NOINHAN;
        private string _TUCACHTOTUNG;
        private string _DIACHI;
        private decimal? _TRANGTHAI;
        private string _LYDO;
        private DateTime _NGAYGUI;
        private DateTime _NGAYPHATHANH;
        private DateTime _NGAYNHAN;
        private decimal _HINHTHUCGUI;
        private decimal? _PHATHANHLAI_ID;
        private DateTime _NGAYTAO;
        private string _NGUOITAO;
        #endregion

        #region Constructors
        public TONGDAT_HCTP_NOINHAN()
        {

        }
        public TONGDAT_HCTP_NOINHAN(decimal ID, decimal TONGDAT_HCTP_ID, decimal DOITUONG, decimal? NOINHAN_ID, string NOINHAN, string TUCACHTOTUNG, string DIACHI, decimal? TRANGTHAI, string LYDO, DateTime NGAYGUI, DateTime NGAYPHATHANH, DateTime NGAYNHAN, decimal HINHTHUCGUI, decimal? PHATHANHLAI_ID, DateTime NGAYTAO, string NGUOITAO)
        {
            _ID = ID;
            _TONGDAT_HCTP_ID = TONGDAT_HCTP_ID;
            _DOITUONG = DOITUONG;
            _NOINHAN_ID = NOINHAN_ID;
            _NOINHAN = NOINHAN;
            _TUCACHTOTUNG = TUCACHTOTUNG;
            _DIACHI = DIACHI;
            _TRANGTHAI = TRANGTHAI;
            _LYDO = LYDO;
            _NGAYGUI = NGAYGUI;
            _NGAYPHATHANH = NGAYPHATHANH;
            _NGAYNHAN = NGAYNHAN;
            _HINHTHUCGUI = HINHTHUCGUI;
            _PHATHANHLAI_ID = PHATHANHLAI_ID;
            _NGAYTAO = NGAYTAO;
            _NGUOITAO = NGUOITAO;
        }
        #endregion

        #region Public properties
        public decimal ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public decimal TONGDAT_HCTP_ID
        {
            get { return _TONGDAT_HCTP_ID; }
            set { _TONGDAT_HCTP_ID = value; }
        }
        public decimal DOITUONG
        {
            get { return _DOITUONG; }
            set { _DOITUONG = value; }
        }
        public decimal? NOINHAN_ID
        {
            get { return _NOINHAN_ID; }
            set { _NOINHAN_ID = value; }
        }
        public string NOINHAN
        {
            get { return _NOINHAN; }
            set { _NOINHAN = value; }
        }
        public string TUCACHTOTUNG
        {
            get { return _TUCACHTOTUNG; }
            set { _TUCACHTOTUNG = value; }
        }
        public string DIACHI
        {
            get { return _DIACHI; }
            set { _DIACHI = value; }
        }
        public decimal? TRANGTHAI
        {
            get { return _TRANGTHAI; }
            set { _TRANGTHAI = value; }
        }
        public string LYDO
        {
            get { return _LYDO; }
            set { _LYDO = value; }
        }
        public DateTime NGAYGUI
        {
            get { return _NGAYGUI; }
            set { _NGAYGUI = value; }
        }
        public DateTime NGAYPHATHANH
        {
            get { return _NGAYPHATHANH; }
            set { _NGAYPHATHANH = value; }
        }
        public DateTime NGAYNHAN
        {
            get { return _NGAYNHAN; }
            set { _NGAYNHAN = value; }
        }
        public decimal HINHTHUCGUI
        {
            get { return _HINHTHUCGUI; }
            set { _HINHTHUCGUI = value; }
        }
        public decimal? PHATHANHLAI_ID
        {
            get { return _PHATHANHLAI_ID; }
            set { _PHATHANHLAI_ID = value; }
        }
        public DateTime NGAYTAO
        {
            get { return _NGAYTAO; }
            set { _NGAYTAO = value; }
        }
        public string NGUOITAO
        {
            get { return _NGUOITAO; }
            set { _NGUOITAO = value; }
        }
        #endregion
    }
}