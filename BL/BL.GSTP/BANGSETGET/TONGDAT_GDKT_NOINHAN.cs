using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class TONGDAT_GDKT_NOINHAN
    {
        private decimal _ID;
        private decimal _TONGDAT_GDKT_ID;
        private decimal? _DOITUONG;
        private decimal? _NOINHAN_ID;
        private string _NOINHAN;
        private string _TUCACHTOTUNG;
        private string _DIACHI;
        private decimal? _TRANGTHAI;
        private string _LYDO;
        private DateTime? _NGAYGUI;        
        private decimal? _HINHTHUCGUI;
        private decimal? _PHATHANHLAI_ID;
        private decimal _IS_SUA;
        private DateTime? _NGAYPHATHANH;
        private DateTime? _NGAYNHAN;
        private DateTime? _NGAYTAO;
        private string _NGUOITAO;

        public TONGDAT_GDKT_NOINHAN()
        {

        }
        public TONGDAT_GDKT_NOINHAN(decimal ID, decimal VUAN_ID, decimal DOITUONG, decimal NOINHAN_ID, string NOINHAN, string TUCACHTOTUNG, string DIACHI, decimal TRANGTHAI, 
            string LYDO, DateTime NGAYGUI, DateTime NGAYPHATHANH, DateTime NGAYNHAN, decimal HINHTHUCGUI, decimal PHATHANHLAI_ID, decimal _IS_SUA, DateTime NGAYTAO, string NGUOITAO)
        {
            this.ID = ID;
            this.TONGDAT_GDKT_ID = TONGDAT_GDKT_ID;
            this.DOITUONG = DOITUONG;
            this.NOINHAN_ID = NOINHAN_ID;
            this.NOINHAN = NOINHAN;
            this.TUCACHTOTUNG = TUCACHTOTUNG;
            this.DIACHI = DIACHI;
            this.TRANGTHAI = TRANGTHAI;
            this.LYDO = LYDO;
            this.NGAYGUI = NGAYGUI;
            this.NGAYPHATHANH = NGAYPHATHANH;
            this.NGAYNHAN = NGAYNHAN;
            this.HINHTHUCGUI = HINHTHUCGUI;
            this.PHATHANHLAI_ID = PHATHANHLAI_ID;
            this.IS_SUA = IS_SUA;
            this.NGAYTAO = NGAYTAO;
            this.NGUOITAO = NGUOITAO;
        }

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
        public Decimal TONGDAT_GDKT_ID
        {
            get
            {
                return _TONGDAT_GDKT_ID;
            }
            set
            {
                _TONGDAT_GDKT_ID = value;
            }
        }
        public Decimal? DOITUONG
        {
            get
            {
                return _DOITUONG;
            }
            set
            {
                _DOITUONG = value;
            }
        }
        public Decimal? NOINHAN_ID
        {
            get
            {
                return _NOINHAN_ID;
            }
            set
            {
                _NOINHAN_ID = value;
            }
        }
        public String NOINHAN
        {
            get
            {
                return _NOINHAN;
            }
            set
            {
                _NOINHAN = value;
            }
        }
        public String TUCACHTOTUNG
        {
            get
            {
                return _TUCACHTOTUNG;
            }
            set
            {
                _TUCACHTOTUNG = value;
            }
        }
        public String DIACHI
        {
            get
            {
                return _DIACHI;
            }
            set
            {
                _DIACHI = value;
            }
        }
        public Decimal? TRANGTHAI
        {
            get
            {
                return _TRANGTHAI;
            }
            set
            {
                _TRANGTHAI = value;
            }
        }
        public DateTime? NGAYGUI
        {
            get
            {
                return _NGAYGUI;
            }
            set
            {
                _NGAYGUI = value;
            }
        }
        public string LYDO
        {
            get
            {
                return _LYDO;
            }
            set
            {
                _LYDO = value;
            }
        }
        public Decimal? HINHTHUCGUI
        {
            get
            {
                return _HINHTHUCGUI;
            }
            set
            {
                _HINHTHUCGUI = value;
            }
        }
        public Decimal? PHATHANHLAI_ID
        {
            get
            {
                return _PHATHANHLAI_ID;
            }
            set
            {
                _PHATHANHLAI_ID = value;
            }
        }
        public DateTime? NGAYPHATHANH
        {
            get
            {
                return _NGAYPHATHANH;
            }
            set
            {
                _NGAYPHATHANH = value;
            }
        }
        public DateTime? NGAYNHAN
        {
            get
            {
                return _NGAYNHAN;
            }
            set
            {
                _NGAYNHAN = value;
            }
        }
        public DateTime? NGAYTAO
        {
            get
            {
                return _NGAYTAO;
            }
            set
            {
                _NGAYTAO = value;
            }
        }
        public string NGUOITAO
        {
            get
            {
                return _NGUOITAO;
            }
            set
            {
                _NGUOITAO = value;
            }
        }
        public Decimal IS_SUA
        {
            get
            {
                return _IS_SUA;
            }
            set
            {
                _IS_SUA = value;
            }
        }
    }
}